<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>Global Search - Precision Medicine Matching System</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">
</head>

<body>
<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="<%=request.getContextPath()%>/">
        Precision Medicine Matching System
    </a>
</nav>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="search"/>
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h2>Global Search</h2>
            </div>

            <form class="mb-4" action="<%=request.getContextPath()%>/search" method="get">
                <div class="input-group">
                    <input type="text"
                           class="form-control"
                           name="keyword"
                           value="${keyword}"
                           placeholder="Search drug, label, dosing guideline, gene, or keyword">
                    <div class="input-group-append">
                        <button class="btn btn-primary" type="submit">Search</button>
                    </div>
                </div>
            </form>

            <c:choose>
                <c:when test="${empty keyword}">
                    <div class="alert alert-info">
                        Please enter a keyword to search across Drugs, Drug Labels, and Dosing Guidelines.
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-secondary">
                        Search keyword:
                        <strong><c:out value="${keyword}"/></strong>
                    </div>

                    <c:url var="drugUrl" value="/drugs">
                        <c:param name="keyword" value="${keyword}"/>
                    </c:url>

                    <c:url var="labelUrl" value="/drugLabels">
                        <c:param name="keyword" value="${keyword}"/>
                    </c:url>

                    <c:url var="guidelineUrl" value="/dosingGuideline">
                        <c:param name="keyword" value="${keyword}"/>
                    </c:url>

                    <div class="row">

                        <div class="col-md-4 mb-4">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title">Drugs</h5>
                                    <p class="card-text">
                                        Matched records:
                                        <strong>${drugCount}</strong>
                                    </p>
                                    <a class="btn btn-sm btn-primary" href="${drugUrl}">
                                        View Drug Results
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 mb-4">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title">Drug Labels</h5>
                                    <p class="card-text">
                                        Matched records:
                                        <strong>${labelCount}</strong>
                                    </p>
                                    <a class="btn btn-sm btn-primary" href="${labelUrl}">
                                        View Label Results
                                    </a>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-4 mb-4">
                            <div class="card shadow-sm">
                                <div class="card-body">
                                    <h5 class="card-title">Dosing Guidelines</h5>
                                    <p class="card-text">
                                        Matched records:
                                        <strong>${guidelineCount}</strong>
                                    </p>
                                    <a class="btn btn-sm btn-primary" href="${guidelineUrl}">
                                        View Guideline Results
                                    </a>
                                </div>
                            </div>
                        </div>

                    </div>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>
</body>
</html>