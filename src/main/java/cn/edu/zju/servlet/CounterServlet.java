package cn.edu.zju.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

@WebServlet(name = "CounterServlet", urlPatterns = "/counter")
public class CounterServlet extends HttpServlet {

    private int counter = 0;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        counter++;

        response.setContentType("text/html;charset=UTF-8");
        PrintWriter out = response.getWriter();

        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head>");
        out.println("<title>Colorful Visitor Counter</title>");
        out.println("<style>");

        out.println("body {");
        out.println("  margin: 0;");
        out.println("  height: 100vh;");
        out.println("  display: flex;");
        out.println("  justify-content: center;");
        out.println("  align-items: center;");
        out.println("  font-family: 'Segoe UI', sans-serif;");
        out.println("  background: linear-gradient(135deg, #667eea, #764ba2);");
        out.println("  overflow: hidden;");
        out.println("}");

        out.println(".circle {");
        out.println("  position: absolute;");
        out.println("  border-radius: 50%;");
        out.println("  opacity: 0.2;");
        out.println("}");

        out.println(".circle1 { width: 300px; height: 300px; background: #ffffff; top: -100px; left: -100px; }");
        out.println(".circle2 { width: 200px; height: 200px; background: #ffcc70; bottom: -80px; right: -80px; }");

        out.println(".card {");
        out.println("  background: rgba(255,255,255,0.15);");
        out.println("  padding: 50px;");
        out.println("  border-radius: 20px;");
        out.println("  backdrop-filter: blur(15px);");
        out.println("  box-shadow: 0 15px 40px rgba(0,0,0,0.3);");
        out.println("  text-align: center;");
        out.println("  color: white;");
        out.println("  animation: float 3s ease-in-out infinite;");
        out.println("}");

        out.println("@keyframes float {");
        out.println("  0% { transform: translateY(0px); }");
        out.println("  50% { transform: translateY(-10px); }");
        out.println("  100% { transform: translateY(0px); }");
        out.println("}");

        out.println(".count {");
        out.println("  font-size: 70px;");
        out.println("  font-weight: bold;");
        out.println("  background: linear-gradient(45deg, #ff6ec4, #7873f5);");
        out.println("  -webkit-background-clip: text;");
        out.println("  -webkit-text-fill-color: transparent;");
        out.println("  margin: 25px 0;");
        out.println("}");

        out.println("button {");
        out.println("  padding: 12px 30px;");
        out.println("  font-size: 16px;");
        out.println("  border: none;");
        out.println("  border-radius: 25px;");
        out.println("  background: linear-gradient(45deg, #ff9a9e, #fad0c4);");
        out.println("  cursor: pointer;");
        out.println("  transition: 0.3s;");
        out.println("}");

        out.println("button:hover {");
        out.println("  transform: scale(1.1);");
        out.println("}");

        out.println("</style>");
        out.println("</head>");
        out.println("<body>");

        out.println("<div class='circle circle1'></div>");
        out.println("<div class='circle circle2'></div>");

        out.println("<div class='card'>");
        out.println("<h2>🌟 Visitor Counter 🌟</h2>");
        out.println("<div class='count'>" + counter + "</div>");
        out.println("<form method='get'>");
        out.println("<button type='submit'>Refresh</button>");
        out.println("</form>");
        out.println("</div>");

        out.println("</body>");
        out.println("</html>");
    }
}