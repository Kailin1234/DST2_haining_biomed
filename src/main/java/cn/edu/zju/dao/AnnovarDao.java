package cn.edu.zju.dao;

import cn.edu.zju.dbutils.DBUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.*;

public class AnnovarDao extends BaseDao {

    private static final Logger log = LoggerFactory.getLogger(AnnovarDao.class);

    public void save(int sampleId, String content) {
        String[] lines = content.split("\\r?\\n");
        if (lines.length < 2) {
            throw new IllegalArgumentException("Mutation file must contain a header row and at least one data row.");
        }

        String[] headers = splitTabLine(lines[0]);
        Map<String, Integer> headerIndex = buildHeaderIndex(headers);

        validateMinimumHeaders(headerIndex);

        DBUtils.execSQL(connection -> {
            String sql = "INSERT INTO annovar (" +
                    "sample_id, Chr, Start, End, Ref, Alt, " +
                    "`Func.refGene`, `Gene.refGene`, `GeneDetail.refGene`, `ExonicFunc.refGene`, `AAChange.refGene`, " +
                    "cytoBand, `1000g2015aug_all`, `1000g2015aug_afr`, `1000g2015aug_amr`, `1000g2015aug_eas`, `1000g2015aug_eur`, `1000g2015aug_sas`, " +
                    "ExAC_ALL, ExAC_AFR, ExAC_AMR, ExAC_EAS, ExAC_FIN, ExAC_NFE, ExAC_OTH, ExAC_SAS, " +
                    "avsnp150, esp6500siv2_all, esp6500siv2_ea, esp6500siv2_aa, " +
                    "gnomAD_exome_ALL, gnomAD_exome_AFR, gnomAD_exome_AMR, gnomAD_exome_ASJ, gnomAD_exome_EAS, gnomAD_exome_FIN, gnomAD_exome_NFE, gnomAD_exome_OTH, gnomAD_exome_SAS, " +
                    "SIFT_score, SIFT_converted_rankscore, SIFT_pred, " +
                    "Polyphen2_HDIV_score, Polyphen2_HDIV_rankscore, Polyphen2_HDIV_pred, " +
                    "Polyphen2_HVAR_score, Polyphen2_HVAR_rankscore, Polyphen2_HVAR_pred, " +
                    "LRT_score, LRT_converted_rankscore, LRT_pred, " +
                    "MutationTaster_score, MutationTaster_converted_rankscore, MutationTaster_pred, " +
                    "MutationAssessor_score, MutationAssessor_score_rankscore, MutationAssessor_pred, " +
                    "FATHMM_score, FATHMM_converted_rankscore, FATHMM_pred, " +
                    "PROVEAN_score, PROVEAN_converted_rankscore, PROVEAN_pred, " +
                    "VEST3_score, VEST3_rankscore, " +
                    "MetaSVM_score, MetaSVM_rankscore, MetaSVM_pred, " +
                    "MetaLR_score, MetaLR_rankscore, MetaLR_pred, " +
                    "`M-CAP_score`, `M-CAP_rankscore`, `M-CAP_pred`, " +
                    "REVEL_score, REVEL_rankscore, MutPred_score, MutPred_rankscore, " +
                    "CADD_raw, CADD_raw_rankscore, CADD_phred, " +
                    "DANN_score, DANN_rankscore, " +
                    "`fathmm-MKL_coding_score`, `fathmm-MKL_coding_rankscore`, `fathmm-MKL_coding_pred`, " +
                    "Eigen_coding_or_noncoding, `Eigen-raw`, `Eigen-PC-raw`, " +
                    "GenoCanyon_score, GenoCanyon_score_rankscore, " +
                    "integrated_fitCons_score, integrated_fitCons_score_rankscore, integrated_confidence_value, " +
                    "`GERP++_RS`, `GERP++_RS_rankscore`, " +
                    "phyloP100way_vertebrate, phyloP100way_vertebrate_rankscore, " +
                    "phyloP20way_mammalian, phyloP20way_mammalian_rankscore, " +
                    "phastCons100way_vertebrate, phastCons100way_vertebrate_rankscore, " +
                    "phastCons20way_mammalian, phastCons20way_mammalian_rankscore, " +
                    "SiPhy_29way_logOdds, SiPhy_29way_logOdds_rankscore, " +
                    "Interpro_domain, GTEx_V6p_gene, GTEx_V6p_tissue, " +
                    "gnomAD_genome_ALL, gnomAD_genome_AFR, gnomAD_genome_AMR, gnomAD_genome_ASJ, gnomAD_genome_EAS, gnomAD_genome_FIN, gnomAD_genome_NFE, gnomAD_genome_OTH, " +
                    "CLNALLELEID, CLNDN, CLNDISDB, CLNREVSTAT, CLNSIG, cosmic70, ICGC_Id, ICGC_Occurrence, " +
                    "InterVar_automated, PVS1, PS1, PS2, PS3, PS4, PM1, PM2, PM3, PM4, PM5, PM6, PP1, PP2, PP3, PP4, PP5, BA1, BS1, BS2, BS3, BS4, BP1, BP2, BP3, BP4, BP5, BP6, BP7, " +
                    "Otherinfo" +
                    ") VALUES (" +
                    repeatPlaceholders(155) +
                    ")";

            boolean previousAutoCommit;
            try {
                previousAutoCommit = connection.getAutoCommit();
                connection.setAutoCommit(false);

                try (PreparedStatement ps = connection.prepareStatement(sql)) {
                    int batchCount = 0;
                    int insertedCount = 0;

                    for (int i = 1; i < lines.length; i++) {
                        String rawLine = lines[i];
                        if (rawLine == null || rawLine.trim().isEmpty()) {
                            continue;
                        }

                        String[] split = splitTabLine(rawLine);

                        String chr = getValue(split, headerIndex, "Chr", "CHROM", "#CHROM");
                        String start = getValue(split, headerIndex, "Start", "POS");
                        String end = getValue(split, headerIndex, "End");
                        String ref = getValue(split, headerIndex, "Ref", "REF");
                        String alt = getValue(split, headerIndex, "Alt", "ALT");

                        String gene = normalizeGene(getValue(split, headerIndex,
                                "Gene.refGene", "Gene.refGeneWithVer", "Gene", "GENE", "SYMBOL"));

                        String exonicFunc = getValue(split, headerIndex,
                                "ExonicFunc.refGene", "ExonicFunc.refGeneWithVer", "EXONICFUNC");

                        if (isBlank(chr) || isBlank(start) || isBlank(ref) || isBlank(alt) || isBlank(gene)) {
                            log.debug("Skipping row {} because required values are missing. chr={}, start={}, ref={}, alt={}, gene={}",
                                    i, chr, start, ref, alt, gene);
                            continue;
                        }

                        if (isBlank(end)) {
                            end = start;
                        }

                        ps.setInt(1, sampleId);

                        ps.setString(2, chr);
                        ps.setString(3, start);
                        ps.setString(4, end);
                        ps.setString(5, ref);
                        ps.setString(6, alt);
                        ps.setString(7, getValue(split, headerIndex, "Func.refGene", "Func.refGeneWithVer", "FUNC"));
                        ps.setString(8, gene);
                        ps.setString(9, getValue(split, headerIndex, "GeneDetail.refGene", "GeneDetail.refGeneWithVer"));
                        ps.setString(10, exonicFunc);
                        ps.setString(11, getValue(split, headerIndex, "AAChange.refGene", "AAChange.refGeneWithVer"));
                        ps.setString(12, getValue(split, headerIndex, "cytoBand"));

                        ps.setString(13, getValue(split, headerIndex, "1000g2015aug_all", "AF"));
                        ps.setString(14, getValue(split, headerIndex, "1000g2015aug_afr", "AF_afr"));
                        ps.setString(15, getValue(split, headerIndex, "1000g2015aug_amr", "AF_amr"));
                        ps.setString(16, getValue(split, headerIndex, "1000g2015aug_eas", "AF_eas"));
                        ps.setString(17, getValue(split, headerIndex, "1000g2015aug_eur", "AF_eur", "AF_nfe"));
                        ps.setString(18, getValue(split, headerIndex, "1000g2015aug_sas", "AF_sas"));

                        ps.setString(19, getValue(split, headerIndex, "ExAC_ALL"));
                        ps.setString(20, getValue(split, headerIndex, "ExAC_AFR"));
                        ps.setString(21, getValue(split, headerIndex, "ExAC_AMR"));
                        ps.setString(22, getValue(split, headerIndex, "ExAC_EAS"));
                        ps.setString(23, getValue(split, headerIndex, "ExAC_FIN"));
                        ps.setString(24, getValue(split, headerIndex, "ExAC_NFE"));
                        ps.setString(25, getValue(split, headerIndex, "ExAC_OTH"));
                        ps.setString(26, getValue(split, headerIndex, "ExAC_SAS"));

                        ps.setString(27, getValue(split, headerIndex, "avsnp150", "avsnp151"));
                        ps.setString(28, getValue(split, headerIndex, "esp6500siv2_all"));
                        ps.setString(29, getValue(split, headerIndex, "esp6500siv2_ea"));
                        ps.setString(30, getValue(split, headerIndex, "esp6500siv2_aa"));

                        ps.setString(31, getValue(split, headerIndex, "gnomAD_exome_ALL"));
                        ps.setString(32, getValue(split, headerIndex, "gnomAD_exome_AFR"));
                        ps.setString(33, getValue(split, headerIndex, "gnomAD_exome_AMR"));
                        ps.setString(34, getValue(split, headerIndex, "gnomAD_exome_ASJ"));
                        ps.setString(35, getValue(split, headerIndex, "gnomAD_exome_EAS"));
                        ps.setString(36, getValue(split, headerIndex, "gnomAD_exome_FIN"));
                        ps.setString(37, getValue(split, headerIndex, "gnomAD_exome_NFE"));
                        ps.setString(38, getValue(split, headerIndex, "gnomAD_exome_OTH"));
                        ps.setString(39, getValue(split, headerIndex, "gnomAD_exome_SAS"));

                        ps.setString(40, getValue(split, headerIndex, "SIFT_score"));
                        ps.setString(41, getValue(split, headerIndex, "SIFT_converted_rankscore"));
                        ps.setString(42, getValue(split, headerIndex, "SIFT_pred"));

                        ps.setString(43, getValue(split, headerIndex, "Polyphen2_HDIV_score"));
                        ps.setString(44, getValue(split, headerIndex, "Polyphen2_HDIV_rankscore"));
                        ps.setString(45, getValue(split, headerIndex, "Polyphen2_HDIV_pred"));

                        ps.setString(46, getValue(split, headerIndex, "Polyphen2_HVAR_score"));
                        ps.setString(47, getValue(split, headerIndex, "Polyphen2_HVAR_rankscore"));
                        ps.setString(48, getValue(split, headerIndex, "Polyphen2_HVAR_pred"));

                        ps.setString(49, getValue(split, headerIndex, "LRT_score"));
                        ps.setString(50, getValue(split, headerIndex, "LRT_converted_rankscore"));
                        ps.setString(51, getValue(split, headerIndex, "LRT_pred"));

                        ps.setString(52, getValue(split, headerIndex, "MutationTaster_score"));
                        ps.setString(53, getValue(split, headerIndex, "MutationTaster_converted_rankscore"));
                        ps.setString(54, getValue(split, headerIndex, "MutationTaster_pred"));

                        ps.setString(55, getValue(split, headerIndex, "MutationAssessor_score"));
                        ps.setString(56, getValue(split, headerIndex, "MutationAssessor_score_rankscore", "MutationAssessor_rankscore"));
                        ps.setString(57, getValue(split, headerIndex, "MutationAssessor_pred"));

                        ps.setString(58, getValue(split, headerIndex, "FATHMM_score"));
                        ps.setString(59, getValue(split, headerIndex, "FATHMM_converted_rankscore"));
                        ps.setString(60, getValue(split, headerIndex, "FATHMM_pred"));

                        ps.setString(61, getValue(split, headerIndex, "PROVEAN_score"));
                        ps.setString(62, getValue(split, headerIndex, "PROVEAN_converted_rankscore"));
                        ps.setString(63, getValue(split, headerIndex, "PROVEAN_pred"));

                        ps.setString(64, getValue(split, headerIndex, "VEST3_score", "VEST4_score"));
                        ps.setString(65, getValue(split, headerIndex, "VEST3_rankscore", "VEST4_rankscore"));

                        ps.setString(66, getValue(split, headerIndex, "MetaSVM_score"));
                        ps.setString(67, getValue(split, headerIndex, "MetaSVM_rankscore"));
                        ps.setString(68, getValue(split, headerIndex, "MetaSVM_pred"));

                        ps.setString(69, getValue(split, headerIndex, "MetaLR_score"));
                        ps.setString(70, getValue(split, headerIndex, "MetaLR_rankscore"));
                        ps.setString(71, getValue(split, headerIndex, "MetaLR_pred"));

                        ps.setString(72, getValue(split, headerIndex, "M-CAP_score"));
                        ps.setString(73, getValue(split, headerIndex, "M-CAP_rankscore"));
                        ps.setString(74, getValue(split, headerIndex, "M-CAP_pred"));

                        ps.setString(75, getValue(split, headerIndex, "REVEL_score"));
                        ps.setString(76, getValue(split, headerIndex, "REVEL_rankscore"));
                        ps.setString(77, getValue(split, headerIndex, "MutPred_score"));
                        ps.setString(78, getValue(split, headerIndex, "MutPred_rankscore"));

                        ps.setString(79, getValue(split, headerIndex, "CADD_raw"));
                        ps.setString(80, getValue(split, headerIndex, "CADD_raw_rankscore"));
                        ps.setString(81, getValue(split, headerIndex, "CADD_phred"));

                        ps.setString(82, getValue(split, headerIndex, "DANN_score"));
                        ps.setString(83, getValue(split, headerIndex, "DANN_rankscore"));

                        ps.setString(84, getValue(split, headerIndex, "fathmm-MKL_coding_score"));
                        ps.setString(85, getValue(split, headerIndex, "fathmm-MKL_coding_rankscore"));
                        ps.setString(86, getValue(split, headerIndex, "fathmm-MKL_coding_pred"));

                        ps.setString(87, getValue(split, headerIndex, "Eigen_coding_or_noncoding", "Eigen-raw_coding"));
                        ps.setString(88, getValue(split, headerIndex, "Eigen-raw", "Eigen-raw_coding"));
                        ps.setString(89, getValue(split, headerIndex, "Eigen-PC-raw", "Eigen-PC-raw_coding"));

                        ps.setString(90, getValue(split, headerIndex, "GenoCanyon_score"));
                        ps.setString(91, getValue(split, headerIndex, "GenoCanyon_score_rankscore", "GenoCanyon_rankscore"));

                        ps.setString(92, getValue(split, headerIndex, "integrated_fitCons_score"));
                        ps.setString(93, getValue(split, headerIndex, "integrated_fitCons_score_rankscore", "integrated_fitCons_rankscore"));
                        ps.setString(94, getValue(split, headerIndex, "integrated_confidence_value"));

                        ps.setString(95, getValue(split, headerIndex, "GERP++_RS"));
                        ps.setString(96, getValue(split, headerIndex, "GERP++_RS_rankscore"));

                        ps.setString(97, getValue(split, headerIndex, "phyloP100way_vertebrate"));
                        ps.setString(98, getValue(split, headerIndex, "phyloP100way_vertebrate_rankscore"));

                        ps.setString(99, getValue(split, headerIndex, "phyloP20way_mammalian", "phyloP470way_mammalian"));
                        ps.setString(100, getValue(split, headerIndex, "phyloP20way_mammalian_rankscore", "phyloP470way_mammalian_rankscore"));

                        ps.setString(101, getValue(split, headerIndex, "phastCons100way_vertebrate"));
                        ps.setString(102, getValue(split, headerIndex, "phastCons100way_vertebrate_rankscore"));

                        ps.setString(103, getValue(split, headerIndex, "phastCons20way_mammalian", "phastCons470way_mammalian"));
                        ps.setString(104, getValue(split, headerIndex, "phastCons20way_mammalian_rankscore", "phastCons470way_mammalian_rankscore"));

                        ps.setString(105, getValue(split, headerIndex, "SiPhy_29way_logOdds"));
                        ps.setString(106, getValue(split, headerIndex, "SiPhy_29way_logOdds_rankscore"));

                        ps.setString(107, getValue(split, headerIndex, "Interpro_domain"));
                        ps.setString(108, getValue(split, headerIndex, "GTEx_V6p_gene", "GTEx_V8_eQTL_gene"));
                        ps.setString(109, getValue(split, headerIndex, "GTEx_V6p_tissue", "GTEx_V8_eQTL_tissue"));

                        ps.setString(110, getValue(split, headerIndex, "gnomAD_genome_ALL"));
                        ps.setString(111, getValue(split, headerIndex, "gnomAD_genome_AFR"));
                        ps.setString(112, getValue(split, headerIndex, "gnomAD_genome_AMR"));
                        ps.setString(113, getValue(split, headerIndex, "gnomAD_genome_ASJ"));
                        ps.setString(114, getValue(split, headerIndex, "gnomAD_genome_EAS"));
                        ps.setString(115, getValue(split, headerIndex, "gnomAD_genome_FIN"));
                        ps.setString(116, getValue(split, headerIndex, "gnomAD_genome_NFE"));
                        ps.setString(117, getValue(split, headerIndex, "gnomAD_genome_OTH"));

                        ps.setString(118, getValue(split, headerIndex, "CLNALLELEID"));
                        ps.setString(119, getValue(split, headerIndex, "CLNDN"));
                        ps.setString(120, getValue(split, headerIndex, "CLNDISDB"));
                        ps.setString(121, getValue(split, headerIndex, "CLNREVSTAT"));
                        ps.setString(122, getValue(split, headerIndex, "CLNSIG"));
                        ps.setString(123, getValue(split, headerIndex, "cosmic70"));
                        ps.setString(124, getValue(split, headerIndex, "ICGC_Id"));
                        ps.setString(125, getValue(split, headerIndex, "ICGC_Occurrence"));

                        ps.setString(126, getValue(split, headerIndex, "InterVar_automated"));
                        ps.setString(127, getValue(split, headerIndex, "PVS1"));
                        ps.setString(128, getValue(split, headerIndex, "PS1"));
                        ps.setString(129, getValue(split, headerIndex, "PS2"));
                        ps.setString(130, getValue(split, headerIndex, "PS3"));
                        ps.setString(131, getValue(split, headerIndex, "PS4"));
                        ps.setString(132, getValue(split, headerIndex, "PM1"));
                        ps.setString(133, getValue(split, headerIndex, "PM2"));
                        ps.setString(134, getValue(split, headerIndex, "PM3"));
                        ps.setString(135, getValue(split, headerIndex, "PM4"));
                        ps.setString(136, getValue(split, headerIndex, "PM5"));
                        ps.setString(137, getValue(split, headerIndex, "PM6"));
                        ps.setString(138, getValue(split, headerIndex, "PP1"));
                        ps.setString(139, getValue(split, headerIndex, "PP2"));
                        ps.setString(140, getValue(split, headerIndex, "PP3"));
                        ps.setString(141, getValue(split, headerIndex, "PP4"));
                        ps.setString(142, getValue(split, headerIndex, "PP5"));
                        ps.setString(143, getValue(split, headerIndex, "BA1"));
                        ps.setString(144, getValue(split, headerIndex, "BS1"));
                        ps.setString(145, getValue(split, headerIndex, "BS2"));
                        ps.setString(146, getValue(split, headerIndex, "BS3"));
                        ps.setString(147, getValue(split, headerIndex, "BS4"));
                        ps.setString(148, getValue(split, headerIndex, "BP1"));
                        ps.setString(149, getValue(split, headerIndex, "BP2"));
                        ps.setString(150, getValue(split, headerIndex, "BP3"));
                        ps.setString(151, getValue(split, headerIndex, "BP4"));
                        ps.setString(152, getValue(split, headerIndex, "BP5"));
                        ps.setString(153, getValue(split, headerIndex, "BP6"));
                        ps.setString(154, getValue(split, headerIndex, "BP7"));

                        ps.setString(155, buildOtherInfo(headers, split));

                        ps.addBatch();
                        batchCount++;
                        insertedCount++;

                        if (batchCount % 1000 == 0) {
                            ps.executeBatch();
                            connection.commit();
                        }
                    }

                    ps.executeBatch();
                    connection.commit();

                    if (insertedCount == 0) {
                        throw new IllegalArgumentException("No valid variant rows could be saved from the uploaded file.");
                    }

                    log.info("Saved {} annovar rows for sampleId={}", insertedCount, sampleId);
                } catch (Exception e) {
                    connection.rollback();
                    throw e;
                } finally {
                    connection.setAutoCommit(previousAutoCommit);
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to save mutation file.", e);
            }
        });
    }

    public List<String> getRefGenes(int sampleId) {
        String sql = "SELECT DISTINCT `Gene.refGene` " +
                "FROM annovar " +
                "WHERE sample_id = ? " +
                "AND `Gene.refGene` IS NOT NULL " +
                "AND `Gene.refGene` != '' " +
                "AND (`ExonicFunc.refGene` IS NULL OR `ExonicFunc.refGene` != 'synonymous SNV')";

        List<String> genes = new ArrayList<>();

        DBUtils.execSQL(connection -> {
            try (PreparedStatement ps = connection.prepareStatement(sql)) {
                ps.setInt(1, sampleId);

                try (ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String gene = rs.getString(1);
                        if (gene != null && !gene.isBlank() && !genes.contains(gene)) {
                            genes.add(gene);
                        }
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query reference genes.", e);
            }
        });

        return genes;
    }

    private void validateMinimumHeaders(Map<String, Integer> headerIndex) {
        boolean hasChr = hasAnyHeader(headerIndex, "Chr", "CHROM", "#CHROM");
        boolean hasStart = hasAnyHeader(headerIndex, "Start", "POS");
        boolean hasRef = hasAnyHeader(headerIndex, "Ref", "REF");
        boolean hasAlt = hasAnyHeader(headerIndex, "Alt", "ALT");
        boolean hasGene = hasAnyHeader(headerIndex, "Gene.refGene", "Gene.refGeneWithVer", "Gene", "GENE", "SYMBOL");

        if (!(hasChr && hasStart && hasRef && hasAlt && hasGene)) {
            throw new IllegalArgumentException(
                    "The normalized mutation file is missing required columns. " +
                            "Required columns include Chr, Start, Ref, Alt, and Gene/Gene.refGene.");
        }
    }

    private boolean hasAnyHeader(Map<String, Integer> headerIndex, String... candidates) {
        for (String candidate : candidates) {
            if (headerIndex.containsKey(candidate)) {
                return true;
            }
        }
        return false;
    }

    private Map<String, Integer> buildHeaderIndex(String[] headers) {
        Map<String, Integer> indexMap = new HashMap<>();
        for (int i = 0; i < headers.length; i++) {
            String header = headers[i] == null ? "" : headers[i].trim();
            if (!header.isEmpty()) {
                indexMap.put(header, i);
            }
        }
        return indexMap;
    }

    private String[] splitTabLine(String line) {
        return line.split("\\t", -1);
    }

    private String getValue(String[] split, Map<String, Integer> headerIndex, String... possibleHeaders) {
        for (String header : possibleHeaders) {
            Integer idx = headerIndex.get(header);
            if (idx != null && idx < split.length) {
                String value = split[idx];
                if (value != null) {
                    value = value.trim();
                }
                if (value == null || value.isEmpty() || ".".equals(value)) {
                    return null;
                }
                return value;
            }
        }
        return null;
    }

    private String normalizeGene(String rawGene) {
        if (rawGene == null || rawGene.isBlank()) {
            return null;
        }

        String normalized = rawGene.trim();

        String[] semicolonParts = normalized.split(";");
        for (String part : semicolonParts) {
            String gene = cleanGeneToken(part);
            if (gene != null) {
                return gene;
            }
        }

        String[] commaParts = normalized.split(",");
        for (String part : commaParts) {
            String gene = cleanGeneToken(part);
            if (gene != null) {
                return gene;
            }
        }

        return cleanGeneToken(normalized);
    }

    private String cleanGeneToken(String token) {
        if (token == null) {
            return null;
        }

        String gene = token.trim();
        if (gene.isEmpty()) {
            return null;
        }

        if ("NONE".equalsIgnoreCase(gene) || ".".equals(gene)) {
            return null;
        }

        if (gene.contains("|")) {
            gene = gene.split("\\|")[0].trim();
        }
        if (gene.contains("&")) {
            gene = gene.split("&")[0].trim();
        }

        if (gene.isEmpty() || "NONE".equalsIgnoreCase(gene) || ".".equals(gene)) {
            return null;
        }

        return gene;
    }

    private String buildOtherInfo(String[] headers, String[] split) {
        Set<String> usedHeaders = new HashSet<>(Arrays.asList(
                "Chr", "CHROM", "#CHROM",
                "Start", "POS",
                "End",
                "Ref", "REF",
                "Alt", "ALT",
                "Func.refGene", "Func.refGeneWithVer", "FUNC",
                "Gene.refGene", "Gene.refGeneWithVer", "Gene", "GENE", "SYMBOL",
                "GeneDetail.refGene", "GeneDetail.refGeneWithVer",
                "ExonicFunc.refGene", "ExonicFunc.refGeneWithVer", "EXONICFUNC",
                "AAChange.refGene", "AAChange.refGeneWithVer",
                "cytoBand",
                "1000g2015aug_all", "1000g2015aug_afr", "1000g2015aug_amr", "1000g2015aug_eas", "1000g2015aug_eur", "1000g2015aug_sas",
                "AF", "AF_afr", "AF_amr", "AF_eas", "AF_eur", "AF_nfe", "AF_sas",
                "ExAC_ALL", "ExAC_AFR", "ExAC_AMR", "ExAC_EAS", "ExAC_FIN", "ExAC_NFE", "ExAC_OTH", "ExAC_SAS",
                "avsnp150", "avsnp151",
                "esp6500siv2_all", "esp6500siv2_ea", "esp6500siv2_aa",
                "gnomAD_exome_ALL", "gnomAD_exome_AFR", "gnomAD_exome_AMR", "gnomAD_exome_ASJ", "gnomAD_exome_EAS", "gnomAD_exome_FIN", "gnomAD_exome_NFE", "gnomAD_exome_OTH", "gnomAD_exome_SAS",
                "SIFT_score", "SIFT_converted_rankscore", "SIFT_pred",
                "Polyphen2_HDIV_score", "Polyphen2_HDIV_rankscore", "Polyphen2_HDIV_pred",
                "Polyphen2_HVAR_score", "Polyphen2_HVAR_rankscore", "Polyphen2_HVAR_pred",
                "LRT_score", "LRT_converted_rankscore", "LRT_pred",
                "MutationTaster_score", "MutationTaster_converted_rankscore", "MutationTaster_pred",
                "MutationAssessor_score", "MutationAssessor_score_rankscore", "MutationAssessor_rankscore", "MutationAssessor_pred",
                "FATHMM_score", "FATHMM_converted_rankscore", "FATHMM_pred",
                "PROVEAN_score", "PROVEAN_converted_rankscore", "PROVEAN_pred",
                "VEST3_score", "VEST3_rankscore", "VEST4_score", "VEST4_rankscore",
                "MetaSVM_score", "MetaSVM_rankscore", "MetaSVM_pred",
                "MetaLR_score", "MetaLR_rankscore", "MetaLR_pred",
                "M-CAP_score", "M-CAP_rankscore", "M-CAP_pred",
                "REVEL_score", "REVEL_rankscore",
                "MutPred_score", "MutPred_rankscore",
                "CADD_raw", "CADD_raw_rankscore", "CADD_phred",
                "DANN_score", "DANN_rankscore",
                "fathmm-MKL_coding_score", "fathmm-MKL_coding_rankscore", "fathmm-MKL_coding_pred",
                "Eigen_coding_or_noncoding", "Eigen-raw", "Eigen-PC-raw", "Eigen-raw_coding", "Eigen-PC-raw_coding",
                "GenoCanyon_score", "GenoCanyon_score_rankscore", "GenoCanyon_rankscore",
                "integrated_fitCons_score", "integrated_fitCons_score_rankscore", "integrated_fitCons_rankscore", "integrated_confidence_value",
                "GERP++_RS", "GERP++_RS_rankscore",
                "phyloP100way_vertebrate", "phyloP100way_vertebrate_rankscore",
                "phyloP20way_mammalian", "phyloP20way_mammalian_rankscore", "phyloP470way_mammalian", "phyloP470way_mammalian_rankscore",
                "phastCons100way_vertebrate", "phastCons100way_vertebrate_rankscore",
                "phastCons20way_mammalian", "phastCons20way_mammalian_rankscore", "phastCons470way_mammalian", "phastCons470way_mammalian_rankscore",
                "SiPhy_29way_logOdds", "SiPhy_29way_logOdds_rankscore",
                "Interpro_domain",
                "GTEx_V6p_gene", "GTEx_V6p_tissue", "GTEx_V8_eQTL_gene", "GTEx_V8_eQTL_tissue",
                "gnomAD_genome_ALL", "gnomAD_genome_AFR", "gnomAD_genome_AMR", "gnomAD_genome_ASJ", "gnomAD_genome_EAS", "gnomAD_genome_FIN", "gnomAD_genome_NFE", "gnomAD_genome_OTH",
                "CLNALLELEID", "CLNDN", "CLNDISDB", "CLNREVSTAT", "CLNSIG", "cosmic70", "ICGC_Id", "ICGC_Occurrence",
                "InterVar_automated",
                "PVS1", "PS1", "PS2", "PS3", "PS4", "PM1", "PM2", "PM3", "PM4", "PM5", "PM6",
                "PP1", "PP2", "PP3", "PP4", "PP5",
                "BA1", "BS1", "BS2", "BS3", "BS4",
                "BP1", "BP2", "BP3", "BP4", "BP5", "BP6", "BP7"
        ));

        StringJoiner joiner = new StringJoiner("\t");
        int length = Math.min(headers.length, split.length);

        for (int i = 0; i < length; i++) {
            String header = headers[i] == null ? "" : headers[i].trim();
            if (header.isEmpty() || usedHeaders.contains(header)) {
                continue;
            }

            String value = split[i] == null ? "" : split[i].trim();
            if (!value.isEmpty()) {
                joiner.add(header + "=" + value);
            }
        }

        return joiner.toString();
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private String repeatPlaceholders(int count) {
        StringJoiner joiner = new StringJoiner(", ");
        for (int i = 0; i < count; i++) {
            joiner.add("?");
        }
        return joiner.toString();
    }
}