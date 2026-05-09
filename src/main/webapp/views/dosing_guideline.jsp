<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Dosing Guidelines</title>

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

        .guideline-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 18px 20px;
            margin-bottom: 16px;
            background-color: #ffffff;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
        }

        .guideline-header {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 8px;
        }

        .guideline-title {
            font-size: 1.2rem;
            font-weight: 600;
            margin-right: 12px;
            margin-bottom: 6px;
        }

        .guideline-id-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            background-color: #e9ecef;
            color: #495057;
            font-size: 0.9rem;
            margin-bottom: 6px;
        }

        .guideline-meta {
            color: #495057;
            font-size: 0.96rem;
            margin-bottom: 10px;
        }

        .guideline-meta strong {
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

        .guideline-links {
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

<jsp:include page="top_nav.jsp"/>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="dosing_guideline" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="pt-3 pb-2 mb-3 border-bottom">
                <h2>Dosing Guidelines</h2>
                <div class="page-subtitle">
                    Browse dosing recommendations and pharmacogenomic guideline records with quick search and source filtering.
                </div>
            </div>

            <div class="card search-card mb-4">
                <div class="card-body">
                    <form method="get" action="<%=request.getContextPath()%>/dosingGuideline" class="form-inline">

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
                                <option value="clinical pharmacogenetics implementation consortium" <c:if test="${source == 'clinical pharmacogenetics implementation consortium'}">selected</c:if>>
                                    CPIC
                                </option>
                                <option value="dutch pharmacogenetics working group" <c:if test="${source == 'dutch pharmacogenetics working group'}">selected</c:if>>
                                    DPWG
                                </option>
                                <option value="u.s. food and drug administration" <c:if test="${source == 'u.s. food and drug administration'}">selected</c:if>>
                                    FDA
                                </option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary mr-2 mb-2">Search</button>
                        <a href="<%=request.getContextPath()%>/dosingGuideline" class="btn btn-secondary mb-2">Reset</a>
                    </form>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty dosingGuidelines}">
                    <div class="result-count">
                        Total guidelines shown: ${dosingGuidelines.size()}
                    </div>

                    <c:forEach items="${dosingGuidelines}" var="item">
                        <c:url var="dosingGuidelineDetailUrl" value="/dosingGuidelineDetail">
                            <c:param name="id" value="${item.id}" />
                        </c:url>

                        <div class="guideline-card">
                            <div class="guideline-header">
                                <div class="guideline-title">
                                    <c:out value="${item.name}" />
                                </div>
                                <span class="guideline-id-badge">
                                    <c:out value="${item.id}" />
                                </span>
                            </div>

                            <div class="guideline-meta">
                                <strong>Source:</strong>
                                <c:choose>
                                    <c:when test="${item.source != null && item.source != ''}">
                                        <c:out value="${item.source}" />
                                    </c:when>
                                    <c:otherwise>Unknown</c:otherwise>
                                </c:choose>

                                &nbsp;&nbsp;|&nbsp;&nbsp;

                                <strong>Recommendation:</strong>
                                <c:choose>
                                    <c:when test="${item.recommendation}">
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

                            <div class="guideline-links">
                                <span>
                                    <a href="${dosingGuidelineDetailUrl}" class="btn btn-outline-primary btn-sm">
                                        View Detail
                                    </a>
                                </span>

                                <c:if test="${item.conditionType != null && item.conditionType != ''}">
                                    <span><strong>Condition type:</strong> <c:out value="${item.conditionType}" /></span>
                                </c:if>

                                <c:if test="${item.evidenceLevel != null && item.evidenceLevel != ''}">
                                    <span><strong>Evidence level:</strong> <c:out value="${item.evidenceLevel}" /></span>
                                </c:if>
                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-info" role="alert">
                        No dosing guideline records matched the current search conditions.
                    </div>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>
</body>
</html>