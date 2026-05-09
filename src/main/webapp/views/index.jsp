<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ page import="cn.edu.zju.bean.UserAccount" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Dashboard - Precision Medicine Matching System</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">

    <style>
        body {
            background-color: #f7f8fa;
            color: #202124;
        }

        .academic-page {
            padding-top: 2.2rem;
            padding-bottom: 2rem;
        }

        .academic-welcome {
            background-color: #ffffff;
            border: 1px solid #d9dee7;
            border-left: 5px solid #24476f;
            border-radius: 4px;
            padding: 1.5rem 1.75rem;
            margin-bottom: 1.5rem;
        }

        .academic-welcome h3 {
            font-size: 1.45rem;
            font-weight: 600;
            color: #1f2933;
            margin-bottom: 0.75rem;
        }

        .academic-welcome p {
            color: #4b5563;
            line-height: 1.7;
            margin-bottom: 0;
            max-width: 1100px;
        }

        .role-notice {
            background-color: #ffffff;
            border: 1px solid #dfe3ea;
            border-radius: 4px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.5rem;
            box-shadow: 0 2px 6px rgba(31, 41, 51, 0.04);
        }

        .role-notice-professional {
            border-left: 5px solid #24476f;
        }

        .role-notice-general {
            border-left: 5px solid #6b7280;
        }

        .role-notice-guest {
            border-left: 5px solid #9ca3af;
        }

        .role-notice-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1f2933;
            margin-bottom: 0.35rem;
        }

        .role-notice p {
            color: #4b5563;
            line-height: 1.65;
            margin-bottom: 0;
            font-size: 0.94rem;
        }

        .role-notice-actions {
            margin-top: 0.75rem;
        }

        .role-notice-actions .academic-btn {
            margin-bottom: 0;
        }

        .section-heading {
            margin-top: 0.5rem;
            margin-bottom: 1rem;
        }

        .section-heading h4 {
            font-size: 1.15rem;
            font-weight: 600;
            color: #1f2933;
            margin-bottom: 0.25rem;
        }

        .section-heading p {
            color: #6b7280;
            font-size: 0.92rem;
            margin-bottom: 0;
        }

        .academic-card {
            height: 100%;
            min-height: 245px;
            background-color: #ffffff;
            border: 1px solid #dfe3ea;
            border-radius: 4px;
            box-shadow: 0 2px 6px rgba(31, 41, 51, 0.04);
        }

        .academic-card .card-body {
            padding: 1.35rem 1.45rem;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .module-index {
            font-size: 0.76rem;
            font-weight: 600;
            color: #24476f;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 0.65rem;
        }

        .academic-card .card-title {
            font-size: 1.16rem;
            font-weight: 600;
            color: #1f2933;
            margin-bottom: 0.75rem;
        }

        .academic-card .card-text {
            color: #4b5563;
            line-height: 1.65;
            margin-bottom: 1.1rem;
            flex-grow: 1;
        }

        .academic-actions {
            margin-top: auto;
            padding-top: 0.75rem;
            border-top: 1px solid #edf0f4;
        }

        .support-actions .academic-btn {
            display: block;
            width: fit-content;
            margin-bottom: 0.55rem;
        }

        .academic-btn {
            display: inline-block;
            font-size: 0.86rem;
            font-weight: 500;
            color: #24476f;
            background-color: #ffffff;
            border: 1px solid #24476f;
            border-radius: 3px;
            padding: 0.36rem 0.72rem;
            margin-right: 0.45rem;
            margin-bottom: 0.45rem;
            text-decoration: none;
        }

        .academic-btn:hover {
            color: #ffffff;
            background-color: #24476f;
            text-decoration: none;
        }

        .workflow-panel {
            background-color: #ffffff;
            border: 1px solid #dfe3ea;
            border-radius: 4px;
            margin-top: 0.5rem;
            margin-bottom: 2rem;
            box-shadow: 0 2px 6px rgba(31, 41, 51, 0.04);
        }

        .workflow-header {
            padding: 1rem 1.35rem;
            border-bottom: 1px solid #edf0f4;
            background-color: #fafbfc;
        }

        .workflow-header h5 {
            font-size: 1.08rem;
            font-weight: 600;
            color: #1f2933;
            margin-bottom: 0.25rem;
        }

        .workflow-header p {
            color: #6b7280;
            font-size: 0.9rem;
            margin-bottom: 0;
        }

        .workflow-body {
            padding: 1.15rem 1.35rem;
        }

        .workflow-list {
            list-style: none;
            padding-left: 0;
            margin-bottom: 0;
        }

        .workflow-list li {
            display: flex;
            align-items: flex-start;
            padding: 0.65rem 0;
            border-bottom: 1px solid #edf0f4;
            color: #374151;
            font-size: 0.98rem;
            line-height: 1.65;
        }

        .workflow-list li:first-child {
            padding-top: 0;
        }

        .workflow-list li:last-child {
            border-bottom: none;
            padding-bottom: 0;
        }

        .workflow-number {
            min-width: 26px;
            height: 26px;
            border: 1px solid #24476f;
            color: #24476f;
            background-color: #ffffff;
            font-weight: 600;
            font-size: 0.82rem;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            margin-right: 0.85rem;
            margin-top: 0.1rem;
        }
    </style>
</head>

<body>
<%
    UserAccount loginUser = (UserAccount) session.getAttribute("loginUser");
%>

<jsp:include page="top_nav.jsp"/>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="dashboard"/>
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4 academic-page">

            <div class="academic-welcome">
                <h3>Precision Medicine Matching System</h3>
                <p>
                    This platform provides an integrated environment for mutation file upload,
                    mutation-drug matching, sample record management, and pharmacogenetic knowledge browsing.
                    It is designed as a structured web-based system to support interpretable drug-related
                    information retrieval from mutation data.
                </p>
            </div>

            <% if (loginUser == null) { %>
            <div class="role-notice role-notice-guest">
                <div class="role-notice-title">Public browsing mode</div>
                <p>
                    You are not signed in. Public knowledge base pages can still be browsed, including drug records,
                    drug labels, dosing guideline lists, global search, and help information. Signing in enables
                    mutation-drug matching, sample record review, and detailed dosing guideline access.
                </p>

                <div class="role-notice-actions">
                    <a class="academic-btn" href="<%=request.getContextPath()%>/login">
                        Sign in
                    </a>
                    <a class="academic-btn" href="<%=request.getContextPath()%>/register">
                        Create an account
                    </a>
                </div>
            </div>

            <% } else if ("professional".equalsIgnoreCase(loginUser.getRole())) { %>
            <div class="role-notice role-notice-professional">
                <div class="role-notice-title">Professional user view</div>
                <p>
                    You are using the professional-user view. This view is intended for users with relevant biomedical
                    or clinical background. Detailed drug labels and dosing guideline information can be reviewed
                    for structured interpretation support together with professional judgement.
                </p>
            </div>

            <% } else if ("general".equalsIgnoreCase(loginUser.getRole())) { %>
            <div class="role-notice role-notice-general">
                <div class="role-notice-title">General user view</div>
                <p>
                    You are using the general-user view. Mutation-drug matching results and guideline records are
                    provided for educational reference. The information should not replace medical advice and should
                    be interpreted with support from qualified professionals.
                </p>
            </div>
            <% } %>

            <div class="section-heading">
                <h4>Core Functional Modules</h4>
                <p>
                    The system is organized into three main functional areas.
                </p>
            </div>

            <div class="row">

                <div class="col-md-12 col-lg-4 mb-4">
                    <div class="card academic-card">
                        <div class="card-body">
                            <div class="module-index">Module 01</div>
                            <h5 class="card-title">System Support</h5>

                            <p class="card-text">
                                Provides global search and basic usage guidance to help users locate
                                records and understand input requirements before starting the analysis.
                            </p>

                            <div class="academic-actions support-actions">
                                <a class="academic-btn" href="<%=request.getContextPath()%>/search">
                                    Global Search
                                </a>
                                <a class="academic-btn" href="<%=request.getContextPath()%>/help">
                                    Help / Tutorial
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-12 col-lg-4 mb-4">
                    <div class="card academic-card">
                        <div class="card-body">
                            <div class="module-index">Module 02</div>
                            <h5 class="card-title">Mutation Analysis</h5>

                            <p class="card-text">
                                Supports mutation file upload, gene-level information extraction,
                                mutation-drug matching, and review of previously uploaded sample records.
                            </p>

                            <div class="academic-actions">
                                <a class="academic-btn" href="<%=request.getContextPath()%>/matchingIndex">
                                    Mutation-Drug Matching
                                </a>
                                <a class="academic-btn" href="<%=request.getContextPath()%>/samples">
                                    Sample Records
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="col-md-12 col-lg-4 mb-4">
                    <div class="card academic-card">
                        <div class="card-body">
                            <div class="module-index">Module 03</div>
                            <h5 class="card-title">Knowledge Base</h5>

                            <p class="card-text">
                                Provides structured access to drug information, pharmacogenetic drug labels,
                                dosing guideline records, biomarkers, and related reference information.
                            </p>

                            <div class="academic-actions">
                                <a class="academic-btn" href="<%=request.getContextPath()%>/drugs">
                                    Drugs
                                </a>
                                <a class="academic-btn" href="<%=request.getContextPath()%>/drugLabels">
                                    Drug Labels
                                </a>
                                <a class="academic-btn" href="<%=request.getContextPath()%>/dosingGuideline">
                                    Dosing Guideline
                                </a>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

            <div class="workflow-panel">
                <div class="workflow-header">
                    <h5>Suggested Workflow</h5>
                    <p>
                        A typical use process begins with system guidance and ends with knowledge base review.
                    </p>
                </div>

                <div class="workflow-body">
                    <ul class="workflow-list">
                        <li>
                            <span class="workflow-number">1</span>
                            <span>
                                Use Global Search or Help / Tutorial to understand available records
                                and input requirements.
                            </span>
                        </li>

                        <li>
                            <span class="workflow-number">2</span>
                            <span>
                                Upload a mutation file through the Mutation-Drug Matching page.
                            </span>
                        </li>

                        <li>
                            <span class="workflow-number">3</span>
                            <span>
                                The system parses mutation information and performs drug-related matching.
                            </span>
                        </li>

                        <li>
                            <span class="workflow-number">4</span>
                            <span>
                                Review related drug labels and dosing guidelines in the knowledge base.
                            </span>
                        </li>
                    </ul>
                </div>
            </div>

        </main>
    </div>
</div>
</body>
</html>