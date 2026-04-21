package cn.edu.zju.dao;

import cn.edu.zju.bean.Drug;
import cn.edu.zju.dbutils.DBUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class DrugDao extends BaseDao {

    private static final Logger log = LoggerFactory.getLogger(DrugDao.class);

    public boolean existsById(String id) {
        return super.existsById(id, "drug");
    }

    public void saveDrug(Drug drug) {
        DBUtils.execSQL(connection -> {
            String sql = "INSERT INTO drug (id, name, obj_cls, biomarker, drug_url, description, biomarker_associated, pharmgkb_id, drugbank_id, pubchem_id, kegg_id) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, drug.getId());
                preparedStatement.setString(2, drug.getName());
                preparedStatement.setString(3, drug.getObjCls());
                preparedStatement.setBoolean(4, drug.isBiomarker());
                preparedStatement.setString(5, drug.getDrugUrl());
                preparedStatement.setString(6, drug.getDescription());
                if (drug.getBiomarkerAssociated() == null) {
                    preparedStatement.setObject(7, null);
                } else {
                    preparedStatement.setBoolean(7, drug.getBiomarkerAssociated());
                }
                preparedStatement.setString(8, drug.getPharmgkbId());
                preparedStatement.setString(9, drug.getDrugbankId());
                preparedStatement.setString(10, drug.getPubchemId());
                preparedStatement.setString(11, drug.getKeggId());

                preparedStatement.executeUpdate();
            } catch (SQLException e) {
                throw new RuntimeException("Failed to save drug.", e);
            }
        });
    }

    public List<Drug> findAll() {
        return search(null, null);
    }

    public List<Drug> search(String keyword, String biomarkerFilter) {
        List<Drug> drugs = new ArrayList<>();

        DBUtils.execSQL(connection -> {
            StringBuilder sql = new StringBuilder(
                    "SELECT id, name, obj_cls, drug_url, biomarker, " +
                            "description, biomarker_associated, pharmgkb_id, drugbank_id, pubchem_id, kegg_id " +
                            "FROM drug WHERE 1=1 "
            );

            List<Object> params = new ArrayList<>();

            if (keyword != null && !keyword.trim().isEmpty()) {
                sql.append("AND (LOWER(name) LIKE ? OR LOWER(id) LIKE ? OR LOWER(obj_cls) LIKE ?) ");
                String pattern = "%" + keyword.trim().toLowerCase() + "%";
                params.add(pattern);
                params.add(pattern);
                params.add(pattern);
            }

            if (biomarkerFilter != null && !biomarkerFilter.trim().isEmpty()) {
                if ("yes".equalsIgnoreCase(biomarkerFilter)) {
                    sql.append("AND biomarker_associated = 1 ");
                } else if ("no".equalsIgnoreCase(biomarkerFilter)) {
                    sql.append("AND (biomarker_associated = 0 OR biomarker_associated IS NULL) ");
                }
            }

            sql.append("ORDER BY name ASC");

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql.toString())) {
                for (int i = 0; i < params.size(); i++) {
                    preparedStatement.setObject(i + 1, params.get(i));
                }

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    while (resultSet.next()) {
                        drugs.add(mapDrug(resultSet));
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query drugs.", e);
            }
        });

        return drugs;
    }

    public Drug findById(String id) {
        final Drug[] result = {null};

        DBUtils.execSQL(connection -> {
            String sql = "SELECT id, name, obj_cls, drug_url, biomarker, " +
                    "description, biomarker_associated, pharmgkb_id, drugbank_id, pubchem_id, kegg_id " +
                    "FROM drug WHERE id = ?";

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setString(1, id);

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        result[0] = mapDrug(resultSet);
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query drug by id: " + id, e);
            }
        });

        return result[0];
    }

    private Drug mapDrug(ResultSet resultSet) throws SQLException {
        String id = resultSet.getString("id");
        String name = resultSet.getString("name");
        String objCls = resultSet.getString("obj_cls");
        String drugUrl = resultSet.getString("drug_url");
        boolean biomarker = resultSet.getBoolean("biomarker");

        String description = resultSet.getString("description");
        Object biomarkerAssociatedObj = resultSet.getObject("biomarker_associated");
        Boolean biomarkerAssociated = biomarkerAssociatedObj == null
                ? null
                : resultSet.getBoolean("biomarker_associated");

        String pharmgkbId = resultSet.getString("pharmgkb_id");
        String drugbankId = resultSet.getString("drugbank_id");
        String pubchemId = resultSet.getString("pubchem_id");
        String keggId = resultSet.getString("kegg_id");

        return new Drug(
                id,
                name,
                biomarker,
                drugUrl,
                objCls,
                description,
                biomarkerAssociated,
                pharmgkbId,
                drugbankId,
                pubchemId,
                keggId
        );
    }
}