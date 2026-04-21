package cn.edu.zju.controller;

import cn.edu.zju.bean.DosingGuideline;
import cn.edu.zju.bean.Drug;
import cn.edu.zju.bean.DrugLabel;
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

    public void register(DispatchServlet.Dispatcher dispatcher) {
        dispatcher.registerGetMapping("/drugs", this::drugs);
        dispatcher.registerGetMapping("/drugDetail", this::drugDetail);
        dispatcher.registerGetMapping("/drugLabels", this::drugLabels);
        dispatcher.registerGetMapping("/drugLabelDetail", this::drugLabelDetail);
        dispatcher.registerGetMapping("/dosingGuideline", this::dosingGuideline);
        dispatcher.registerGetMapping("/dosingGuidelineDetail", this::dosingGuidelineDetail);
    }

    public void drugs(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String biomarker = request.getParameter("biomarker");

        List<Drug> drugs = drugDao.search(keyword, biomarker);

        request.setAttribute("drugs", drugs);
        request.setAttribute("keyword", keyword);
        request.setAttribute("biomarker", biomarker);

        request.getRequestDispatcher("/views/drugs.jsp").forward(request, response);
    }

    public void drugDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

    public void drugLabels(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String source = request.getParameter("source");

        List<DrugLabel> drugLabels = drugLabelDao.search(keyword, source);

        request.setAttribute("drugLabels", drugLabels);
        request.setAttribute("keyword", keyword);
        request.setAttribute("source", source);

        request.getRequestDispatcher("/views/drug_labels.jsp").forward(request, response);
    }

    public void drugLabelDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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

    public void dosingGuideline(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String source = request.getParameter("source");

        List<DosingGuideline> dosingGuidelines = dosingGuidelineDao.search(keyword, source);

        request.setAttribute("dosingGuidelines", dosingGuidelines);
        request.setAttribute("keyword", keyword);
        request.setAttribute("source", source);

        request.getRequestDispatcher("/views/dosing_guideline.jsp").forward(request, response);
    }

    public void dosingGuidelineDetail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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