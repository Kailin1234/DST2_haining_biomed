<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="cn.edu.zju.bean.UserAccount" %>

<%
    UserAccount loginUser = (UserAccount) session.getAttribute("loginUser");
%>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Dashboard - Precision Medicine Matching System</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">
</head>

<body>
<jsp:include page="top_nav.jsp"/>

<div class="container-fluid">
    <div class="row">

        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="dashboard"/>
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="card shadow-sm mt-4 mb-4">
                <div class="card-body">
                    <h2 class="mb-3">Precision Medicine Matching System</h2>

                    <p class="text-muted mb-0">
                        This platform provides an integrated environment for mutation file upload,
                        mutation-drug matching, sample record management, and pharmacogenetic knowledge
                        browsing. It is designed as a structured web-based system to support interpretable
                        drug-related information retrieval from mutation data.
                    </p>
                </div>
            </div>

            <% if (loginUser == null) { %>

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h5 class="card-title">Public browsing mode</h5>

                    <p class="card-text text-muted">
                        You are not signed in. Public knowledge base pages can still be browsed,
                        including drug records, drug labels, dosing guideline lists, user settings,
                        and help information. Signing in enables mutation-drug matching, sample record
                        review, and detailed dosing guideline access.
                    </p>

                    <a class="btn btn-outline-primary btn-sm"
                       href="<%=request.getContextPath()%>/login">
                        Sign in
                    </a>

                    <a class="btn btn-outline-secondary btn-sm ml-2"
                       href="<%=request.getContextPath()%>/register">
                        Create an account
                    </a>
                </div>
            </div>

            <% } else if ("professional".equalsIgnoreCase(loginUser.getRole())) { %>

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h5 class="card-title">Professional user view</h5>

                    <p class="card-text text-muted mb-0">
                        You are using the professional-user view. This view is intended for users with
                        relevant biomedical or clinical background. Detailed drug labels and dosing
                        guideline information can be reviewed for structured interpretation support
                        together with professional judgement.
                    </p>
                </div>
            </div>

            <% } else if ("general".equalsIgnoreCase(loginUser.getRole())) { %>

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h5 class="card-title">General user view</h5>

                    <p class="card-text text-muted mb-0">
                        You are using the general-user view. Mutation-drug matching results and guideline
                        records are provided for educational reference. The information should not replace
                        medical advice and should be interpreted with support from qualified professionals.
                    </p>
                </div>
            </div>

            <% } %>

            <div class="mb-3">
                <h4>Core Functional Modules</h4>
                <p class="text-muted mb-0">
                    The system is organized into three main functional areas.
                </p>
            </div>

            <div class="row mb-4">

                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <p class="text-uppercase text-muted small mb-2">Module 01</p>

                            <h5 class="card-title">System Support</h5>

                            <p class="card-text text-muted">
                                Provides user settings and basic usage guidance to help users check
                                account status, system access, and input requirements before starting
                                the analysis.
                            </p>

                            <hr>

                            <a class="btn btn-outline-primary btn-sm mb-2"
                               href="<%=request.getContextPath()%>/settings">
                                User Settings
                            </a>

                            <a class="btn btn-outline-secondary btn-sm mb-2"
                               href="<%=request.getContextPath()%>/help">
                                Help / Tutorial
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <p class="text-uppercase text-muted small mb-2">Module 02</p>

                            <h5 class="card-title">Mutation Analysis</h5>

                            <p class="card-text text-muted">
                                Supports mutation file upload, gene-level information extraction,
                                mutation-drug matching, and review of previously uploaded sample records.
                            </p>

                            <hr>

                            <a class="btn btn-outline-primary btn-sm mb-2"
                               href="<%=request.getContextPath()%>/matchingIndex">
                                Mutation-Drug Matching
                            </a>

                            <a class="btn btn-outline-secondary btn-sm mb-2"
                               href="<%=request.getContextPath()%>/samples">
                                Sample Records
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 mb-4">
                    <div class="card shadow-sm h-100">
                        <div class="card-body">
                            <p class="text-uppercase text-muted small mb-2">Module 03</p>

                            <h5 class="card-title">Knowledge Base</h5>

                            <p class="card-text text-muted">
                                Provides structured access to drug information, pharmacogenetic drug labels,
                                dosing guideline records, biomarkers, and related reference information.
                            </p>

                            <hr>

                            <a class="btn btn-outline-primary btn-sm mb-2"
                               href="<%=request.getContextPath()%>/drugs">
                                Drugs
                            </a>

                            <a class="btn btn-outline-primary btn-sm mb-2"
                               href="<%=request.getContextPath()%>/drugLabels">
                                Drug Labels
                            </a>

                            <a class="btn btn-outline-primary btn-sm mb-2"
                               href="<%=request.getContextPath()%>/dosingGuideline">
                                Dosing Guideline
                            </a>
                        </div>
                    </div>
                </div>

            </div>

            <div class="card shadow-sm mb-4">
                <div class="card-body">
                    <h5 class="card-title">Suggested Workflow</h5>

                    <p class="text-muted">
                        A typical use process begins with system guidance and ends with knowledge base review.
                    </p>

                    <ol class="mb-0">
                        <li>
                            Check User Settings and Help / Tutorial to understand account access,
                            available records, and input requirements.
                        </li>
                        <li>
                            Upload a mutation file through the Mutation-Drug Matching page.
                        </li>
                        <li>
                            The system parses mutation information and performs drug-related matching.
                        </li>
                        <li>
                            Review related drug labels and dosing guidelines in the knowledge base.
                        </li>
                    </ol>
                </div>
            </div>

        </main>
    </div>
</div>

</body>
</html>