package cn.edu.zju.servlet;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.StandardCharsets;

@WebServlet(name = "CounterServlet", urlPatterns = "/counter")
public class CounterServlet extends HttpServlet {

    private int counter = 0;
    private String counterFilePath; // 设置用来记录counter内容的.txt文件路径

    @Override // 表示重写方法，可以提高代码可读性，另外如果方法名写错了编译器也会报错
    public void init() throws ServletException {
        counterFilePath = getServletContext().getRealPath("/WEB-INF/counter.txt");
        File file = new File(counterFilePath);

        try {
            if (!file.exists()) {
                file.getParentFile().mkdirs();
                try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                    writer.write("0");
                }
            }

            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String line = reader.readLine();
                if (line != null && !line.trim().isEmpty()) {
                    counter = Integer.parseInt(line.trim());
                }
            }
        } catch (IOException | NumberFormatException e) {
            throw new ServletException("Failed to initialize counter.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }

    @Override
    protected synchronized void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        counter++;

        try (BufferedWriter writer = new BufferedWriter(
                new OutputStreamWriter(new FileOutputStream(counterFilePath), StandardCharsets.UTF_8))) {
            writer.write(String.valueOf(counter));
        }

        response.setContentType("text/html;charset=UTF-8"); // 表示返回html网页，用UTF-8编码，防止中文乱码
        PrintWriter out = response.getWriter();

        out.write("<!DOCTYPE html>");
        out.write("<html lang='en'>");
        out.write("<head>");
        out.write("<meta charset='UTF-8'>");
        out.write("<meta name='viewport' content='width=device-width, initial-scale=1.0'>");
        out.write("<title>Visitor Counter</title>");
        out.write("<style>");
        out.write("* { margin: 0; padding: 0; box-sizing: border-box; }");
        out.write("body { min-height: 100vh; display: flex; justify-content: center; align-items: center; font-family: Arial, sans-serif; background: linear-gradient(135deg, #eef2ff, #e0f2fe); }");
        out.write(".card { width: 420px; background: white; border-radius: 20px; padding: 40px 30px; text-align: center; box-shadow: 0 12px 30px rgba(0,0,0,0.12); }");
        out.write("h1 { color: #1e3a8a; margin-bottom: 16px; font-size: 32px; }");
        out.write(".desc { color: #475569; margin-bottom: 24px; font-size: 16px; }");
        out.write(".count { font-size: 64px; font-weight: bold; color: #2563eb; margin: 20px 0; }");
        out.write(".tip { color: #64748b; font-size: 14px; margin-top: 20px; }");
        out.write(".btn { display: inline-block; margin-top: 24px; padding: 10px 20px; background: #2563eb; color: white; text-decoration: none; border-radius: 999px; font-size: 14px; }");
        out.write("</style>");
        out.write("</head>");
        out.write("<body>");
        out.write("<div class='card'>");
        out.write("<h1>Visitor Counter</h1>");
        out.write("<div class='desc'>This page records how many times it has been visited.</div>");
        out.write("<div class='count'>" + counter + "</div>");
        out.write("<a class='btn' href='" + request.getContextPath() + "/counter'>Refresh</a>");
        out.write("<div class='tip'>The count is stored in a file, so restarting Tomcat will not reset it.</div>");
        out.write("</div>");
        out.write("</body>");
        out.write("</html>");
    }
}
