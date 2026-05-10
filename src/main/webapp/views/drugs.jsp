<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Drug Knowledge</title>

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

        .drug-card {
            border: 1px solid #e5e9f0;
            border-radius: 12px;
            padding: 18px 20px;
            margin-bottom: 14px;
            background-color: #ffffff;
            box-shadow: 0 2px 6px rgba(0, 0, 0, 0.035);
        }

        .drug-card-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
            flex-wrap: wrap;
        }

        .drug-title-wrap {
            min-width: 260px;
        }

        .drug-title {
            font-size: 1.25rem;
            font-weight: 650;
            margin-right: 10px;
            color: #212529;
        }

        .drug-id-badge {
            display: inline-block;
            padding: 5px 11px;
            border-radius: 999px;
            background-color: #edf2f7;
            color: #495057;
            font-size: 0.84rem;
            font-weight: 600;
            vertical-align: middle;
        }

        .drug-meta {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 12px;
            align-items: center;
        }

        .meta-badge {
            display: inline-block;
            padding: 5px 10px;
            border-radius: 999px;
            font-size: 0.84rem;
            font-weight: 600;
            background-color: #f1f3f5;
            color: #495057;
        }

        .badge-yes {
            color: #155724;
            background-color: #d4edda;
        }

        .badge-no {
            color: #856404;
            background-color: #fff3cd;
        }

        .badge-unknown {
            color: #6c757d;
            background-color: #e9ecef;
        }

        .drug-actions {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            align-items: center;
        }

        .form-inline .form-group {
            align-items: center;
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

            .drug-card-top {
                display: block;
            }

            .drug-actions {
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
            <jsp:param name="active" value="drugs" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="pt-3 pb-2 mb-3 border-bottom">
                <h2>Drug Knowledge</h2>
                <div class="page-subtitle">
                    Browse pharmacogenomic drug records with keyword search and biomarker-related filtering.
                </div>
            </div>

            <div class="card search-card mb-4">
                <div class="card-body">
                    <form method="get" action="<%=request.getContextPath()%>/drugs" class="form-inline">

                        <div class="form-group mr-3 mb-2">
                            <label for="keyword" class="mr-2">Keyword</label>
                            <input type="text"
                                   class="form-control"
                                   id="keyword"
                                   name="keyword"
                                   value="${keyword}"
                                   placeholder="Search by name, id, or category">
                        </div>

                        <div class="form-group mr-3 mb-2">
                            <label for="biomarker" class="mr-2">Biomarker-associated</label>
                            <select class="form-control" id="biomarker" name="biomarker">
                                <option value="">All</option>
                                <option value="yes" <c:if test="${biomarker == 'yes'}">selected</c:if>>Yes</option>
                                <option value="no" <c:if test="${biomarker == 'no'}">selected</c:if>>No / Unknown</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary mr-2 mb-2">Search</button>
                        <a href="<%=request.getContextPath()%>/drugs" class="btn btn-secondary mb-2">Reset</a>
                    </form>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty drugs}">
                    <div class="result-count">
                        Total drugs shown: ${drugs.size()}
                    </div>

                    <c:forEach items="${drugs}" var="item">
                        <c:url var="drugDetailUrl" value="/drugDetail">
                            <c:param name="id" value="${item.id}" />
                        </c:url>

                        <div class="drug-card">
                            <div class="drug-card-top">

                                <div class="drug-title-wrap">
                                    <div>
                                        <span class="drug-title">
                                            <c:out value="${item.name}" />
                                        </span>

                                        <span class="drug-id-badge">
                                            <c:out value="${item.id}" />
                                        </span>
                                    </div>

                                    <div class="drug-meta">
                                        <span class="meta-badge">
                                            Category:
                                            <c:choose>
                                                <c:when test="${item.objCls != null && item.objCls != ''}">
                                                    <c:out value="${item.objCls}" />
                                                </c:when>
                                                <c:otherwise>Unknown</c:otherwise>
                                            </c:choose>
                                        </span>

                                        <c:choose>
                                            <c:when test="${item.biomarkerAssociated == true}">
                                                <span class="meta-badge badge-yes">Biomarker-associated</span>
                                            </c:when>
                                            <c:when test="${item.biomarkerAssociated == false}">
                                                <span class="meta-badge badge-no">No biomarker mark</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="meta-badge badge-unknown">Biomarker unknown</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </div>

                                <div class="drug-actions">
                                    <a href="${drugDetailUrl}" class="btn btn-outline-primary btn-sm">
                                        View Detail
                                    </a>

                                    <c:if test="${item.drugUrl != null && item.drugUrl != ''}">
                                        <a href="https://www.pharmgkb.org${item.drugUrl}"
                                           target="_blank"
                                           class="btn btn-outline-secondary btn-sm">
                                            Platform
                                        </a>
                                    </c:if>
                                </div>

                            </div>
                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-info" role="alert">
                        No drug records matched the current search conditions.
                    </div>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>

</body>
</html>