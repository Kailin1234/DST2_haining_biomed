<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>

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
        .dashboard-card {
            min-height: 180px;
        }
        .dashboard-card .card-title {
            font-weight: 600;
        }
        .quick-action {
            margin-top: 12px;
        }
        .section-subtitle {
            color: #6c757d;
            font-size: 0.95rem;
        }
    </style>
</head>

<body>
<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="<%=request.getContextPath()%>/">
        Precision Medicine Matching System
    </a>

    <form class="form-inline w-100 justify-content-end pr-3" action="<%=request.getContextPath()%>/search" method="get">
        <input class="form-control form-control-sm mr-2"
               type="text"
               name="keyword"
               placeholder="Search drug / label / guideline"
               aria-label="Search">
        <button class="btn btn-sm btn-outline-light" type="submit">Search</button>
    </form>
</nav>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="dashboard"/>
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <div>
                    <h2>Dashboard</h2>
                    <p class="section-subtitle mb-0">
                        Start mutation-drug matching, review uploaded samples, and browse pharmacogenetic knowledge.
                    </p>
                </div>
            </div>

            <div class="jumbotron py-4">
                <h4>Welcome to Precision Medicine Matching System</h4>
                <p class="mb-0">
                    This platform supports mutation file upload, mutation-drug matching,
                    sample management, and drug knowledge browsing for precision medicine analysis.
                </p>
            </div>

            <div class="row">

                <div class="col-md-6 col-lg-3 mb-4">
                    <div class="card dashboard-card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Mutation-Drug Matching</h5>
                            <p class="card-text">
                                Upload mutation files and generate medication-related matching results.
                            </p>
                            <a class="btn btn-primary btn-sm quick-action"
                               href="<%=request.getContextPath()%>/matchingIndex">
                                Start Matching
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3 mb-4">
                    <div class="card dashboard-card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Sample Records</h5>
                            <p class="card-text">
                                Review uploaded samples and track previous analysis records.
                            </p>
                            <a class="btn btn-primary btn-sm quick-action"
                               href="<%=request.getContextPath()%>/samples">
                                View Samples
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3 mb-4">
                    <div class="card dashboard-card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Drug Knowledge Base</h5>
                            <p class="card-text">
                                Browse drugs, drug labels, and dosing guideline information.
                            </p>
                            <a class="btn btn-primary btn-sm quick-action"
                               href="<%=request.getContextPath()%>/drugs">
                                Browse Drugs
                            </a>
                        </div>
                    </div>
                </div>

                <div class="col-md-6 col-lg-3 mb-4">
                    <div class="card dashboard-card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Search & Help</h5>
                            <p class="card-text">
                                Search across knowledge modules or check the basic usage guide.
                            </p>
                            <a class="btn btn-primary btn-sm quick-action"
                               href="<%=request.getContextPath()%>/help">
                                View Help
                            </a>
                        </div>
                    </div>
                </div>

            </div>

            <div class="card mt-2 mb-4">
                <div class="card-header">
                    Suggested Workflow
                </div>
                <div class="card-body">
                    <ol class="mb-0">
                        <li>Upload a mutation file through the Matching page.</li>
                        <li>The system parses mutation information and performs drug-related matching.</li>
                        <li>Review the matching result and explanation.</li>
                        <li>Check related drug labels and dosing guidelines in the knowledge base.</li>
                    </ol>
                </div>
            </div>

        </main>
    </div>
</div>
</body>
</html>