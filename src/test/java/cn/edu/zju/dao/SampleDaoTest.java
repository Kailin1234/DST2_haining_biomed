package cn.edu.zju.dao;

import cn.edu.zju.bean.Sample;
import cn.edu.zju.dbutils.DBUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import static org.junit.Assert.*;

public class SampleDaoTest {

    private SampleDao sampleDao;

    private static final String TEST_USER_A = "junit_user_a";
    private static final String TEST_USER_B = "junit_user_b";

    @Before
    public void setUp() {
        sampleDao = new SampleDao();
        cleanTestData();
    }

    @After
    public void tearDown() {
        cleanTestData();
    }

    @Test
    public void save_whenUploadedByProvided_createsSampleAndReturnsId() {
        // Given
        String uploadedBy = TEST_USER_A;

        // When
        int sampleId = sampleDao.save(uploadedBy);

        // Then
        assertTrue(sampleId > 0);

        Sample savedSample = sampleDao.findById(sampleId);
        assertNotNull(savedSample);
        assertEquals(sampleId, savedSample.getId());
        assertEquals(TEST_USER_A, savedSample.getUploadedBy());
        assertNotNull(savedSample.getCreatedAt());
    }

    @Test
    public void findById_whenSampleExists_mapsSampleFieldsCorrectly() {
        // Given
        int sampleId = sampleDao.save(TEST_USER_A);

        // When
        Sample sample = sampleDao.findById(sampleId);

        // Then
        assertNotNull(sample);
        assertEquals(sampleId, sample.getId());
        assertEquals(TEST_USER_A, sample.getUploadedBy());
        assertNotNull(sample.getCreatedAt());
    }

    @Test
    @SuppressWarnings("unchecked")
    public void findByUploadedBy_whenMultipleUsersExist_returnsOnlyRequestedUserSamples() {
        // Given
        int userASample1 = sampleDao.save(TEST_USER_A);
        int userASample2 = sampleDao.save(TEST_USER_A);
        int userBSample = sampleDao.save(TEST_USER_B);

        // When
        List<Sample> userASamples = sampleDao.findByUploadedBy(TEST_USER_A);

        // Then
        assertEquals(2, userASamples.size());

        for (Sample sample : userASamples) {
            assertEquals(TEST_USER_A, sample.getUploadedBy());
            assertNotEquals(userBSample, sample.getId());
        }

        assertTrue(containsSampleId(userASamples, userASample1));
        assertTrue(containsSampleId(userASamples, userASample2));
    }

    @Test
    public void deleteById_whenSampleExists_removesSampleFromDatabase() {
        // Given
        int sampleId = sampleDao.save(TEST_USER_A);
        assertNotNull(sampleDao.findById(sampleId));

        // When
        sampleDao.deleteById(sampleId);

        // Then
        Sample deletedSample = sampleDao.findById(sampleId);
        assertNull(deletedSample);
    }

    private boolean containsSampleId(List<Sample> samples, int sampleId) {
        for (Sample sample : samples) {
            if (sample.getId() == sampleId) {
                return true;
            }
        }
        return false;
    }

    private void cleanTestData() {
        try (Connection connection = DBUtils.getConnection()) {
            if (connection == null) {
                throw new RuntimeException("Database connection is null.");
            }

            deleteRelatedAnnovarRows(connection);
            deleteSampleRows(connection);

        } catch (SQLException e) {
            throw new RuntimeException("Failed to clean sample test data.", e);
        }
    }

    private void deleteRelatedAnnovarRows(Connection connection) throws SQLException {
        String sql =
                "DELETE FROM annovar " +
                        "WHERE sample_id IN (" +
                        "SELECT id FROM sample WHERE uploaded_by IN (?, ?)" +
                        ")";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, TEST_USER_A);
            preparedStatement.setString(2, TEST_USER_B);
            preparedStatement.executeUpdate();
        }
    }

    private void deleteSampleRows(Connection connection) throws SQLException {
        String sql = "DELETE FROM sample WHERE uploaded_by IN (?, ?)";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, TEST_USER_A);
            preparedStatement.setString(2, TEST_USER_B);
            preparedStatement.executeUpdate();
        }
    }
}