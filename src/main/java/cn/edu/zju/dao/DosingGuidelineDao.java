package cn.edu.zju.dao;

import cn.edu.zju.bean.DosingGuideline;
import cn.edu.zju.dbutils.DBUtils;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DosingGuidelineDao extends BaseDao {

    public boolean existsById(String id) {
        return super.existsById(id, "dosing_guideline");
    }

    public void saveDosingGuideline(DosingGuideline dosingGuideline) {
        DBUtils.execSQL(connection -> {
            String sql = "INSERT INTO dosing_guideline " +
                    "(id, obj_cls, name, recommendation, drug_id, source, summary_markdown, text_markdown, raw, " +
                    "condition_type, condition_value, evidence_level) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, dosingGuideline.getId());
                preparedStatement.setString(2, dosingGuideline.getObjCls());
                preparedStatement.setString(3, dosingGuideline.getName());
                preparedStatement.setBoolean(4, dosingGuideline.isRecommendation());
                preparedStatement.setString(5, dosingGuideline.getDrugId());
                preparedStatement.setString(6, dosingGuideline.getSource());
                preparedStatement.setString(7, dosingGuideline.getSummaryMarkdown());
                preparedStatement.setString(8, dosingGuideline.getTextMarkdown());
                preparedStatement.setString(9, dosingGuideline.getRaw());
                preparedStatement.setString(10, dosingGuideline.getConditionType());
                preparedStatement.setString(11, dosingGuideline.getConditionValue());
                preparedStatement.setString(12, dosingGuideline.getEvidenceLevel());

                preparedStatement.executeUpdate();
            } catch (SQLException e) {
                throw new RuntimeException("Failed to save dosing guideline.", e);
            }
        });
    }

    public List<DosingGuideline> findAll() {
        return search(null, null);
    }

    public List<DosingGuideline> search(String keyword, String sourceFilter) {
        List<DosingGuideline> dosingGuidelines = new ArrayList<>();

        DBUtils.execSQL(connection -> {
            StringBuilder sql = new StringBuilder(
                    "SELECT id, obj_cls, name, recommendation, drug_id, source, summary_markdown, text_markdown, raw, " +
                            "condition_type, condition_value, evidence_level " +
                            "FROM dosing_guideline WHERE 1=1 "
            );

            List<Object> params = new ArrayList<>();

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("AND (LOWER(id) LIKE ? OR LOWER(name) LIKE ? OR LOWER(summary_markdown) LIKE ?) ");
                String pattern = "%" + keyword.trim().toLowerCase() + "%";
                params.add(pattern);
                params.add(pattern);
                params.add(pattern);
            }

            if (sourceFilter != null && !sourceFilter.trim().isEmpty()) {
                sql.append("AND LOWER(source) = ? ");
                params.add(sourceFilter.trim().toLowerCase());
            }

            sql.append("ORDER BY source ASC, id ASC");

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    preparedStatement.setObject(i + 1, params.get(i));
                }

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    while (resultSet.next()) {
                        dosingGuidelines.add(mapDosingGuideline(resultSet));
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query dosing guidelines.", e);
            }
        });

        return dosingGuidelines;
    }

    public DosingGuideline findById(String id) {
        final DosingGuideline[] result = {null};

        DBUtils.execSQL(connection -> {
            String sql = "SELECT id, obj_cls, name, recommendation, drug_id, source, summary_markdown, text_markdown, raw, " +
                    "condition_type, condition_value, evidence_level " +
                    "FROM dosing_guideline WHERE id = ?";

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, id);

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        result[0] = mapDosingGuideline(resultSet);
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query dosing guideline by id: " + id, e);
            }
        });

        return result[0];
    }

    private DosingGuideline mapDosingGuideline(ResultSet resultSet) throws SQLException {
        String id = resultSet.getString("id");
        String objCls = resultSet.getString("obj_cls");
        String rawName = resultSet.getString("name");
        boolean recommendation = resultSet.getBoolean("recommendation");
        String drugId = resultSet.getString("drug_id");
        String source = resultSet.getString("source");

        String summaryMarkdown = shorten(stripHtml(resultSet.getString("summary_markdown")), 300);
        String textMarkdown = stripHtml(resultSet.getString("text_markdown"));
        String raw = resultSet.getString("raw");

        String conditionType = stripHtml(resultSet.getString("condition_type"));
        String conditionValue = stripHtml(resultSet.getString("condition_value"));
        String evidenceLevel = stripHtml(resultSet.getString("evidence_level"));

        String displayName = normalizeGuidelineName(rawName, id, source);

        return new DosingGuideline(
                id, objCls, displayName, recommendation, drugId, source,
                summaryMarkdown, textMarkdown, raw,
                conditionType, conditionValue, evidenceLevel
        );
    }

    private String normalizeGuidelineName(String rawName, String id, String source) {
        if (rawName == null || rawName.trim().isEmpty() || rawName.trim().equals(id)) {
            if (source != null && !source.trim().isEmpty()) {
                return source + " Guideline";
            }
            return "Dosing Guideline";
        }
        return rawName.trim();
    }

    private String stripHtml(String value) {
        if (value == null) {
            return null;
        }

        String cleaned = value
                .replaceAll("(?i)<br\\s*/?>", "\n")
                .replaceAll("(?i)</p>", "\n")
                .replaceAll("<[^>]*>", "")
                .replace("&nbsp;", " ")
                .replace("&amp;", "&")
                .replace("&lt;", "<")
                .replace("&gt;", ">")
                .replace("&quot;", "\"")
                .trim();

        return cleaned.replaceAll("\\n{3,}", "\n\n");
    }

    private String shorten(String value, int maxLength) {
        if (value == null || value.length() <= maxLength) {
            return value;
        }
        return value.substring(0, maxLength).trim() + "...";
    }
}