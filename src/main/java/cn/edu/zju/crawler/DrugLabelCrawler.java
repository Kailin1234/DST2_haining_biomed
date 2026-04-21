package cn.edu.zju.crawler;

import cn.edu.zju.bean.Drug;
import cn.edu.zju.bean.DrugLabel;
import cn.edu.zju.dao.DrugDao;
import cn.edu.zju.dao.DrugLabelDao;
import cn.edu.zju.dbutils.DBUtils;
import com.google.gson.Gson;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;
import java.util.Map;

public class DrugLabelCrawler extends BaseCrawler {

    private static final Logger log = LoggerFactory.getLogger(DrugLabelCrawler.class);

    public static final String URL_DRUG_LABEL = "https://api.pharmgkb.org/v1/site/labelsByDrug";
    public static final String URL_DRUG_LABEL_DETAIL = "https://api.pharmgkb.org/v1/site/page/drugLabels/%s?view=base";

    private final DrugDao drugDao = new DrugDao();
    private final DrugLabelDao drugLabelDao = new DrugLabelDao();

    public void doCrawlerDrug() {
        String content = this.getURLContent(URL_DRUG_LABEL);
        Gson gson = new Gson();
        Map result = gson.fromJson(content, Map.class);

        if (result == null || !result.containsKey("data")) {
            log.warn("labelsByDrug API returned empty or invalid result.");
            return;
        }

        List<Map> data = (List<Map>) result.get("data");
        if (data == null || data.isEmpty()) {
            log.warn("labelsByDrug API returned no drug records.");
            return;
        }

        data.forEach(x -> {
            try {
                Map drug = (Map) x.get("drug");
                if (drug == null) {
                    return;
                }

                String id = asString(drug.get("id"));
                String name = asString(drug.get("name"));
                String objCls = asString(drug.get("objCls"));
                String drugUrl = asString(x.get("drugUrl"));
                boolean biomarker = asBoolean(x.get("biomarker"));

                if (id == null || id.isBlank()) {
                    return;
                }

                Drug drugBean = new Drug(id, name, biomarker, drugUrl, objCls);

                if (!drugDao.existsById(id)) {
                    drugDao.saveDrug(drugBean);
                    log.info("Saved drug: {}", id);
                } else {
                    log.info("Drug {} already exists, skip", id);
                }
            } catch (Exception e) {
                log.error("Failed to parse/save drug record: {}", x, e);
            }
        });
    }

    public void doCrawlerDrugLabel() {
        DBUtils.execSQL(connection -> {
            String sql = "select * from drug";
            try (PreparedStatement preparedStatement = connection.prepareStatement(sql);
                 ResultSet resultSet = preparedStatement.executeQuery()) {

                while (resultSet.next()) {
                    String id = resultSet.getString("id");
                    if (id == null || id.isBlank()) {
                        continue;
                    }

                    String content = this.getURLContent(String.format(URL_DRUG_LABEL_DETAIL, id));
                    Gson gson = new Gson();
                    Map result = gson.fromJson(content, Map.class);

                    if (result == null || !result.containsKey("data")) {
                        log.warn("No data returned for drug label detail of drug {}", id);
                        continue;
                    }

                    Map data = (Map) result.get("data");
                    if (data == null || !data.containsKey("drugLabels")) {
                        log.warn("No drugLabels field returned for drug {}", id);
                        continue;
                    }

                    List<Map> drugLabels = (List<Map>) data.get("drugLabels");
                    if (drugLabels == null || drugLabels.isEmpty()) {
                        log.info("No labels found for drug {}", id);
                        continue;
                    }

                    log.info("Fetch label of drug {}", id);

                    drugLabels.forEach(x -> {
                        try {
                            String labelId = asString(x.get("id"));
                            if (labelId == null || labelId.isBlank()) {
                                return;
                            }

                            log.info("Going to save label: {}", labelId);

                            String source = asString(x.get("source"));
                            String objCls = asString(x.get("objCls"));

                            String name = asString(x.get("name"));
                            if (name == null || name.isBlank()) {
                                name = source;
                            }
                            if (name == null || name.isBlank()) {
                                name = "Drug Label";
                            }

                            boolean alternateDrugAvailable = asBoolean(x.get("alternateDrugAvailable"));
                            boolean dosingInformation = asBoolean(x.get("dosingInformation"));

                            String prescribingMarkdown = extractHtmlField(x.get("prescribingMarkdown"));
                            String textMarkdown = extractHtmlField(x.get("textMarkdown"));
                            String summaryMarkdown = extractHtmlField(x.get("summaryMarkdown"));

                            String raw = gson.toJson(x);
                            String drugId = extractRelatedDrugId(x.get("relatedChemicals"), id);

                            DrugLabel drugLabelBean = new DrugLabel(
                                    labelId,
                                    name,
                                    objCls,
                                    alternateDrugAvailable,
                                    dosingInformation,
                                    prescribingMarkdown,
                                    source,
                                    textMarkdown,
                                    summaryMarkdown,
                                    raw,
                                    drugId
                            );

                            if (!drugLabelDao.existsById(labelId)) {
                                drugLabelDao.saveDrugLabel(drugLabelBean);
                                log.info("Saved label: {}", labelId);
                            } else {
                                log.info("Label {} already exists, skip", labelId);
                            }
                        } catch (Exception e) {
                            log.error("Failed to parse/save label record: {}", x, e);
                        }
                    });
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to crawl drug labels.", e);
            }
        });
    }

    private String extractHtmlField(Object fieldObj) {
        if (!(fieldObj instanceof Map)) {
            return "";
        }
        Map map = (Map) fieldObj;
        String html = asString(map.get("html"));
        return html == null ? "" : html;
    }

    private String extractRelatedDrugId(Object relatedChemicalsObj, String fallbackDrugId) {
        if (relatedChemicalsObj instanceof List) {
            List<Map> relatedChemicals = (List<Map>) relatedChemicalsObj;
            if (!relatedChemicals.isEmpty()) {
                String relatedDrugId = asString(relatedChemicals.get(0).get("id"));
                if (relatedDrugId != null && !relatedDrugId.isBlank()) {
                    return relatedDrugId;
                }
            }
        }
        return fallbackDrugId;
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