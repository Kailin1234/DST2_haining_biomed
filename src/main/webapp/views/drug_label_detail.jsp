<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Drug Label Detail</title>

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

        .label-title {
            font-size: 1.65rem;
            font-weight: 650;
            color: #212529;
            margin-bottom: 4px;
            letter-spacing: 0.1px;
            line-height: 1.3;
        }

        .label-subtitle {
            color: #6c757d;
            font-size: 0.92rem;
            margin-bottom: 0;
            line-height: 1.45;
        }

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(5, minmax(0, 1fr));
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

        .content-box {
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

        .badge-na {
            color: #6c757d;
            background-color: #e9ecef;
        }

        .badge-source {
            color: #004085;
            background-color: #d9ecff;
        }

        .drug-link {
            font-weight: 600;
        }

        .note-box {
            background-color: #f8f9fa;
            border-left: 4px solid #adb5bd;
            padding: 9px 11px;
            border-radius: 7px;
            color: #6c757d;
            font-size: 0.86rem;
            line-height: 1.45;
        }

        .collapse-actions {
            margin-bottom: 8px;
        }

        @media (max-width: 1400px) {
            .summary-grid {
                grid-template-columns: repeat(3, minmax(0, 1fr));
            }
        }

        @media (max-width: 992px) {
            .page-header-top {
                flex-direction: column;
            }

            .summary-grid {
                grid-template-columns: repeat(2, minmax(0, 1fr));
            }
        }

        @media (max-width: 576px) {
            .summary-grid {
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
            <jsp:param name="active" value="drug_labels" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <c:choose>
                <c:when test="${drugLabel != null}">

                    <div class="page-header">
                        <div class="page-header-top">
                            <div>
                                <h2 class="label-title">
                                    <c:choose>
                                        <c:when test="${drugLabel.name != null && drugLabel.name != ''}">
                                            <c:out value="${drugLabel.name}" />
                                        </c:when>
                                        <c:otherwise>Drug Label</c:otherwise>
                                    </c:choose>
                                </h2>

                                <p class="label-subtitle">
                                    Structured drug label record for pharmacogenetic interpretation,
                                    medication safety review, and knowledge base browsing.
                                </p>
                            </div>

                            <div>
                                <a href="<%=request.getContextPath()%>/drugLabels"
                                   class="btn btn-outline-secondary btn-sm">
                                    Back to Label List
                                </a>
                            </div>
                        </div>

                        <div class="summary-grid">

                            <div class="summary-card">
                                <div class="summary-label">Label ID</div>
                                <div class="summary-value">
                                    <c:out value="${drugLabel.id}" />
                                </div>
                            </div>

                            <div class="summary-card">
                                <div class="summary-label">Related Drug Record</div>
                                <div class="summary-value">
                                    <c:choose>
                                        <c:when test="${drugLabel.drugId != null && drugLabel.drugId != ''}">
                                            <a class="drug-link"
                                               href="<%=request.getContextPath()%>/drugDetail?id=${drugLabel.drugId}">
                                                <c:out value="${drugLabel.drugId}" />
                                            </a>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-na">Not available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="summary-card">
                                <div class="summary-label">Source</div>
                                <div class="summary-value">
                                    <c:choose>
                                        <c:when test="${drugLabel.source != null && drugLabel.source != ''}">
                                            <span class="status-badge badge-source">
                                                <c:out value="${drugLabel.source}" />
                                            </span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-na">Not available</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="summary-card">
                                <div class="summary-label">Dosing Information</div>
                                <div class="summary-value">
                                    <c:choose>
                                        <c:when test="${drugLabel.dosingInformation}">
                                            <span class="status-badge badge-yes">Available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-no">Not marked</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                            <div class="summary-card">
                                <div class="summary-label">Alternative Drug</div>
                                <div class="summary-value">
                                    <c:choose>
                                        <c:when test="${drugLabel.alternateDrugAvailable}">
                                            <span class="status-badge badge-yes">Available</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge badge-no">Not marked</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                            </div>

                        </div>
                    </div>

                    <div class="content-card">
                        <div class="section-title">Label Summary</div>

                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.summaryMarkdown != null && drugLabel.summaryMarkdown != ''}">
                                    <c:out value="${drugLabel.summaryMarkdown}" />
                                </c:when>
                                <c:otherwise>No summary is currently available.</c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <div class="content-card">
                        <div class="section-title">Full Label Text</div>

                        <div class="collapse-actions">
                            <button class="btn btn-outline-primary btn-sm"
                                    type="button"
                                    data-toggle="collapse"
                                    data-target="#fullLabelText"
                                    aria-expanded="false"
                                    aria-controls="fullLabelText">
                                Show / Hide Full Label Text
                            </button>
                        </div>

                        <div class="collapse" id="fullLabelText">
                            <div class="content-box">
                                <c:choose>
                                    <c:when test="${drugLabel.textMarkdown != null && drugLabel.textMarkdown != ''}">
                                        <c:out value="${drugLabel.textMarkdown}" />
                                    </c:when>
                                    <c:otherwise>No detailed text is currently available.</c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="note-box mt-3">
                            Full label text may be long. It is collapsed by default to keep the
                            detail page readable while preserving access to the original label content.
                        </div>
                    </div>

                </c:when>

                <c:otherwise>
                    <div class="page-header">
                        <h2 class="label-title">Drug Label Detail</h2>

                        <div class="alert alert-warning mb-3" role="alert">
                            Drug label record was not found.
                        </div>

                        <a href="<%=request.getContextPath()%>/drugLabels" class="btn btn-primary btn-sm">
                            Back to Label List
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>

</body>
</html>