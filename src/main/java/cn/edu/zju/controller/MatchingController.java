package cn.edu.zju.controller;

import cn.edu.zju.bean.DrugLabel;
import cn.edu.zju.bean.Sample;
import cn.edu.zju.dao.AnnovarDao;
import cn.edu.zju.dao.DrugLabelDao;
import cn.edu.zju.dao.SampleDao;
import cn.edu.zju.servlet.DispatchServlet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.IOException;
import java.io.InputStream;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.regex.Pattern;

public class MatchingController {

    private static final Logger log = LoggerFactory.getLogger(MatchingController.class);

    private final SampleDao sampleDao = new SampleDao();
    private final AnnovarDao annovarDao = new AnnovarDao();
    private final DrugLabelDao drugLabelDao = new DrugLabelDao();

    public void register(DispatchServlet.Dispatcher dispatcher) {
        dispatcher.registerPostMapping("/upload", this::uploadMutationFile);
        dispatcher.registerGetMapping("/matchingIndex", this::matchingIndex);
        dispatcher.registerGetMapping("/matching", this::matching);
        dispatcher.registerGetMapping("/samples", this::samples);
    }

    public void matchingIndex(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        request.getRequestDispatcher("/views/matching_index.jsp").forward(request, response);
    }

    public void samples(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        List<Sample> samples = sampleDao.findAll();
        request.setAttribute("samples", samples);
        request.getRequestDispatcher("/views/samples.jsp").forward(request, response);
    }

    public void matching(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String sampleIdParameter = request.getParameter("sampleId");

        if (sampleIdParameter == null || sampleIdParameter.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/samples");
            return;
        }

        Integer sampleId;
        try {
            sampleId = Integer.valueOf(sampleIdParameter.trim());
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/samples");
            return;
        }

        List<String> refGenes = annovarDao.getRefGenes(sampleId);
        log.info("refGenes = {}", refGenes);

        if (refGenes.isEmpty()) {
            log.info("No refGenes found for sampleId={}", sampleId);
            response.sendRedirect(request.getContextPath() + "/samples");
            return;
        }

        List<DrugLabel> drugLabels = drugLabelDao.findAll();
        log.info("drugLabels size = {}", drugLabels.size());

        List<DrugLabel> matched = doMatch(refGenes, drugLabels);
        log.info("matched size = {}", matched.size());

        request.setAttribute("matched", matched);
        request.setAttribute("refGenes", refGenes);
        request.setAttribute("sample", sampleDao.findById(sampleId));
        request.getRequestDispatcher("/views/matching_index_search.jsp").forward(request, response);
    }

    private List<DrugLabel> doMatch(List<String> refGenes, List<DrugLabel> drugLabels) {
        List<DrugLabel> matchedLabels = new ArrayList<>();

        for (DrugLabel drugLabel : drugLabels) {
            String summary = drugLabel.getSummaryMarkdown();
            if (summary == null || summary.isBlank()) {
                continue;
            }

            String summaryUpper = summary.toUpperCase(Locale.ROOT);
            boolean matched = false;

            for (String gene : refGenes) {
                if (gene == null || gene.isBlank()) {
                    continue;
                }

                String normalizedGene = gene.trim().toUpperCase(Locale.ROOT);

                if (containsGeneToken(summaryUpper, normalizedGene)) {
                    matched = true;
                    break;
                }
            }

            if (matched) {
                matchedLabels.add(drugLabel);
            }
        }

        return matchedLabels;
    }

    private boolean containsGeneToken(String textUpper, String geneUpper) {
        if (textUpper == null || textUpper.isBlank() || geneUpper == null || geneUpper.isBlank()) {
            return false;
        }

        String regex = "(^|[^A-Z0-9])" + Pattern.quote(geneUpper) + "([^A-Z0-9]|$)";
        return Pattern.compile(regex).matcher(textUpper).find();
    }

    public void uploadMutationFile(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {

        String uploadedBy = request.getParameter("uploaded_by");
        if (uploadedBy == null || uploadedBy.isBlank()) {
            forwardError(request, response, "Uploaded by cannot be blank.");
            return;
        }

        Part filePart = request.getPart("annovar");
        if (filePart == null || filePart.getSize() == 0) {
            forwardError(request, response, "Mutation file cannot be blank.");
            return;
        }

        String fileName = extractFileName(filePart);
        String extension = getExtension(fileName);

        if (!isSupportedExtension(extension)) {
            forwardError(request, response,
                    "Unsupported file type. Please upload a CSV, TSV, TXT, or VCF file.");
            return;
        }

        String content;
        try (InputStream inputStream = filePart.getInputStream()) {
            content = new String(inputStream.readAllBytes(), StandardCharsets.UTF_8);
        }

        if (content == null || content.isBlank()) {
            forwardError(request, response, "Uploaded file is empty.");
            return;
        }

        String normalizedContent;
        try {
            if ("vcf".equals(extension)) {
                normalizedContent = convertVcfToStandardTsv(content);
            } else {
                normalizedContent = validateAndNormalizeTableFile(content);
            }
        } catch (IllegalArgumentException e) {
            log.warn("Validation failed for uploaded file: {}", e.getMessage());
            forwardError(request, response, e.getMessage());
            return;
        } catch (Exception e) {
            log.error("Failed to normalize uploaded file.", e);
            forwardError(request, response,
                    "The uploaded file could not be parsed. Please check whether the format is correct.");
            return;
        }

        int sampleId = sampleDao.save(uploadedBy);

        try {
            annovarDao.save(sampleId, normalizedContent);
        } catch (Exception e) {
            log.error("Failed to parse or save mutation file.", e);

            try {
                sampleDao.deleteById(sampleId);
            } catch (Exception deleteException) {
                log.error("Failed to clean up sample after annovar save failure. sampleId={}", sampleId, deleteException);
            }

            forwardError(request, response,
                    "The uploaded file passed validation but could not be saved by the current backend. " +
                            "Please check whether AnnovarDao expects these standard columns: " +
                            "Chr, Start, End, Ref, Alt, Gene.refGene, Func.refGene, ExonicFunc.refGene.");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/matching?sampleId=" + sampleId);
    }

    private boolean isSupportedExtension(String extension) {
        return "csv".equals(extension)
                || "tsv".equals(extension)
                || "txt".equals(extension)
                || "vcf".equals(extension);
    }

    private String extractFileName(Part filePart) {
        String submittedFileName = filePart.getSubmittedFileName();
        return submittedFileName == null ? "" : submittedFileName.trim();
    }

    private String getExtension(String fileName) {
        if (fileName == null || !fileName.contains(".")) {
            return "";
        }
        return fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase(Locale.ROOT);
    }

    private String validateAndNormalizeTableFile(String content) {
        String[] lines = content.split("\\r?\\n");
        if (lines.length < 2) {
            throw new IllegalArgumentException("Uploaded table file must contain a header and at least one data row.");
        }

        String headerLine = lines[0].trim();
        String delimiterRegex = detectDelimiter(headerLine);

        if (delimiterRegex == null) {
            throw new IllegalArgumentException(
                    "Unable to detect file delimiter. Please upload a valid CSV, TSV, or TXT file with a clear header row.");
        }

        String[] headers = headerLine.split(delimiterRegex, -1);
        Set<String> headerSet = toTrimmedHeaderSet(headers);

        if (!isSupportedHeader(headerSet)) {
            throw new IllegalArgumentException(
                    "Unsupported table format. Required core fields: Chr, Start, End, Ref, Alt. " +
                            "Required annotation fields: Gene / Gene.refGene / Gene.refGeneWithVer and " +
                            "ExonicFunc.refGene / ExonicFunc.refGeneWithVer.");
        }

        StringBuilder sb = new StringBuilder();
        for (String line : lines) {
            if (line == null || line.isBlank()) {
                continue;
            }
            String[] cols = line.split(delimiterRegex, -1);
            for (int i = 0; i < cols.length; i++) {
                cols[i] = safeField(cols[i]);
            }
            sb.append(String.join("\t", cols)).append("\n");
        }

        return sb.toString();
    }

    private String detectDelimiter(String headerLine) {
        if (headerLine.contains("\t")) {
            return "\\t";
        }
        if (headerLine.contains(",")) {
            return ",";
        }
        return null;
    }

    private Set<String> toTrimmedHeaderSet(String[] headers) {
        Set<String> headerSet = new HashSet<>();
        for (String header : headers) {
            if (header != null) {
                headerSet.add(header.trim());
            }
        }
        return headerSet;
    }

    private boolean isSupportedHeader(Set<String> headerSet) {
        boolean hasCoreFields = headerSet.contains("Chr")
                && headerSet.contains("Start")
                && headerSet.contains("End")
                && headerSet.contains("Ref")
                && headerSet.contains("Alt");

        boolean hasGeneField = headerSet.contains("Gene.refGeneWithVer")
                || headerSet.contains("Gene.refGene")
                || headerSet.contains("Gene");

        boolean hasExonicFuncField = headerSet.contains("ExonicFunc.refGeneWithVer")
                || headerSet.contains("ExonicFunc.refGene");

        return hasCoreFields && hasGeneField && hasExonicFuncField;
    }

    private String convertVcfToStandardTsv(String vcfContent) {
        String[] lines = vcfContent.split("\\r?\\n");

        List<String> variantLines = new ArrayList<>();
        String vcfHeader = null;

        for (String line : lines) {
            if (line == null || line.isBlank()) {
                continue;
            }
            if (line.startsWith("##")) {
                continue;
            }
            if (line.startsWith("#CHROM")) {
                vcfHeader = line;
                continue;
            }
            if (!line.startsWith("#")) {
                variantLines.add(line);
            }
        }

        if (vcfHeader == null) {
            throw new IllegalArgumentException("Invalid VCF: missing #CHROM header line.");
        }

        if (variantLines.isEmpty()) {
            throw new IllegalArgumentException("The uploaded VCF does not contain any variant rows.");
        }

        StringBuilder sb = new StringBuilder();
        sb.append("Chr\tStart\tEnd\tRef\tAlt\tGene.refGene\tFunc.refGene\tExonicFunc.refGene\n");

        int convertedCount = 0;

        for (String line : variantLines) {
            String[] cols = line.split("\t", -1);
            if (cols.length < 8) {
                continue;
            }

            String chr = cols[0].trim();
            String posStr = cols[1].trim();
            String ref = cols[3].trim();
            String altField = cols[4].trim();
            String info = cols[7].trim();

            if (chr.isBlank() || posStr.isBlank() || ref.isBlank() || altField.isBlank()) {
                continue;
            }

            int start;
            try {
                start = Integer.parseInt(posStr);
            } catch (NumberFormatException e) {
                continue;
            }

            int end = start + Math.max(ref.length() - 1, 0);

            Map<String, String> infoMap = parseInfoField(info);

            String gene = extractGeneFromInfo(infoMap);
            String exonicFunc = extractExonicFuncFromInfo(infoMap);
            String func = extractFuncFromInfo(infoMap, exonicFunc);

            if (gene == null || gene.isBlank()) {
                continue;
            }

            String[] alts = altField.split(",");
            for (String alt : alts) {
                String cleanAlt = alt == null ? "" : alt.trim();
                if (cleanAlt.isBlank()) {
                    continue;
                }

                sb.append(safeField(chr)).append('\t')
                        .append(start).append('\t')
                        .append(end).append('\t')
                        .append(safeField(ref)).append('\t')
                        .append(safeField(cleanAlt)).append('\t')
                        .append(safeField(gene)).append('\t')
                        .append(safeField(func)).append('\t')
                        .append(safeField(exonicFunc)).append('\n');

                convertedCount++;
            }
        }

        if (convertedCount == 0) {
            throw new IllegalArgumentException(
                    "The uploaded VCF could not be converted for matching. " +
                            "Please upload an annotated VCF containing gene annotation in INFO " +
                            "(for example ANN, CSQ, Gene.refGene, or Gene fields).");
        }

        return sb.toString();
    }

    private Map<String, String> parseInfoField(String info) {
        Map<String, String> map = new LinkedHashMap<>();
        if (info == null || info.isBlank()) {
            return map;
        }

        String[] items = info.split(";");
        for (String item : items) {
            if (item == null || item.isBlank()) {
                continue;
            }

            int idx = item.indexOf('=');
            if (idx > 0) {
                String key = item.substring(0, idx).trim();
                String value = item.substring(idx + 1).trim();
                map.put(key, value);
            } else {
                map.put(item.trim(), "");
            }
        }

        return map;
    }

    private String extractGeneFromInfo(Map<String, String> infoMap) {
        String gene = firstNonBlank(
                infoMap.get("Gene.refGene"),
                infoMap.get("Gene.refGeneWithVer"),
                infoMap.get("Gene"),
                infoMap.get("GENE"),
                infoMap.get("SYMBOL"),
                extractGeneFromAnn(infoMap.get("ANN")),
                extractGeneFromCsq(infoMap.get("CSQ"))
        );

        if (gene == null) {
            return null;
        }

        gene = gene.split("[,|&]")[0].trim();
        if (gene.isBlank() || ".".equals(gene)) {
            return null;
        }
        return gene;
    }

    private String extractExonicFuncFromInfo(Map<String, String> infoMap) {
        String exonicFunc = firstNonBlank(
                infoMap.get("ExonicFunc.refGene"),
                infoMap.get("ExonicFunc.refGeneWithVer"),
                infoMap.get("EXONICFUNC"),
                extractEffectFromAnn(infoMap.get("ANN")),
                extractEffectFromCsq(infoMap.get("CSQ"))
        );

        if (exonicFunc == null || exonicFunc.isBlank()) {
            return "unknown";
        }

        return normalizeExonicFunc(exonicFunc);
    }

    private String extractFuncFromInfo(Map<String, String> infoMap, String exonicFunc) {
        String func = firstNonBlank(
                infoMap.get("Func.refGene"),
                infoMap.get("Func.refGeneWithVer"),
                infoMap.get("FUNC")
        );

        if (func != null && !func.isBlank()) {
            return func;
        }

        return inferFuncFromExonicFunc(exonicFunc);
    }

    private String extractGeneFromAnn(String ann) {
        if (ann == null || ann.isBlank()) {
            return null;
        }

        String firstRecord = ann.split(",")[0];
        String[] parts = firstRecord.split("\\|", -1);

        if (parts.length > 3 && parts[3] != null && !parts[3].isBlank()) {
            return parts[3].trim();
        }
        return null;
    }

    private String extractEffectFromAnn(String ann) {
        if (ann == null || ann.isBlank()) {
            return null;
        }

        String firstRecord = ann.split(",")[0];
        String[] parts = firstRecord.split("\\|", -1);

        if (parts.length > 1 && parts[1] != null && !parts[1].isBlank()) {
            return parts[1].trim();
        }
        return null;
    }

    private String extractGeneFromCsq(String csq) {
        if (csq == null || csq.isBlank()) {
            return null;
        }

        String firstRecord = csq.split(",")[0];
        String[] parts = firstRecord.split("\\|", -1);

        if (parts.length > 3 && parts[3] != null && !parts[3].isBlank()) {
            return parts[3].trim();
        }

        return null;
    }

    private String extractEffectFromCsq(String csq) {
        if (csq == null || csq.isBlank()) {
            return null;
        }

        String firstRecord = csq.split(",")[0];
        String[] parts = firstRecord.split("\\|", -1);

        if (parts.length > 1 && parts[1] != null && !parts[1].isBlank()) {
            return parts[1].trim();
        }
        return null;
    }

    private String normalizeExonicFunc(String value) {
        String v = value.trim().toLowerCase(Locale.ROOT);

        if (v.contains("missense") || v.contains("nonsynonymous")) {
            return "nonsynonymous SNV";
        }
        if (v.contains("synonymous")) {
            return "synonymous SNV";
        }
        if (v.contains("stopgain") || v.contains("stop_gained") || v.contains("nonsense")) {
            return "stopgain";
        }
        if (v.contains("stoploss") || v.contains("stop_lost")) {
            return "stoploss";
        }
        if (v.contains("frameshift")) {
            return "frameshift deletion";
        }
        if (v.contains("splic")) {
            return "splicing";
        }
        if (v.contains("intron")) {
            return "unknown";
        }

        return value;
    }

    private String inferFuncFromExonicFunc(String exonicFunc) {
        if (exonicFunc == null || exonicFunc.isBlank()) {
            return "unknown";
        }

        String v = exonicFunc.toLowerCase(Locale.ROOT);

        if (v.contains("splic")) {
            return "splicing";
        }
        if ("unknown".equals(v)) {
            return "unknown";
        }
        return "exonic";
    }

    private String firstNonBlank(String... values) {
        if (values == null) {
            return null;
        }

        for (String value : values) {
            if (value != null && !value.trim().isBlank()) {
                return value.trim();
            }
        }
        return null;
    }

    private String safeField(String value) {
        if (value == null) {
            return "";
        }
        return value.replace("\t", " ")
                .replace("\r", " ")
                .replace("\n", " ")
                .trim();
    }

    private void forwardError(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        request.setAttribute("validateError", message);
        request.getRequestDispatcher("/views/matching_index_error.jsp").forward(request, response);
    }
}