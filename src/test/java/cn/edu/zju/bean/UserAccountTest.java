package cn.edu.zju.bean;

import org.junit.Test;

import java.sql.Timestamp;

import static org.junit.Assert.*;

public class UserAccountTest {

    @Test
    public void constructor_shouldInitializeAllFields() {
        // Given
        Timestamp createdAt = new Timestamp(System.currentTimeMillis());

        // When
        UserAccount user = new UserAccount(
                1,
                "testUser",
                "testPassword",
                "general",
                createdAt
        );

        // Then
        assertEquals(Integer.valueOf(1), user.getId());
        assertEquals("testUser", user.getUsername());
        assertEquals("testPassword", user.getPassword());
        assertEquals("general", user.getRole());
        assertEquals(createdAt, user.getCreatedAt());
    }

    @Test
    public void settersAndGetters_shouldStoreCorrectValues() {
        // Given
        UserAccount user = new UserAccount();
        Timestamp createdAt = new Timestamp(System.currentTimeMillis());

        // When
        user.setId(2);
        user.setUsername("professionalUser");
        user.setPassword("securePassword");
        user.setRole("professional");
        user.setCreatedAt(createdAt);

        // Then
        assertEquals(Integer.valueOf(2), user.getId());
        assertEquals("professionalUser", user.getUsername());
        assertEquals("securePassword", user.getPassword());
        assertEquals("professional", user.getRole());
        assertEquals(createdAt, user.getCreatedAt());
    }

    @Test
    public void isGeneral_whenRoleIsGeneral_returnsTrue() {
        // Given
        UserAccount user = new UserAccount();
        user.setRole("general");

        // Then
        assertTrue(user.isGeneral());
        assertFalse(user.isProfessional());
    }

    @Test
    public void isProfessional_whenRoleIsProfessional_returnsTrue() {
        // Given
        UserAccount user = new UserAccount();
        user.setRole("professional");

        // Then
        assertTrue(user.isProfessional());
        assertFalse(user.isGeneral());
    }

    @Test
    public void roleCheck_shouldBeCaseInsensitive() {
        // Given
        UserAccount generalUser = new UserAccount();
        generalUser.setRole("GENERAL");

        UserAccount professionalUser = new UserAccount();
        professionalUser.setRole("Professional");

        // Then
        assertTrue(generalUser.isGeneral());
        assertTrue(professionalUser.isProfessional());
    }

    @Test
    public void roleCheck_whenRoleIsNullOrUnknown_returnsFalse() {
        // Given
        UserAccount nullRoleUser = new UserAccount();
        nullRoleUser.setRole(null);

        UserAccount unknownRoleUser = new UserAccount();
        unknownRoleUser.setRole("visitor");

        // Then
        assertFalse(nullRoleUser.isGeneral());
        assertFalse(nullRoleUser.isProfessional());

        assertFalse(unknownRoleUser.isGeneral());
        assertFalse(unknownRoleUser.isProfessional());
    }
}