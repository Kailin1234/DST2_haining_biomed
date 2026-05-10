package cn.edu.zju.dao;

import cn.edu.zju.dbutils.DBUtils;
import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.util.List;

import static org.junit.Assert.*;

public class AnnovarDaoTest {

    private AnnovarDao annovarDao;
    private SampleDao sampleDao;

    private int sampleId;

    private static final String TEST_USER = "junit_annovar_user";

    @Before
    public void setUp() {
        annovarDao = new AnnovarDao();
        sampleDao = new SampleDao();

        cleanTestData();
        sampleId = sampleDao.save(TEST_USER);
    }

    @After
    public void tearDown() {
        cleanTestData();
    }

    @Test
    public void save_whenValidTsv_savesRowsAndGetRefGenesReturnsNonSynonymousGenes() {
        // Given
        String content =
                "Chr\tStart\tEnd\tRef\tAlt\tGene.refGene\tExonicFunc.refGene\n" +
                        "7\t55249071\t55249071\tC\tT\tEGFR\tnonsynonymous SNV\n" +
                        "17\t7579472\t7579472\tG\tA\tTP53\tsynonymous SNV\n" +
                        "7\t140453136\t140453136\tA\tT\tBRAF\tnonsynonymous SNV\n";

        // When
        annovarDao.save(sampleId, content);
        List<String> genes = annovarDao.getRefGenes(sampleId);

        // Then
        assertEquals(2, genes.size());
        assertTrue(genes.contains("EGFR"));
        assertTrue(genes.contains("BRAF"));
        assertFalse(genes.contains("TP53"));
    }

    @Test
    public void save_whenUsingSimpleGeneHeader_acceptsAlternativeHeaderName() {
        // Given
        String content =
                "Chr\tStart\tRef\tAlt\tGene\n" +
                        "12\t25398284\tC\tT\tKRAS\n";

        // When
        annovarDao.save(sampleId, content);
        List<String> genes = annovarDao.getRefGenes(sampleId);

        // Then
        assertEquals(1, genes.size());
        assertTrue(genes.contains("KRAS"));
    }

    @Test(expected = IllegalArgumentException.class)
    public void save_whenMissingGeneHeader_throwsIllegalArgumentException() {
        // Given
        String content =
                "Chr\tStart\tRef\tAlt\n" +
                        "7\t55249071\tC\tT\n";

        // When
        annovarDao.save(sampleId, content);
    }

    @Test(expected = IllegalArgumentException.class)
    public void save_whenFileHasOnlyHeader_throwsIllegalArgumentException() {
        // Given
        String content =
                "Chr\tStart\tEnd\tRef\tAlt\tGene.refGene\tExonicFunc.refGene\n";

        // When
        annovarDao.save(sampleId, content);
    }

    @Test(expected = IllegalArgumentException.class)
    public void save_whenAllRowsAreInvalid_throwsIllegalArgumentException() {
        // Given
        String content =
                "Chr\tStart\tEnd\tRef\tAlt\tGene.refGene\tExonicFunc.refGene\n" +
                        "7\t55249071\t55249071\tC\tT\t\tnonsynonymous SNV\n";

        // When
        annovarDao.save(sampleId, content);
    }

    private void cleanTestData() {
        try (Connection connection = DBUtils.getConnection()) {
            if (connection == null) {
                throw new RuntimeException("Database connection is null.");
            }

            deleteRelatedAnnovarRows(connection);
            deleteSampleRows(connection);

        } catch (SQLException e) {
            throw new RuntimeException("Failed to clean Annovar test data.", e);
        }
    }

    private void deleteRelatedAnnovarRows(Connection connection) throws SQLException {
        String sql =
                "DELETE FROM annovar " +
                        "WHERE sample_id IN (" +
                        "SELECT id FROM sample WHERE uploaded_by = ?" +
                        ")";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, TEST_USER);
            preparedStatement.executeUpdate();
        }
    }

    private void deleteSampleRows(Connection connection) throws SQLException {
        String sql = "DELETE FROM sample WHERE uploaded_by = ?";

        try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
            preparedStatement.setString(1, TEST_USER);
            preparedStatement.executeUpdate();
        }
    }
}