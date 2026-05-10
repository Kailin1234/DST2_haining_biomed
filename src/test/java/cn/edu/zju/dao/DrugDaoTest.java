package cn.edu.zju.dao;

import cn.edu.zju.bean.Drug;
import cn.edu.zju.dbutils.DBUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import static org.junit.Assert.*;

public class DrugDaoTest {

    private DrugDao drugDao;

    private static final String TEST_DRUG_ID = "DRUG_JUNIT_EGFR";

    @Before
    public void setUp() {
        drugDao = new DrugDao();
        cleanTestData();
    }

    @After
    public void tearDown() {
        cleanTestData();
    }

    @Test
    public void existsById_whenDrugExists_returnsTrue() {
        // Given
        Drug drug = buildTestDrug();
        drugDao.saveDrug(drug);

        // When
        boolean exists = drugDao.existsById(TEST_DRUG_ID);

        // Then
        assertTrue(exists);
    }

    @Test
    public void existsById_whenDrugDoesNotExist_returnsFalse() {
        // Given
        String missingDrugId = "DRUG_JUNIT_NOT_EXIST";

        // When
        boolean exists = drugDao.existsById(missingDrugId);

        // Then
        assertFalse(exists);
    }

    @Test
    public void saveDrug_whenValidDrug_insertsDrugIntoDatabase() {
        // Given
        Drug drug = buildTestDrug();

        // When
        drugDao.saveDrug(drug);

        // Then
        assertTrue(drugDao.existsById(TEST_DRUG_ID));
    }

    @Test
    @SuppressWarnings("unchecked")
    public void findAll_whenDrugExists_mapsDrugFieldsCorrectly() {
        // Given
        Drug drug = buildTestDrug();
        drugDao.saveDrug(drug);

        // When
        List<Drug> drugs = drugDao.findAll();

        // Then
        Drug found = null;
        for (Drug item : drugs) {
            if (TEST_DRUG_ID.equals(item.getId())) {
                found = item;
                break;
            }
        }

        assertNotNull(found);
        assertEquals(TEST_DRUG_ID, found.getId());
        assertEquals("JUnit Gefitinib", found.getName());
        assertEquals("Drug", found.getObjCls());
        assertTrue(found.isBiomarker());
        assertEquals("EGFR tyrosine kinase inhibitor for JUnit testing", found.getDescription());
        assertEquals(Boolean.TRUE, found.getBiomarkerAssociated());
        assertEquals("PA_TEST_EGFR", found.getPharmgkbId());
        assertEquals("DB_TEST_EGFR", found.getDrugbankId());
        assertEquals("123456", found.getPubchemId());
        assertEquals("D_TEST_EGFR", found.getKeggId());
    }

    private Drug buildTestDrug() {
        return new Drug(
                TEST_DRUG_ID,
                "JUnit Gefitinib",
                true,
                "https://example.com/junit-gefitinib",
                "Drug",
                "EGFR tyrosine kinase inhibitor for JUnit testing",
                true,
                "PA_TEST_EGFR",
                "DB_TEST_EGFR",
                "123456",
                "D_TEST_EGFR"
        );
    }

    private void cleanTestData() {
        DBUtils.execSQL(connection -> {
            try {
                deleteById(connection, "drug_label", "LABEL_JUNIT_EGFR");
                deleteById(connection, "drug", TEST_DRUG_ID);
            } catch (SQLException e) {
                throw new RuntimeException("Failed to clean test data.", e);
            }
        });
    }

    private void deleteById(java.sql.Connection connection, String tableName, String id) throws SQLException {
        String sql = "DELETE FROM " + tableName + " WHERE id = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, id);
            preparedStatement.executeUpdate();
        }
    }
}