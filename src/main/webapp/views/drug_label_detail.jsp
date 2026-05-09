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
        .detail-card {
            border: 1px solid #dee2e6;
            border-radius: 10px;
            background-color: #ffffff;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 1px 2px rgba(0,0,0,0.04);
        }

        .label-id-badge {
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
            margin-top: 20px;
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

        .content-box {
            white-space: pre-wrap;
            word-break: break-word;
            line-height: 1.6;
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

            <div class="pt-3 pb-2 mb-3 border-bottom d-flex justify-content-between align-items-center">
                <h2 class="mb-0">Drug Label Detail</h2>
                <a href="<%=request.getContextPath()%>/drugLabels" class="btn btn-secondary btn-sm">
                    Back to Label List
                </a>
            </div>

            <c:choose>
                <c:when test="${drugLabel != null}">
                    <div class="detail-card">
                        <h3 class="mb-3">
                            <c:choose>
                                <c:when test="${drugLabel.name != null && drugLabel.name != ''}">
                                    <c:out value="${drugLabel.name}" />
                                </c:when>
                                <c:otherwise>Drug Label</c:otherwise>
                            </c:choose>
                            <span class="label-id-badge"><c:out value="${drugLabel.id}" /></span>
                        </h3>

                        <div class="info-row">
                            <span class="info-label">Source:</span>
                            <c:choose>
                                <c:when test="${drugLabel.source != null && drugLabel.source != ''}">
                                    <c:out value="${drugLabel.source}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Drug ID:</span>
                            <c:choose>
                                <c:when test="${drugLabel.drugId != null && drugLabel.drugId != ''}">
                                    <c:out value="${drugLabel.drugId}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Dosing information:</span>
                            <c:choose>
                                <c:when test="${drugLabel.dosingInformation}">
                                    <span class="flag-yes">Yes</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="flag-no">No</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Alternate drug available:</span>
                            <c:choose>
                                <c:when test="${drugLabel.alternateDrugAvailable}">
                                    <span class="flag-yes">Yes</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="flag-no">No</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Summary</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.summaryMarkdown != null && drugLabel.summaryMarkdown != ''}">
                                    <c:out value="${drugLabel.summaryMarkdown}" />
                                </c:when>
                                <c:otherwise>No summary is currently available.</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Prescribing Information</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.prescribingMarkdown != null && drugLabel.prescribingMarkdown != ''}">
                                    <c:out value="${drugLabel.prescribingMarkdown}" />
                                </c:when>
                                <c:otherwise>No prescribing information is currently available.</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Full Label Text</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.textMarkdown != null && drugLabel.textMarkdown != ''}">
                                    <c:out value="${drugLabel.textMarkdown}" />
                                </c:when>
                                <c:otherwise>No detailed text is currently available.</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Treatment Indication</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.treatmentIndication != null && drugLabel.treatmentIndication != ''}">
                                    <c:out value="${drugLabel.treatmentIndication}" />
                                </c:when>
                                <c:otherwise>Not available.</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Target Population</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.targetPopulation != null && drugLabel.targetPopulation != ''}">
                                    <c:out value="${drugLabel.targetPopulation}" />
                                </c:when>
                                <c:otherwise>Not available.</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Adverse Reaction</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.adverseReaction != null && drugLabel.adverseReaction != ''}">
                                    <c:out value="${drugLabel.adverseReaction}" />
                                </c:when>
                                <c:otherwise>Not available.</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Contraindication</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.contraindication != null && drugLabel.contraindication != ''}">
                                    <c:out value="${drugLabel.contraindication}" />
                                </c:when>
                                <c:otherwise>Not available.</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Warning / Precaution</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${drugLabel.warningPrecaution != null && drugLabel.warningPrecaution != ''}">
                                    <c:out value="${drugLabel.warningPrecaution}" />
                                </c:when>
                                <c:otherwise>Not available.</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-warning" role="alert">
                        Drug label record was not found.
                    </div>
                    <a href="<%=request.getContextPath()%>/drugLabels" class="btn btn-primary btn-sm">
                        Back to Label List
                    </a>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>
</body>
</html>