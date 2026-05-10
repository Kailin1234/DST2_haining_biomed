<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="cn.edu.zju.bean.UserAccount" %>

<%
    UserAccount loginUser = (UserAccount) session.getAttribute("loginUser");
    boolean isLoggedIn = loginUser != null;
%>

<nav class="col-md-2 d-none d-md-block bg-light sidebar">
    <div class="sidebar-sticky">

        <ul class="nav flex-column">
            <li class="nav-item">
                <a class='nav-link ${param.active == "dashboard" ? "active" : ""}'
                   href="<%=request.getContextPath()%>/">
                    <span data-feather="home"></span>
                    Dashboard
                </a>
            </li>
        </ul>

        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
            <span>System Support</span>
        </h6>

        <ul class="nav flex-column mb-2">
            <li class="nav-item">
                <a class='nav-link ${param.active == "settings" ? "active" : ""}'
                   href="<%=request.getContextPath()%>/settings">
                    <span data-feather="settings"></span>
                    User Settings
                </a>
            </li>

            <li class="nav-item">
                <a class='nav-link ${param.active == "help" ? "active" : ""}'
                   href="<%=request.getContextPath()%>/help">
                    <span data-feather="help-circle"></span>
                    Help / Tutorial
                </a>
            </li>
        </ul>

        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
            <span>Mutation Analysis</span>
        </h6>

        <ul class="nav flex-column">
            <li class="nav-item">
                <a class='nav-link ${param.active == "matching_index" ? "active" : ""}'
                   href="<%=request.getContextPath()%>/matchingIndex">
                    <span data-feather="file"></span>
                    Mutation-Drug Matching
                    <% if (!isLoggedIn) { %>
                    <span class="text-muted small">(login required)</span>
                    <% } %>
                </a>
            </li>

            <li class="nav-item">
                <a class='nav-link ${param.active == "samples" ? "active" : ""}'
                   href="<%=request.getContextPath()%>/samples">
                    <span data-feather="file"></span>
                    Sample Records
                    <% if (!isLoggedIn) { %>
                    <span class="text-muted small">(login required)</span>
                    <% } %>
                </a>
            </li>
        </ul>

        <h6 class="sidebar-heading d-flex justify-content-between align-items-center px-3 mt-4 mb-1 text-muted">
            <span>Knowledge Base</span>
        </h6>

        <ul class="nav flex-column">
            <li class="nav-item">
                <a class='nav-link ${param.active == "drugs" ? "active" : ""}'
                   href="<%=request.getContextPath()%>/drugs">
                    <span data-feather="file-text"></span>
                    Drugs
                </a>
            </li>

            <li class="nav-item">
                <a class='nav-link ${param.active == "drug_labels" ? "active" : ""}'
                   href="<%=request.getContextPath()%>/drugLabels">
                    <span data-feather="file-text"></span>
                    Drug Labels
                </a>
            </li>

            <li class="nav-item">
                <a class='nav-link ${param.active == "dosing_guideline" ? "active" : ""}'
                   href="<%=request.getContextPath()%>/dosingGuideline">
                    <span data-feather="file-text"></span>
                    Dosing Guideline
                </a>
            </li>
        </ul>

        <% if (!isLoggedIn) { %>
        <div class="px-3 mt-4 small text-muted">
            Visitors can browse the Knowledge Base. Mutation analysis and sample records require sign-in.
        </div>
        <% } %>

    </div>
</nav>