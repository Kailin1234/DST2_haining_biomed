<%--
  Created by IntelliJ IDEA.
  User: hello
  Date: 2019-12-3
  Time: 15:37
  To change this template use File | Settings | File Templates.
--%>
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
        .page-subtitle {
            color: #6c757d;
            margin-bottom: 1rem;
        }

        .search-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            background-color: #ffffff;
        }

        .drug-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            padding: 18px 20px;
            margin-bottom: 16px;
            background-color: #ffffff;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
        }

        .drug-header {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            margin-bottom: 8px;
        }

        .drug-title {
            font-size: 1.35rem;
            font-weight: 600;
            margin-right: 12px;
            margin-bottom: 6px;
        }

        .drug-id-badge {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 999px;
            background-color: #e9ecef;
            color: #495057;
            font-size: 0.9rem;
            margin-bottom: 6px;
        }

        .drug-meta {
            color: #495057;
            font-size: 0.96rem;
            margin-bottom: 8px;
        }

        .drug-meta strong {
            color: #343a40;
        }

        .biomarker-yes {
            color: #155724;
            font-weight: 600;
        }

        .biomarker-no {
            color: #856404;
            font-weight: 600;
        }

        .biomarker-unknown {
            color: #6c757d;
            font-weight: 600;
        }

        .drug-description {
            color: #343a40;
            margin-bottom: 12px;
            line-height: 1.55;
            white-space: pre-wrap;
            word-break: break-word;
        }

        .drug-links {
            font-size: 0.93rem;
            color: #6c757d;
            display: flex;
            flex-wrap: wrap;
            gap: 10px 18px;
            align-items: center;
        }

        .drug-links span {
            display: inline-block;
        }

        .drug-links strong {
            color: #495057;
        }

        .result-count {
            font-weight: 600;
            margin-bottom: 16px;
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
        }
    </style>
</head>
<body>
<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">Precision Medicine Matching System</a>
</nav>

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
                <c:when test="${drugs != null && !drugs.isEmpty()}">
                    <div class="result-count">
                        Total drugs shown: ${drugs.size()}
                    </div>

                    <c:forEach items="${drugs}" var="item">
                        <div class="drug-card">
                            <div class="drug-header">
                                <div class="drug-title">
                                    <c:out value="${item.name}" />
                                </div>
                                <span class="drug-id-badge">
                                    <c:out value="${item.id}" />
                                </span>
                            </div>

                            <div class="drug-meta">
                                <strong>Category:</strong>
                                <c:choose>
                                    <c:when test="${item.objCls != null && item.objCls != ''}">
                                        <c:out value="${item.objCls}" />
                                    </c:when>
                                    <c:otherwise>
                                        Unknown
                                    </c:otherwise>
                                </c:choose>

                                &nbsp;&nbsp;|&nbsp;&nbsp;

                                <strong>Biomarker-associated:</strong>
                                <c:choose>
                                    <c:when test="${item.biomarkerAssociated == true}">
                                        <span class="biomarker-yes">Yes</span>
                                    </c:when>
                                    <c:when test="${item.biomarkerAssociated == false}">
                                        <span class="biomarker-no">No</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="biomarker-unknown">Unknown</span>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <c:if test="${item.description != null && item.description != ''}">
                                <div class="drug-description">
                                    <c:out value="${item.description}" />
                                </div>
                            </c:if>

                            <div class="drug-links">
                                <span>
                                    <a href="<%=request.getContextPath()%>/drugDetail?id=${item.id}" class="btn btn-outline-primary btn-sm">
                                        View Detail
                                    </a>
                                </span>

                                <c:if test="${item.drugUrl != null && item.drugUrl != ''}">
                                    <span>
                                        <strong>Platform:</strong>
                                        <a href="https://www.pharmgkb.org${item.drugUrl}" target="_blank">Open</a>
                                    </span>
                                </c:if>

                                <c:if test="${item.pharmgkbId != null && item.pharmgkbId != ''}">
                                    <span>
                                        <strong>PharmGKB:</strong>
                                        <c:out value="${item.pharmgkbId}" />
                                    </span>
                                </c:if>

                                <c:if test="${item.drugbankId != null && item.drugbankId != ''}">
                                    <span>
                                        <strong>DrugBank:</strong>
                                        <c:out value="${item.drugbankId}" />
                                    </span>
                                </c:if>

                                <c:if test="${item.pubchemId != null && item.pubchemId != ''}">
                                    <span>
                                        <strong>PubChem:</strong>
                                        <c:out value="${item.pubchemId}" />
                                    </span>
                                </c:if>

                                <c:if test="${item.keggId != null && item.keggId != ''}">
                                    <span>
                                        <strong>KEGG:</strong>
                                        <c:out value="${item.keggId}" />
                                    </span>
                                </c:if>
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