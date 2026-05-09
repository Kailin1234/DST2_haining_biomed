package cn.edu.zju.controller;

import cn.edu.zju.bean.UserAccount;
import cn.edu.zju.dao.UserDao;
import cn.edu.zju.servlet.DispatchServlet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class AuthController {

    private static final Logger log = LoggerFactory.getLogger(AuthController.class);

    private final UserDao userDao = new UserDao();

    public void register(DispatchServlet.Dispatcher dispatcher) {
        dispatcher.registerGetMapping("/login", this::loginPage);
        dispatcher.registerGetMapping("/register", this::registerPage);
        dispatcher.registerGetMapping("/logout", this::logout);

        dispatcher.registerPostMapping("/login", this::login);
        dispatcher.registerPostMapping("/register", this::registerUser);
    }

    public void loginPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String message = safeTrim(request.getParameter("message"));
        String redirect = normalizeRedirect(request.getParameter("redirect"));

        if (!message.isEmpty()) {
            request.setAttribute("message", message);
        }

        request.setAttribute("redirect", redirect);
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    public void registerPage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/register.jsp").forward(request, response);
    }

    public void logout(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getSession().invalidate();
        response.sendRedirect(request.getContextPath() + "/");
    }

    public void login(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = safeTrim(request.getParameter("username"));
        String password = safeTrim(request.getParameter("password"));
        String redirect = normalizeRedirect(request.getParameter("redirect"));

        if (username.isEmpty() || password.isEmpty()) {
            request.setAttribute("error", "Username and password are required.");
            request.setAttribute("redirect", redirect);
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        UserAccount user = userDao.login(username, password);

        if (user == null) {
            request.setAttribute("error", "Invalid username or password.");
            request.setAttribute("redirect", redirect);
            request.getRequestDispatcher("/views/login.jsp").forward(request, response);
            return;
        }

        request.getSession().setAttribute("loginUser", user);

        log.info("User logged in: {}, role: {}", user.getUsername(), user.getRole());

        response.sendRedirect(request.getContextPath() + redirect);
    }

    public void registerUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = safeTrim(request.getParameter("username"));
        String password = safeTrim(request.getParameter("password"));
        String role = safeTrim(request.getParameter("role"));

        if (username.isEmpty() || password.isEmpty() || role.isEmpty()) {
            request.setAttribute("error", "Username, password, and user role are required.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        if (!"general".equals(role) && !"professional".equals(role)) {
            request.setAttribute("error", "Invalid user role.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        if (userDao.existsByUsername(username)) {
            request.setAttribute("error", "This username already exists. Please choose another username.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        UserAccount user = new UserAccount();
        user.setUsername(username);
        user.setPassword(password);
        user.setRole(role);

        boolean saved = userDao.save(user);

        if (!saved) {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.getRequestDispatcher("/views/register.jsp").forward(request, response);
            return;
        }

        log.info("New user registered: {}, role: {}", username, role);

        request.setAttribute("message", "Registration successful. Please sign in.");
        request.setAttribute("redirect", "/");
        request.getRequestDispatcher("/views/login.jsp").forward(request, response);
    }

    private String safeTrim(String value) {
        if (value == null) {
            return "";
        }
        return value.trim();
    }

    private String normalizeRedirect(String redirect) {
        redirect = safeTrim(redirect);

        if (redirect.isEmpty()) {
            return "/";
        }

        /*
         * Only allow internal redirect paths.
         * This prevents unsafe redirects to external websites.
         */
        if (!redirect.startsWith("/") || redirect.startsWith("//")) {
            return "/";
        }

        return redirect;
    }
}