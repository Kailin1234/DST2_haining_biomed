package cn.edu.zju.crawler;

import cn.edu.zju.bean.DosingGuideline;
import cn.edu.zju.dao.DosingGuidelineDao;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.util.List;
import java.util.Map;

public class DosingGuidelineCrawler extends BaseCrawler {

    private static final Logger log = LoggerFactory.getLogger(DosingGuidelineCrawler.class);

    public static final String URL_BASE = "https://api.pharmgkb.org/v1/data%s";
    public static final String URL_GUIDELINES = "https://api.pharmgkb.org/v1/site/guidelinesByDrugs";

    private final DosingGuidelineDao dosingGuidelineDao = new DosingGuidelineDao();

    public void doCrawlerDosingGuidelineList() {
        String content = this.getURLContent(URL_GUIDELINES);
        Gson gson = new Gson();
        Map result = gson.fromJson(content, Map.class);

        if (result == null || !result.containsKey("data")) {
            log.warn("guidelinesByDrugs API returned empty or invalid result.");
            return;
        }

        List<Map> data = (List<Map>) result.get("data");
        if (data == null || data.isEmpty()) {
            log.warn("guidelinesByDrugs API returned no records.");
            return;
        }

        data.forEach(x -> {
            List.of("cpic", "cpnds", "dpwg", "fda", "pro").forEach(sourceKey -> {
                Object guidelineObj = x.get(sourceKey);
                if (!(guidelineObj instanceof List)) {
                    return;
                }

                List<Map> guidelineList = (List<Map>) guidelineObj;
                guidelineList.forEach(guideline -> {
                    String url = asString(guideline.get("url"));
                    if (url != null && !url.isBlank()) {
                        doCrawlerDosingGuideline(url);
                    }
                });
            });
        });
    }

    public void doCrawlerDosingGuideline(String url) {
        String content = this.getURLContent(String.format(URL_BASE, url));
        Gson gson = new Gson();
        Map result = gson.fromJson(content, Map.class);

        if (result == null || !result.containsKey("data")) {
            log.warn("No data returned for guideline url {}", url);
            return;
        }

        Map data = (Map) result.get("data");
        if (data == null) {
            log.warn("Guideline data is null for url {}", url);
            return;
        }

        String id = asString(data.get("id"));
        if (id == null || id.isBlank()) {
            return;
        }

        String objCls = asString(data.get("objCls"));

        String name = asString(data.get("name"));
        if (name == null || name.isBlank()) {
            String source = asString(data.get("source"));
            name = (source == null || source.isBlank()) ? "Dosing Guideline" : source + " Guideline";
        }

        boolean recommendation = asBoolean(data.get("recommendation"));
        String drugId = extractRelatedDrugId(data.get("relatedChemicals"));
        String source = asString(data.get("source"));
        String summaryMarkdown = extractHtmlField(data.get("summaryMarkdown"));
        String textMarkdown = extractHtmlField(data.get("textMarkdown"));
        String raw = gson.toJson(result);

        DosingGuideline dosingGuideline = new DosingGuideline(
                id, objCls, name, recommendation, drugId, source, summaryMarkdown, textMarkdown, raw
        );

        if (!dosingGuidelineDao.existsById(id)) {
            dosingGuidelineDao.saveDosingGuideline(dosingGuideline);
            log.info("Saving dosing guideline: {}", id);
        } else {
            log.info("Dosing guideline exists, skipping: {}", id);
        }
    }

    private String extractHtmlField(Object fieldObj) {
        if (!(fieldObj instanceof Map)) {
            return "";
        }
        Map map = (Map) fieldObj;
        String html = asString(map.get("html"));
        return html == null ? "" : html;
    }

    private String extractRelatedDrugId(Object relatedChemicalsObj) {
        if (relatedChemicalsObj instanceof List) {
            List<Map> relatedChemicals = (List<Map>) relatedChemicalsObj;
            if (!relatedChemicals.isEmpty()) {
                String id = asString(relatedChemicals.get(0).get("id"));
                if (id != null && !id.isBlank()) {
                    return id;
                }
            }
        }
        return null;
    }

    private String asString(Object value) {
        if (value == null) {
            return null;
        }
        return String.valueOf(value).trim();
    }

    private boolean asBoolean(Object value) {
        if (value == null) {
            return false;
        }
        if (value instanceof Boolean) {
            return (Boolean) value;
        }
        return Boolean.parseBoolean(String.valueOf(value));
    }
}