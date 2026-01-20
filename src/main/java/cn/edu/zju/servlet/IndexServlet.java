package cn.edu.zju.servlet;

import cn.edu.zju.filter.AuthenticationFilter;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Enumeration;

@WebServlet(name = "IndexServlet", urlPatterns = {"/index"})
public class IndexServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 暂时不需要
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ====== 你原来的调试输出（保留也行）======
        Enumeration<String> attributeNames = request.getSession().getAttributeNames();
        System.out.println("print session");
        System.out.println(request.getSession().getAttribute(AuthenticationFilter.USERNAME));
        while (attributeNames.hasMoreElements()) {
            System.out.println(attributeNames.nextElement());
        }

        // ====== ✅ 新增：Visitor counter（最简单版本）======
        ServletContext context = getServletContext();
        Integer count = (Integer) context.getAttribute("visitorCount");
        if (count == null) count = 0;

        count++;
        context.setAttribute("visitorCount", count);

        // 传给 JSP 显示
        request.setAttribute("count", count);

        // ====== 转发到主页 ======
        request.getRequestDispatcher("/views/index.jsp").forward(request, response);
    }
}
