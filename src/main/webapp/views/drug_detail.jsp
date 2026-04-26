<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Drug Detail</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">

    <style>
        .detail-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            background-color: #ffffff;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.04);
        }

        .drug-id-badge {
            display: inline-block;
            padding: 5px 12px;
            border-radius: 999px;
            background-color: #e9ecef;
            color: #495057;
            font-size: 0.95rem;
            margin-left: 10px;
        }

        .section-title {
            font-size: 1.05rem;
            font-weight: 600;
            margin-top: 18px;
            margin-bottom: 10px;
            color: #343a40;
        }

        .info-row {
            margin-bottom: 8px;
        }

        .info-label {
            font-weight: 600;
            color: #495057;
        }

        .description-box {
            white-space: pre-wrap;
            word-break: break-word;
            line-height: 1.6;
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
            <jsp:param name="active" value="drugs" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="pt-3 pb-2 mb-3 border-bottom d-flex justify-content-between align-items-center">
                <h2 class="mb-0">Drug Detail</h2>
                <a href="<%=request.getContextPath()%>/drugs" class="btn btn-secondary btn-sm">
                    Back to Drug List
                </a>
            </div>

            <c:choose>
                <c:when test="${drug != null}">
                    <div class="detail-card">
                        <h3 class="mb-3">
                            <c:out value="${drug.name}" />
                            <span class="drug-id-badge"><c:out value="${drug.id}" /></span>
                        </h3>

                        <div class="info-row">
                            <span class="info-label">Category:</span>
                            <c:choose>
                                <c:when test="${drug.objCls != null && drug.objCls != ''}">
                                    <c:out value="${drug.objCls}" />
                                </c:when>
                                <c:otherwise>Unknown</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Biomarker-associated:</span>
                            <c:choose>
                                <c:when test="${drug.biomarkerAssociated == true}">
                                    <span class="biomarker-yes">Yes</span>
                                </c:when>
                                <c:when test="${drug.biomarkerAssociated == false}">
                                    <span class="biomarker-no">No</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="biomarker-unknown">Unknown</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Description</div>
                        <div class="description-box">
                            <c:choose>
                                <c:when test="${drug.description != null && drug.description != ''}">
                                    <c:out value="${drug.description}" />
                                </c:when>
                                <c:otherwise>
                                    No description is currently available for this drug.
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Platform Reference</div>
                        <div class="info-row">
                            <span class="info-label">Platform URL:</span>
                            <c:choose>
                                <c:when test="${drug.drugUrl != null && drug.drugUrl != ''}">
                                    <a href="https://www.pharmgkb.org${drug.drugUrl}" target="_blank">
                                        Open PharmGKB Page
                                    </a>
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">External Database IDs</div>

                        <div class="info-row">
                            <span class="info-label">PharmGKB ID:</span>
                            <c:choose>
                                <c:when test="${drug.pharmgkbId != null && drug.pharmgkbId != ''}">
                                    <c:out value="${drug.pharmgkbId}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">DrugBank ID:</span>
                            <c:choose>
                                <c:when test="${drug.drugbankId != null && drug.drugbankId != ''}">
                                    <c:out value="${drug.drugbankId}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">PubChem ID:</span>
                            <c:choose>
                                <c:when test="${drug.pubchemId != null && drug.pubchemId != ''}">
                                    <c:out value="${drug.pubchemId}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">KEGG ID:</span>
                            <c:choose>
                                <c:when test="${drug.keggId != null && drug.keggId != ''}">
                                    <c:out value="${drug.keggId}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-warning" role="alert">
                        Drug record was not found.
                    </div>
                    <a href="<%=request.getContextPath()%>/drugs" class="btn btn-primary btn-sm">
                        Back to Drug List
                    </a>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>
</body>
</html>