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

        .label-card {
            border: 1px solid #e5e9f0;
            border-radius: 12px;
            padding: 20px 22px;
            margin-bottom: 16px;
            background-color: #ffffff;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.035);
        }

        .label-title-row {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            margin-bottom: 12px;
        }

        .label-title {
            font-size: 1.18rem;
            font-weight: 650;
            color: #212529;
            line-height: 1.45;
            margin-right: 0;
        }

        .label-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
            flex-shrink: 0;
        }

        .label-id-line {
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

        .label-meta {
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

            .label-title-row {
                display: block;
            }

            .label-actions {
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
                                   placeholder="Search by id, name, drug, or source">
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

                            <div class="label-title-row">
                                <div class="label-title">
                                    <c:choose>
                                        <c:when test="${item.name != null && item.name != ''}">
                                            <c:out value="${item.name}" />
                                        </c:when>
                                        <c:otherwise>Drug Label</c:otherwise>
                                    </c:choose>
                                </div>

                                <div class="label-actions">
                                    <a href="${drugLabelDetailUrl}" class="btn btn-outline-primary btn-sm">
                                        View Detail
                                    </a>
                                </div>
                            </div>

                            <div class="label-id-line">
                                <span class="id-chip">
                                    <span class="id-chip-label">Label ID:</span>
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

                            <div class="label-meta">
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
                                    <c:when test="${item.dosingInformation}">
                                        <span class="meta-badge badge-yes">Dosing information</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="meta-badge badge-no">No dosing mark</span>
                                    </c:otherwise>
                                </c:choose>

                                <c:choose>
                                    <c:when test="${item.alternateDrugAvailable}">
                                        <span class="meta-badge badge-yes">Alternative drug available</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="meta-badge badge-no">No alternative mark</span>
                                    </c:otherwise>
                                </c:choose>
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