package cn.edu.zju.dao;

import cn.edu.zju.bean.DrugLabel;
import cn.edu.zju.dbutils.DBUtils;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DrugLabelDao extends BaseDao {

    public boolean existsById(String id) {
        return super.existsById(id, "drug_label");
    }

    public void saveDrugLabel(DrugLabel drugLabel) {
        DBUtils.execSQL(connection -> {
            String sql = "INSERT INTO drug_label " +
                    "(id, name, obj_cls, alternate_drug_available, dosing_information, prescribing_markdown, " +
                    "source, text_markdown, summary_markdown, raw, drug_id, treatment_indication, " +
                    "target_population, adverse_reaction, contraindication, warning_precaution) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, drugLabel.getId());
                preparedStatement.setString(2, drugLabel.getName());
                preparedStatement.setString(3, drugLabel.getObjCls());
                preparedStatement.setBoolean(4, drugLabel.isAlternateDrugAvailable());
                preparedStatement.setBoolean(5, drugLabel.isDosingInformation());
                preparedStatement.setString(6, drugLabel.getPrescribingMarkdown());
                preparedStatement.setString(7, drugLabel.getSource());
                preparedStatement.setString(8, drugLabel.getTextMarkdown());
                preparedStatement.setString(9, drugLabel.getSummaryMarkdown());
                preparedStatement.setString(10, drugLabel.getRaw());
                preparedStatement.setString(11, drugLabel.getDrugId());
                preparedStatement.setString(12, drugLabel.getTreatmentIndication());
                preparedStatement.setString(13, drugLabel.getTargetPopulation());
                preparedStatement.setString(14, drugLabel.getAdverseReaction());
                preparedStatement.setString(15, drugLabel.getContraindication());
                preparedStatement.setString(16, drugLabel.getWarningPrecaution());

                preparedStatement.executeUpdate();
            } catch (SQLException e) {
                throw new RuntimeException("Failed to save drug label.", e);
            }
        });
    }

    public List<DrugLabel> findAll() {
        return search(null, null);
    }

    public List<DrugLabel> search(String keyword, String sourceFilter) {
        List<DrugLabel> drugLabels = new ArrayList<>();

        DBUtils.execSQL(connection -> {
            StringBuilder sql = new StringBuilder(
                    "SELECT id, name, obj_cls, alternate_drug_available, dosing_information, " +
                            "prescribing_markdown, source, text_markdown, summary_markdown, raw, drug_id, " +
                            "treatment_indication, target_population, adverse_reaction, contraindication, warning_precaution " +
                            "FROM drug_label WHERE 1=1 "
            );

            List<Object> params = new ArrayList<>();

            if (hasText(keyword)) {
                sql.append("AND (")
                        .append("LOWER(id) LIKE ? ")
                        .append("OR LOWER(name) LIKE ? ")
                        .append("OR LOWER(obj_cls) LIKE ? ")
                        .append("OR LOWER(source) LIKE ? ")
                        .append("OR LOWER(drug_id) LIKE ? ")
                        .append("OR LOWER(summary_markdown) LIKE ? ")
                        .append("OR LOWER(prescribing_markdown) LIKE ? ")
                        .append("OR LOWER(text_markdown) LIKE ? ")
                        .append("OR LOWER(treatment_indication) LIKE ? ")
                        .append("OR LOWER(target_population) LIKE ? ")
                        .append("OR LOWER(adverse_reaction) LIKE ? ")
                        .append("OR LOWER(contraindication) LIKE ? ")
                        .append("OR LOWER(warning_precaution) LIKE ? ")
                        .append(") ");

                String pattern = "%" + keyword.trim().toLowerCase() + "%";
                for (int i = 0; i < 13; i++) {
                    params.add(pattern);
                }
            }

            if (hasText(sourceFilter)) {
                sql.append("AND LOWER(TRIM(source)) = ? ");
                params.add(sourceFilter.trim().toLowerCase());
            }

            sql.append("ORDER BY source ASC, name ASC, id ASC");

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
                bindParams(preparedStatement, params);

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    while (resultSet.next()) {
                        drugLabels.add(mapDrugLabel(resultSet, true));
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query drug labels.", e);
            }
        });

        return drugLabels;
    }

    public DrugLabel findById(String id) {
        if (!hasText(id)) {
            return null;
        }

        final DrugLabel[] result = {null};

        DBUtils.execSQL(connection -> {
            String sql = "SELECT id, name, obj_cls, alternate_drug_available, dosing_information, " +
                    "prescribing_markdown, source, text_markdown, summary_markdown, raw, drug_id, " +
                    "treatment_indication, target_population, adverse_reaction, contraindication, warning_precaution " +
                    "FROM drug_label WHERE id = ?";

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, id.trim());

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        result[0] = mapDrugLabel(resultSet, false);
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query drug label by id: " + id, e);
            }
        });

        return result[0];
    }

    private DrugLabel mapDrugLabel(ResultSet resultSet, boolean shortenSummary) throws SQLException {
        String id = resultSet.getString("id");
        String rawName = resultSet.getString("name");
        String objCls = resultSet.getString("obj_cls");

        boolean alternateDrugAvailable = resultSet.getBoolean("alternate_drug_available");
        boolean dosingInformation = resultSet.getBoolean("dosing_information");

        String prescribingMarkdown = stripHtml(resultSet.getString("prescribing_markdown"));
        String source = resultSet.getString("source");
        String textMarkdown = stripHtml(resultSet.getString("text_markdown"));

        String summaryMarkdown = stripHtml(resultSet.getString("summary_markdown"));
        if (shortenSummary) {
            summaryMarkdown = shorten(summaryMarkdown, 280);
        }

        String raw = resultSet.getString("raw");
        String drugId = resultSet.getString("drug_id");

        String treatmentIndication = stripHtml(resultSet.getString("treatment_indication"));
        String targetPopulation = stripHtml(resultSet.getString("target_population"));
        String adverseReaction = stripHtml(resultSet.getString("adverse_reaction"));
        String contraindication = stripHtml(resultSet.getString("contraindication"));
        String warningPrecaution = stripHtml(resultSet.getString("warning_precaution"));

        String displayName = normalizeLabelName(rawName, id, source);

        return new DrugLabel(
                id,
                displayName,
                objCls,
                alternateDrugAvailable,
                dosingInformation,
                prescribingMarkdown,
                source,
                textMarkdown,
                summaryMarkdown,
                raw,
                drugId,
                treatmentIndication,
                targetPopulation,
                adverseReaction,
                contraindication,
                warningPrecaution
        );
    }

    private String normalizeLabelName(String rawName, String id, String source) {
        if (!hasText(rawName) || rawName.trim().equals(id)) {
            if (hasText(source)) {
                return source.trim() + " Label";
            }
            return "Drug Label";
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
                .replaceAll("(?i)<p[^>]*>", "")
                .replaceAll("<[^>]*>", "")
                .replace("&nbsp;", " ")
                .replace("&amp;", "&")
                .replace("&lt;", "<")
                .replace("&gt;", ">")
                .replace("&quot;", "\"")
                .replace("&#39;", "'")
                .replace("&apos;", "'")
                .trim();

        return cleaned.replaceAll("\\n{3,}", "\n\n");
    }

    private String shorten(String value, int maxLength) {
        if (value == null || value.length() <= maxLength) {
            return value;
        }
        return value.substring(0, maxLength).trim() + "...";
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private void bindParams(PreparedStatement preparedStatement, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            preparedStatement.setObject(i + 1, params.get(i));
        }
    }
}