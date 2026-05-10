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
        body {
            background-color: #f6f8fb;
        }

        .page-header {
            background: #ffffff;
            border: 1px solid #e5e9f0;
            border-radius: 10px;
            padding: 16px 20px;
            margin-top: 18px;
            margin-bottom: 12px;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.03);
        }

        .page-header-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            gap: 16px;
        }

        .drug-title {
            font-size: 1.65rem;
            font-weight: 650;
            color: #212529;
            margin-bottom: 4px;
            letter-spacing: 0.1px;
            line-height: 1.3;
        }

        .drug-subtitle {
            color: #6c757d;
            font-size: 0.92rem;
            margin-bottom: 0;
            line-height: 1.45;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 8px;
            margin-top: 14px;
        }

        .summary-card {
            background: #fbfcfe;
            border: 1px solid #e7ebf0;
            border-radius: 8px;
            padding: 8px 12px;
            min-height: auto;
        }

        .summary-label {
            color: #6c757d;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 3px;
        }

        .summary-value {
            color: #212529;
            font-size: 0.9rem;
            font-weight: 600;
            line-height: 1.32;
            word-break: break-word;
        }

        .content-card {
            background: #ffffff;
            border: 1px solid #e5e9f0;
            border-radius: 10px;
            padding: 12px 18px;
            margin-bottom: 12px;
            box-shadow: 0 1px 4px rgba(0, 0, 0, 0.03);
        }

        .section-title {
            font-size: 1rem;
            font-weight: 650;
            color: #2b3035;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
        }

        .section-title::before {
            content: "";
            width: 4px;
            height: 16px;
            border-radius: 4px;
            background-color: #4f6f9f;
            display: inline-block;
            margin-right: 8px;
        }

        .description-box {
            background-color: #f8fafc;
            border: 1px solid #e8edf3;
            border-radius: 8px;
            padding: 10px 12px;
            white-space: normal;
            word-break: break-word;
            line-height: 1.55;
            color: #343a40;
            font-size: 0.92rem;
            text-align: left;
        }

        .id-grid {
            display: grid;
            grid-template-columns: repeat(4, minmax(0, 1fr));
            gap: 8px;
        }

        .id-card {
            border: 1px solid #e7ebf0;
            background: #fbfcfe;
            border-radius: 8px;
            padding: 9px 11px;
            min-height: auto;
        }

        .id-label {
            color: #6c757d;
            font-size: 0.72rem;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 4px;
        }

        .id-value {
            color: #212529;
            font-size: 0.9rem;
            font-weight: 600;
            word-break: break-word;
            line-height: 1.32;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 8px;
            border-radius: 999px;
            font-size: 0.78rem;
            font-weight: 650;
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

        .badge-na {
            color: #6c757d;
            background-color: #e9ecef;
        }

        .badge-category {
            color: #383d41;
            background-color: #e2e3e5;
        }

        .external-link {
            font-weight: 600;
        }

        @media (max-width: 1200px) {
            .summary-grid,
            .id-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 992px) {
            .page-header-top {
                flex-direction: column;
            }
        }

        @media (max-width: 576px) {
            .summary-grid,
            .id-grid {
                grid-template-columns: 1fr;
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

            <c:choose>
                <c:when test="${drug != null}">

                    <div class="page-header">
                        <div class="page-header-top">
                            <div>
                                <h2 class="drug-title">
                                    <c:out value="${drug.name}" />
                                </h2>

                                <p class="drug-subtitle">
                                    Structured drug knowledge entry for pharmacogenetic information browsing
                                    and mutation-drug matching support.
                                </p>
                            </div>

                            <div>
                                <a href="<%=request.getContextPath()%>/drugs" class="btn btn-outline-secondary btn-sm">
                                    Back to Drug List
                                </a>
                            </div>
                        </div>

                        <div class="summary-grid">

                            <div class="summary-card">
                                <div class="summary-label">Drug ID</div>
                                <div class="summary-value">
                                    <c:out value="${drug.id}" />
                                </div>
                            </div>

                            <div class="summary-card">
                                <div class="summary-label">Category</div>
                                <div class="summary-value">
                                    <c:choose>
                                        <c:when test="${drug.objCls != null && drug.objCls != ''}">
                                            <span class="status-badge badge-category">
                                                <c:out value="${drug.objCls}" />
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-na">Not available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="summary-card">
                                <div class="summary-label">Biomarker Association</div>
                                <div class="summary-value">
                                    <c:choose>
                                        <c:when test="${drug.biomarkerAssociated == true}">
                                            <span class="status-badge badge-yes">Associated</span>
                                        </c:when>
                                        <c:when test="${drug.biomarkerAssociated == false}">
                                            <span class="status-badge badge-no">Not marked</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-unknown">Unknown</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="summary-card">
                                <div class="summary-label">Platform Reference</div>
                                <div class="summary-value">
                                    <c:choose>
                                        <c:when test="${drug.drugUrl != null && drug.drugUrl != ''}">
                                            <a class="external-link"
                                               href="https://www.pharmgkb.org${drug.drugUrl}"
                                               target="_blank">
                                                Open PharmGKB
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-na">Not available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="content-card">
                        <div class="section-title">Drug Description</div>

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
                    </div>

                    <div class="content-card">
                        <div class="section-title">External Database Identifiers</div>

                        <div class="id-grid">

                            <div class="id-card">
                                <div class="id-label">PharmGKB ID</div>
                                <div class="id-value">
                                    <c:choose>
                                        <c:when test="${drug.pharmgkbId != null && drug.pharmgkbId != ''}">
                                            <c:out value="${drug.pharmgkbId}" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-na">Not available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="id-card">
                                <div class="id-label">DrugBank ID</div>
                                <div class="id-value">
                                    <c:choose>
                                        <c:when test="${drug.drugbankId != null && drug.drugbankId != ''}">
                                            <c:out value="${drug.drugbankId}" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-na">Not available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="id-card">
                                <div class="id-label">PubChem ID</div>
                                <div class="id-value">
                                    <c:choose>
                                        <c:when test="${drug.pubchemId != null && drug.pubchemId != ''}">
                                            <c:out value="${drug.pubchemId}" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-na">Not available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="id-card">
                                <div class="id-label">KEGG ID</div>
                                <div class="id-value">
                                    <c:choose>
                                        <c:when test="${drug.keggId != null && drug.keggId != ''}">
                                            <c:out value="${drug.keggId}" />
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-na">Not available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div>
                    </div>

                </c:when>

                <c:otherwise>
                    <div class="page-header">
                        <h2 class="drug-title">Drug Detail</h2>

                        <div class="alert alert-warning mb-3" role="alert">
                            Drug record was not found.
                        </div>

                        <a href="<%=request.getContextPath()%>/drugs" class="btn btn-primary btn-sm">
                            Back to Drug List
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>

</body>
</html>