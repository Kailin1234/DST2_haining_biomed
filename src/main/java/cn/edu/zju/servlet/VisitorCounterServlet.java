package cn.edu.zju.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/visitorCounter")
public class VisitorCounterServlet extends HttpServlet {

    private static final String JDBC_URL =
            "jdbc:mysql://localhost:3306/biomed?useSSL=false&serverTimezone=UTC";
    private static final String JDBC_USER = "root";
    private static final String JDBC_PASSWORD = "bZr88#99";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int currentCount = 0;
        int newCount = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            try (Connection conn = DriverManager.getConnection(JDBC_URL, JDBC_USER, JDBC_PASSWORD)) {

                String selectSql = "SELECT count FROM visitor_counter WHERE id = 1";
                try (PreparedStatement selectStmt = conn.prepareStatement(selectSql);
                     ResultSet rs = selectStmt.executeQuery()) {
                    if (rs.next()) {
                        currentCount = rs.getInt("count");
                    }
                }

                newCount = currentCount + 1;

                String updateSql = "UPDATE visitor_counter SET count = ? WHERE id = 1";
                try (PreparedStatement updateStmt = conn.prepareStatement(updateSql)) {
                    updateStmt.setInt(1, newCount);
                    updateStmt.executeUpdate();
                }
            }

        } catch (Exception e) {
            throw new ServletException("Visitor counter failed.", e);
        }

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html lang='en'>");
        out.println("<head>");
        out.println("<meta charset='UTF-8'>");
        out.println("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.println("<title>Visitor Counter</title>");
        out.println("<style>");
        out.println("* { margin: 0; padding: 0; box-sizing: border-box; }");
        out.println("body {");
        out.println("    min-height: 100vh;");
        out.println("    display: flex;");
        out.println("    justify-content: center;");
        out.println("    align-items: center;");
        out.println("    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;");
        out.println("    background: linear-gradient(135deg, #eef2ff 0%, #f8fafc 50%, #e0f2fe 100%);");
        out.println("}");
        out.println(".card {");
        out.println("    width: 420px;");
        out.println("    background: rgba(255, 255, 255, 0.92);");
        out.println("    border-radius: 24px;");
        out.println("    padding: 40px 36px;");
        out.println("    text-align: center;");
        out.println("    box-shadow: 0 20px 50px rgba(0, 0, 0, 0.12);");
        out.println("    border: 1px solid rgba(255,255,255,0.7);");
        out.println("    backdrop-filter: blur(10px);");
        out.println("}");
        out.println(".icon {");
        out.println("    width: 72px;");
        out.println("    height: 72px;");
        out.println("    margin: 0 auto 18px;");
        out.println("    border-radius: 50%;");
        out.println("    display: flex;");
        out.println("    align-items: center;");
        out.println("    justify-content: center;");
        out.println("    font-size: 34px;");
        out.println("    background: linear-gradient(135deg, #3b82f6, #6366f1);");
        out.println("    color: white;");
        out.println("    box-shadow: 0 10px 25px rgba(59,130,246,0.35);");
        out.println("}");
        out.println("h1 {");
        out.println("    font-size: 38px;");
        out.println("    color: #0f172a;");
        out.println("    margin-bottom: 12px;");
        out.println("    font-weight: 700;");
        out.println("}");
        out.println(".subtitle {");
        out.println("    font-size: 18px;");
        out.println("    color: #475569;");
        out.println("    margin-bottom: 28px;");
        out.println("}");
        out.println(".count-box {");
        out.println("    margin: 22px auto 28px;");
        out.println("    padding: 24px 20px;");
        out.println("    border-radius: 20px;");
        out.println("    background: linear-gradient(135deg, #eff6ff, #eef2ff);");
        out.println("    border: 1px solid #dbeafe;");
        out.println("}");
        out.println(".count-label {");
        out.println("    font-size: 14px;");
        out.println("    color: #64748b;");
        out.println("    text-transform: uppercase;");
        out.println("    letter-spacing: 1.2px;");
        out.println("    margin-bottom: 10px;");
        out.println("}");
        out.println(".count {");
        out.println("    font-size: 72px;");
        out.println("    font-weight: 800;");
        out.println("    color: #2563eb;");
        out.println("    line-height: 1;");
        out.println("}");
        out.println(".tip {");
        out.println("    font-size: 15px;");
        out.println("    color: #64748b;");
        out.println("    margin-bottom: 22px;");
        out.println("}");
        out.println(".btn {");
        out.println("    display: inline-block;");
        out.println("    text-decoration: none;");
        out.println("    padding: 12px 22px;");
        out.println("    border-radius: 999px;");
        out.println("    background: linear-gradient(135deg, #2563eb, #4f46e5);");
        out.println("    color: white;");
        out.println("    font-weight: 600;");
        out.println("    font-size: 15px;");
        out.println("    box-shadow: 0 10px 20px rgba(37,99,235,0.25);");
        out.println("    transition: transform 0.2s ease;");
        out.println("}");
        out.println(".btn:hover {");
        out.println("    transform: translateY(-2px);");
        out.println("}");
        out.println(".footer {");
        out.println("    margin-top: 18px;");
        out.println("    font-size: 13px;");
        out.println("    color: #94a3b8;");
        out.println("}");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        out.println("<div class='card'>");
        out.println("<div class='icon'>👁</div>");
        out.println("<h1>Visitor Counter</h1>");
        out.println("<div class='subtitle'>Track how many times this page has been visited</div>");
        out.println("<div class='count-box'>");
        out.println("<div class='count-label'>Current Visits</div>");
        out.println("<div class='count'>" + newCount + "</div>");
        out.println("</div>");
        out.println("<div class='tip'>Refresh the page to increase the counter by 1.</div>");
        out.println("<a class='btn' href='visitorCounter'>Refresh Counter</a>");
        out.println("<div class='footer'>Simple Java Servlet Visitor Counter</div>");
        out.println("</div>");
        out.println("</body>");
        out.println("</html>");
    }
}