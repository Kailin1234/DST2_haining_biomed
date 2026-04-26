<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Drug Labels</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">

    <style>
        .page-subtitle {
            color: #6c757d;
            margin-bottom: 1rem;
        }

        .search-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            background-color: #ffffff;
        }

        .label-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 18px 20px;
            margin-bottom: 16px;
            background-color: #ffffff;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
        }

        .label-header {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 8px;
        }

        .label-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-right: 12px;
            margin-bottom: 6px;
        }

        .label-id-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            background-color: #e9ecef;
            color: #495057;
            font-size: 0.9rem;
            margin-bottom: 6px;
        }

        .label-meta {
            color: #495057;
            font-size: 0.96rem;
            margin-bottom: 10px;
        }

        .label-meta strong {
            color: #343a40;
        }

        .flag-yes {
            color: #155724;
            font-weight: 600;
        }

        .flag-no {
            color: #856404;
            font-weight: 600;
        }

        .summary-box {
            color: #343a40;
            margin-bottom: 12px;
            line-height: 1.55;
            white-space: pre-wrap;
            word-break: break-word;
        }

        .label-links {
            font-size: 0.93rem;
            color: #6c757d;
            display: flex;
            flex-wrap: wrap;
            gap: 10px 18px;
            align-items: center;
        }

        .result-count {
            font-weight: 600;
            margin-bottom: 16px;
        }

        @media (max-width: 768px) {
            .form-inline {
                display: block;
            }

            .form-inline .form-group {
                display: block;
                margin-right: 0 !important;
                margin-bottom: 12px !important;
            }

            .form-inline .form-control,
            .form-inline .btn,
            .form-inline select {
                width: 100%;
            }
        }
    </style>
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
            <jsp:param name="active" value="drug_labels" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="pt-3 pb-2 mb-3 border-bottom">
                <h2>Drug Labels</h2>
                <div class="page-subtitle">
                    Browse regulatory or pharmacogenomic label records with quick search and source filtering.
                </div>
            </div>

            <div class="card search-card mb-4">
                <div class="card-body">
                    <form method="get" action="<%=request.getContextPath()%>/drugLabels" class="form-inline">

                        <div class="form-group mr-3 mb-2">
                            <label for="keyword" class="mr-2">Keyword</label>
                            <input type="text"
                                   class="form-control"
                                   id="keyword"
                                   name="keyword"
                                   value="${keyword}"
                                   placeholder="Search by id, name, or summary">
                        </div>

                        <div class="form-group mr-3 mb-2">
                            <label for="source" class="mr-2">Source</label>
                            <select class="form-control" id="source" name="source">
                                <option value="">All</option>
                                <option value="u.s. food and drug administration" <c:if test="${source == 'u.s. food and drug administration'}">selected</c:if>>
                                    U.S. Food and Drug Administration
                                </option>
                                <option value="european medicines agency" <c:if test="${source == 'european medicines agency'}">selected</c:if>>
                                    European Medicines Agency
                                </option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary mr-2 mb-2">Search</button>
                        <a href="<%=request.getContextPath()%>/drugLabels" class="btn btn-secondary mb-2">Reset</a>
                    </form>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty drugLabels}">
                    <div class="result-count">
                        Total labels shown: ${drugLabels.size()}
                    </div>

                    <c:forEach items="${drugLabels}" var="item">
                        <c:url var="drugLabelDetailUrl" value="/drugLabelDetail">
                            <c:param name="id" value="${item.id}" />
                        </c:url>

                        <div class="label-card">
                            <div class="label-header">
                                <div class="label-title">
                                    <c:out value="${item.name}" />
                                </div>
                                <span class="label-id-badge">
                                    <c:out value="${item.id}" />
                                </span>
                            </div>

                            <div class="label-meta">
                                <strong>Source:</strong>
                                <c:choose>
                                    <c:when test="${item.source != null && item.source != ''}">
                                        <c:out value="${item.source}" />
                                    </c:when>
                                    <c:otherwise>Unknown</c:otherwise>
                                </c:choose>

                                &nbsp;&nbsp;|&nbsp;&nbsp;

                                <strong>Dosing information:</strong>
                                <c:choose>
                                    <c:when test="${item.dosingInformation}">
                                        <span class="flag-yes">Yes</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="flag-no">No</span>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${item.drugId != null && item.drugId != ''}">
                                    &nbsp;&nbsp;|&nbsp;&nbsp;
                                    <strong>Related drug:</strong>
                                    <c:out value="${item.drugId}" />
                                </c:if>
                            </div>

                            <c:if test="${item.summaryMarkdown != null && item.summaryMarkdown != ''}">
                                <div class="summary-box">
                                    <c:out value="${item.summaryMarkdown}" />
                                </div>
                            </c:if>

                            <div class="label-links">
                                <span>
                                    <a href="${drugLabelDetailUrl}" class="btn btn-outline-primary btn-sm">
                                        View Detail
                                    </a>
                                </span>

                                <c:if test="${item.treatmentIndication != null && item.treatmentIndication != ''}">
                                    <span><strong>Treatment indication:</strong> Available</span>
                                </c:if>

                                <c:if test="${item.targetPopulation != null && item.targetPopulation != ''}">
                                    <span><strong>Target population:</strong> Available</span>
                                </c:if>

                                <c:if test="${item.contraindication != null && item.contraindication != ''}">
                                    <span><strong>Contraindication:</strong> Available</span>
                                </c:if>

                                <c:if test="${item.warningPrecaution != null && item.warningPrecaution != ''}">
                                    <span><strong>Warning / precaution:</strong> Available</span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-info" role="alert">
                        No drug label records matched the current search conditions.
                    </div>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>
</body>
</html>