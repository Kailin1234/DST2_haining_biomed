package cn.edu.zju.controller;

import cn.edu.zju.bean.DosingGuideline;
import cn.edu.zju.bean.Drug;
import cn.edu.zju.bean.DrugLabel;
import cn.edu.zju.bean.UserAccount;
import cn.edu.zju.dao.DosingGuidelineDao;
import cn.edu.zju.dao.DrugDao;
import cn.edu.zju.dao.DrugLabelDao;
import cn.edu.zju.servlet.DispatchServlet;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class KnowledgeBaseController {

    private static final Logger log = LoggerFactory.getLogger(KnowledgeBaseController.class);

    private final DrugDao drugDao = new DrugDao();
    private final DrugLabelDao drugLabelDao = new DrugLabelDao();
    private final DosingGuidelineDao dosingGuidelineDao = new DosingGuidelineDao();

    /**
     * Build current request path with query string.
     * This is used for redirecting visitor back after login.
     */
    private String buildCurrentPath(HttpServletRequest request) {

        String uri = request.getRequestURI();
        String contextPath = request.getContextPath();

        if (contextPath != null && !contextPath.isEmpty() && uri.startsWith(contextPath)) {
            uri = uri.substring(contextPath.length());
        }

        String queryString = request.getQueryString();

        if (queryString != null && !queryString.isEmpty()) {
            uri = uri + "?" + queryString;
        }

        return uri;
    }

    /**
     * Only professional users can view dosing guideline detail.
     *
     * Visitor:
     * - redirected to login page.
     *
     * General user:
     * - redirected back to dosing guideline list with a message.
     *
     * Professional user:
     * - allowed to continue.
     */
    private boolean requireProfessionalForDosingDetail(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        UserAccount loginUser = (UserAccount) request.getSession().getAttribute("loginUser");

        if (loginUser == null) {

            String redirect = buildCurrentPath(request);
            String message = "Please sign in with a professional account to view detailed dosing guideline information.";

            response.sendRedirect(
                    request.getContextPath()
                            + "/login?message=" + java.net.URLEncoder.encode(message, "UTF-8")
                            + "&redirect=" + java.net.URLEncoder.encode(redirect, "UTF-8")
            );

            return false;
        }

        String role = loginUser.getRole();

        if (role == null || !"professional".equalsIgnoreCase(role.trim())) {

            String message = "Dosing guideline detail is only available to professional users.";

            response.sendRedirect(
                    request.getContextPath()
                            + "/dosingGuideline?message=" + java.net.URLEncoder.encode(message, "UTF-8")
            );

            return false;
        }

        return true;
    }

    public void register(DispatchServlet.Dispatcher dispatcher) {

        dispatcher.registerGetMapping("/drugs", this::drugs);
        dispatcher.registerGetMapping("/drugDetail", this::drugDetail);
        dispatcher.registerGetMapping("/drugLabels", this::drugLabels);
        dispatcher.registerGetMapping("/drugLabelDetail", this::drugLabelDetail);
        dispatcher.registerGetMapping("/dosingGuideline", this::dosingGuideline);
        dispatcher.registerGetMapping("/dosingGuidelineDetail", this::dosingGuidelineDetail);

        // User settings page.
        // /settings is the new official route.
        // /search is kept for backward compatibility with the old Global Search route.
        dispatcher.registerGetMapping("/settings", this::userSettings);
        dispatcher.registerGetMapping("/search", this::userSettings);
    }

    public void userSettings(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        UserAccount loginUser = (UserAccount) request.getSession().getAttribute("loginUser");

        request.setAttribute("settingsUser", loginUser);

        log.info("[User Settings] loginUser={}",
                loginUser == null ? "guest" : loginUser.getUsername());

        request.getRequestDispatcher("/views/settings.jsp").forward(request, response);
    }

    public void drugs(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String biomarker = request.getParameter("biomarker");

        log.info("[Drug Search] queryString={}, keyword={}, biomarker={}",
                request.getQueryString(), keyword, biomarker);

        List<Drug> drugs = drugDao.search(keyword, biomarker);

        log.info("[Drug Search] result size={}", drugs.size());

        request.setAttribute("drugs", drugs);
        request.setAttribute("keyword", keyword);
        request.setAttribute("biomarker", biomarker);

        request.getRequestDispatcher("/views/drugs.jsp").forward(request, response);
    }

    public void drugDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("drugs");
            return;
        }

        Drug drug = drugDao.findById(id.trim());

        if (drug == null) {
            response.sendRedirect("drugs");
            return;
        }

        request.setAttribute("drug", drug);
        request.getRequestDispatcher("/views/drug_detail.jsp").forward(request, response);
    }

    public void drugLabels(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String source = request.getParameter("source");

        log.info("[Drug Label Search] queryString={}, keyword={}, source={}",
                request.getQueryString(), keyword, source);

        List<DrugLabel> drugLabels = drugLabelDao.search(keyword, source);

        log.info("[Drug Label Search] result size={}", drugLabels.size());

        request.setAttribute("drugLabels", drugLabels);
        request.setAttribute("keyword", keyword);
        request.setAttribute("source", source);

        request.getRequestDispatcher("/views/drug_labels.jsp").forward(request, response);
    }

    public void drugLabelDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("drugLabels");
            return;
        }

        DrugLabel drugLabel = drugLabelDao.findById(id.trim());

        if (drugLabel == null) {
            response.sendRedirect("drugLabels");
            return;
        }

        request.setAttribute("drugLabel", drugLabel);
        request.getRequestDispatcher("/views/drug_label_detail.jsp").forward(request, response);
    }

    public void dosingGuideline(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String source = request.getParameter("source");
        String message = request.getParameter("message");

        log.info("[Dosing Guideline Search] queryString={}, keyword={}, source={}",
                request.getQueryString(), keyword, source);

        List<DosingGuideline> dosingGuidelines = dosingGuidelineDao.search(keyword, source);

        log.info("[Dosing Guideline Search] result size={}", dosingGuidelines.size());

        request.setAttribute("dosingGuidelines", dosingGuidelines);
        request.setAttribute("keyword", keyword);
        request.setAttribute("source", source);
        request.setAttribute("message", message);

        request.getRequestDispatcher("/views/dosing_guideline.jsp").forward(request, response);
    }

    public void dosingGuidelineDetail(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        if (!requireProfessionalForDosingDetail(request, response)) {
            return;
        }

        String id = request.getParameter("id");

        if (id == null || id.trim().isEmpty()) {
            response.sendRedirect("dosingGuideline");
            return;
        }

        DosingGuideline dosingGuideline = dosingGuidelineDao.findById(id.trim());

        if (dosingGuideline == null) {
            response.sendRedirect("dosingGuideline");
            return;
        }

        request.setAttribute("dosingGuideline", dosingGuideline);
        request.getRequestDispatcher("/views/dosing_guideline_detail.jsp").forward(request, response);
    }
}