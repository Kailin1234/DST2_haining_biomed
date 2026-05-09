package cn.edu.zju.dao;

import cn.edu.zju.bean.UserAccount;
import cn.edu.zju.dbutils.DBUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;

public class UserDao extends BaseDao {

    private static final Logger log = LoggerFactory.getLogger(UserDao.class);

    public UserAccount findByUsername(String username) {
        AtomicReference<UserAccount> userRef = new AtomicReference<>(null);

        DBUtils.execSQL(connection -> {
            String sql = "SELECT id, username, password, role, created_at " +
                    "FROM user_account WHERE username = ?";

            try {
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, username);

                ResultSet resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {
                    UserAccount user = new UserAccount();
                    user.setId(resultSet.getInt("id"));
                    user.setUsername(resultSet.getString("username"));
                    user.setPassword(resultSet.getString("password"));
                    user.setRole(resultSet.getString("role"));
                    user.setCreatedAt(resultSet.getTimestamp("created_at"));

                    userRef.set(user);
                }

            } catch (SQLException e) {
                log.info("Failed to find user by username: {}", username, e);
            }
        });

        return userRef.get();
    }

    public boolean existsByUsername(String username) {
        AtomicBoolean exists = new AtomicBoolean(false);

        DBUtils.execSQL(connection -> {
            String sql = "SELECT 1 FROM user_account WHERE username = ?";

            try {
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, username);

                ResultSet resultSet = preparedStatement.executeQuery();

                if (resultSet.next()) {
                    exists.set(true);
                }

            } catch (SQLException e) {
                log.info("Failed to check username existence: {}", username, e);
            }
        });

        return exists.get();
    }

    public boolean save(UserAccount user) {
        AtomicBoolean success = new AtomicBoolean(false);

        DBUtils.execSQL(connection -> {
            String sql = "INSERT INTO user_account (username, password, role) " +
                    "VALUES (?, ?, ?)";

            try {
                PreparedStatement preparedStatement = connection.prepareStatement(sql);
                preparedStatement.setString(1, user.getUsername());
                preparedStatement.setString(2, user.getPassword());
                preparedStatement.setString(3, user.getRole());

                int rows = preparedStatement.executeUpdate();

                if (rows > 0) {
                    success.set(true);
                }

            } catch (SQLException e) {
                log.info("Failed to save user: {}", user.getUsername(), e);
            }
        });

        return success.get();
    }

    public UserAccount login(String username, String password) {
        UserAccount user = findByUsername(username);

        if (user == null) {
            return null;
        }

        if (user.getPassword() == null) {
            return null;
        }

        if (!user.getPassword().equals(password)) {
            return null;
        }

        return user;
    }
}