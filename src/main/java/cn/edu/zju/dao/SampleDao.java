package cn.edu.zju.dao;

import cn.edu.zju.bean.Sample;
import cn.edu.zju.dbutils.DBUtils;

import java.sql.*;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.concurrent.atomic.AtomicReference;

public class SampleDao extends BaseDao {

    public int save(String uploadedBy) {
        AtomicInteger key = new AtomicInteger(0);

        DBUtils.execSQL(connection -> {
            String sql = "INSERT INTO sample(created_at, uploaded_by) VALUES (?, ?)";

            try (PreparedStatement preparedStatement =
                         connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

                preparedStatement.setTimestamp(1, new Timestamp(new Date().getTime()));
                preparedStatement.setString(2, uploadedBy);
                preparedStatement.executeUpdate();

                try (ResultSet generatedKeys = preparedStatement.getGeneratedKeys()) {
                    if (generatedKeys.next()) {
                        key.set(generatedKeys.getInt(1));
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to save sample.", e);
            }
        });

        if (key.get() <= 0) {
            throw new RuntimeException("Failed to retrieve generated sample id.");
        }

        return key.get();
    }

    public void deleteById(int id) {
        DBUtils.execSQL(connection -> {
            String deleteAnnovarSql = "DELETE FROM annovar WHERE sample_id = ?";
            String deleteSampleSql = "DELETE FROM sample WHERE id = ?";

            boolean previousAutoCommit;
            try {
                previousAutoCommit = connection.getAutoCommit();
                connection.setAutoCommit(false);

                try (PreparedStatement deleteAnnovarPs = connection.prepareStatement(deleteAnnovarSql);
                     PreparedStatement deleteSamplePs = connection.prepareStatement(deleteSampleSql)) {

                    deleteAnnovarPs.setInt(1, id);
                    deleteAnnovarPs.executeUpdate();

                    deleteSamplePs.setInt(1, id);
                    deleteSamplePs.executeUpdate();

                    connection.commit();
                } catch (Exception e) {
                    connection.rollback();
                    throw e;
                } finally {
                    connection.setAutoCommit(previousAutoCommit);
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to delete sample by id: " + id, e);
            }
        });
    }

    public List<Sample> findAll() {
        List<Sample> samples = new ArrayList<>();

        DBUtils.execSQL(connection -> {
            String sql = "SELECT id, created_at, uploaded_by FROM sample ORDER BY id DESC";

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql);
                 ResultSet resultSet = preparedStatement.executeQuery()) {

                while (resultSet.next()) {
                    int sampleId = resultSet.getInt("id");
                    Timestamp createdAtTs = resultSet.getTimestamp("created_at");
                    Date createdAt = createdAtTs == null ? null : new Date(createdAtTs.getTime());
                    String uploadedBy = resultSet.getString("uploaded_by");

                    Sample sample = new Sample(sampleId, createdAt, uploadedBy);
                    samples.add(sample);
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query all samples.", e);
            }
        });

        return samples;
    }

    public Sample findById(int id) {
        AtomicReference<Sample> sample = new AtomicReference<>(null);

        DBUtils.execSQL(connection -> {
            String sql = "SELECT id, created_at, uploaded_by FROM sample WHERE id = ?";

            try (PreparedStatement preparedStatement = connection.prepareStatement(sql)) {
                preparedStatement.setInt(1, id);

                try (ResultSet resultSet = preparedStatement.executeQuery()) {
                    if (resultSet.next()) {
                        int sampleId = resultSet.getInt("id");
                        Timestamp createdAtTs = resultSet.getTimestamp("created_at");
                        Date createdAt = createdAtTs == null ? null : new Date(createdAtTs.getTime());
                        String uploadedBy = resultSet.getString("uploaded_by");

                        sample.set(new Sample(sampleId, createdAt, uploadedBy));
                    }
                }
            } catch (SQLException e) {
                throw new RuntimeException("Failed to query sample by id: " + id, e);
            }
        });

        return sample.get();
    }
}