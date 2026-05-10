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
        body {
            background-color: #f6f8fb;
        }

        .page-subtitle {
            color: #6c757d;
            margin-bottom: 1rem;
        }

        .search-card {
            border: 1px solid #e5e9f0;
            border-radius: 12px;
            background-color: #ffffff;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.035);
        }

        .result-count {
            font-weight: 600;
            margin-bottom: 16px;
            color: #343a40;
        }

        .guideline-card {
            border: 1px solid #e5e9f0;
            border-radius: 12px;
            padding: 20px 22px;
            margin-bottom: 16px;
            background-color: #ffffff;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.035);
        }

        .guideline-title-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 12px;
        }

        .guideline-title {
            font-size: 1.18rem;
            font-weight: 650;
            color: #212529;
            line-height: 1.45;
            margin-right: 0;
        }

        .guideline-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            flex-shrink: 0;
        }

        .guideline-id-line {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 8px;
            margin-bottom: 12px;
        }

        .id-chip {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 11px;
            border-radius: 999px;
            background-color: #edf2f7;
            color: #495057;
            font-size: 0.86rem;
            font-weight: 600;
        }

        .id-chip-label {
            color: #6c757d;
            font-weight: 600;
        }

        .id-chip-value {
            color: #212529;
            font-weight: 700;
        }

        .guideline-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 8px;
            align-items: center;
        }

        .meta-badge {
            display: inline-block;
            padding: 6px 11px;
            border-radius: 999px;
            font-size: 0.84rem;
            font-weight: 600;
            background-color: #f1f3f5;
            color: #495057;
        }

        .badge-source {
            color: #004085;
            background-color: #d9ecff;
        }

        .badge-yes {
            color: #155724;
            background-color: #d4edda;
        }

        .badge-no {
            color: #856404;
            background-color: #fff3cd;
        }

        .badge-evidence {
            color: #383d41;
            background-color: #e2e3e5;
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

            .guideline-title-row {
                display: block;
            }

            .guideline-actions {
                margin-top: 14px;
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
                                   placeholder="Search by id, name, drug, or source">
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
                                <option value="canadian pharmacogenomics network for drug safety" <c:if test="${source == 'canadian pharmacogenomics network for drug safety'}">selected</c:if>>
                                    CPNDS
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

                            <div class="guideline-title-row">
                                <div class="guideline-title">
                                    <c:choose>
                                        <c:when test="${item.name != null && item.name != ''}">
                                            <c:out value="${item.name}" />
                                        </c:when>
                                        <c:otherwise>Dosing Guideline</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="guideline-actions">
                                    <a href="${dosingGuidelineDetailUrl}" class="btn btn-outline-primary btn-sm">
                                        View Detail
                                    </a>
                                </div>
                            </div>

                            <div class="guideline-id-line">
                                <span class="id-chip">
                                    <span class="id-chip-label">Guideline ID:</span>
                                    <span class="id-chip-value">
                                        <c:out value="${item.id}" />
                                    </span>
                                </span>

                                <c:if test="${item.drugId != null && item.drugId != ''}">
                                    <span class="id-chip">
                                        <span class="id-chip-label">Related drug record:</span>
                                        <span class="id-chip-value">
                                            <c:out value="${item.drugId}" />
                                        </span>
                                    </span>
                                </c:if>
                            </div>

                            <div class="guideline-meta">
                                <span class="meta-badge badge-source">
                                    Source:
                                    <c:choose>
                                        <c:when test="${item.source != null && item.source != ''}">
                                            <c:out value="${item.source}" />
                                        </c:when>
                                        <c:otherwise>Unknown</c:otherwise>
                                    </c:choose>
                                </span>

                                <c:choose>
                                    <c:when test="${item.recommendation}">
                                        <span class="meta-badge badge-yes">Recommendation</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="meta-badge badge-no">No recommendation mark</span>
                                    </c:otherwise>
                                </c:choose>

                                <c:if test="${item.conditionType != null && item.conditionType != ''}">
                                    <span class="meta-badge">
                                        <c:out value="${item.conditionType}" />
                                    </span>
                                </c:if>

                                <c:if test="${item.evidenceLevel != null && item.evidenceLevel != ''}">
                                    <span class="meta-badge badge-evidence">
                                        <c:out value="${item.evidenceLevel}" />
                                    </span>
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