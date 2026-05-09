<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ page import="cn.edu.zju.bean.UserAccount" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Dosing Guideline Detail</title>

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

        .guideline-id-badge {
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

        .role-guideline-notice {
            background-color: #ffffff;
            border: 1px solid #dfe3ea;
            border-radius: 4px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.25rem;
            box-shadow: 0 2px 6px rgba(31, 41, 51, 0.04);
        }

        .role-guideline-professional {
            border-left: 5px solid #24476f;
        }

        .role-guideline-general {
            border-left: 5px solid #6b7280;
        }

        .role-guideline-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1f2933;
            margin-bottom: 0.35rem;
        }

        .role-guideline-notice p {
            color: #4b5563;
            line-height: 1.65;
            margin-bottom: 0;
            font-size: 0.94rem;
        }
    </style>
</head>

<body>
<%
    UserAccount loginUser = (UserAccount) session.getAttribute("loginUser");
%>

<jsp:include page="top_nav.jsp"/>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="dosing_guideline" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="pt-3 pb-2 mb-3 border-bottom d-flex justify-content-between align-items-center">
                <h2 class="mb-0">Dosing Guideline Detail</h2>
                <a href="<%=request.getContextPath()%>/dosingGuideline" class="btn btn-secondary btn-sm">
                    Back to Guideline List
                </a>
            </div>

            <% if (loginUser != null && "professional".equalsIgnoreCase(loginUser.getRole())) { %>
            <div class="role-guideline-notice role-guideline-professional">
                <div class="role-guideline-title">Professional interpretation notice</div>
                <p>
                    You are viewing this detailed dosing guideline as a professional user. This information can
                    support structured interpretation of drug-related recommendations, but final interpretation
                    should still be combined with clinical context, evidence quality, and professional judgement.
                </p>
            </div>
            <% } else if (loginUser != null && "general".equalsIgnoreCase(loginUser.getRole())) { %>
            <div class="role-guideline-notice role-guideline-general">
                <div class="role-guideline-title">General user interpretation notice</div>
                <p>
                    You are viewing this detailed dosing guideline as a general user. The information is provided
                    for educational reference only and should not be used as direct medical advice. Please interpret
                    guideline records with support from qualified professionals.
                </p>
            </div>
            <% } %>

            <c:choose>
                <c:when test="${dosingGuideline != null}">
                    <div class="detail-card">
                        <h3 class="mb-3">
                            <c:out value="${dosingGuideline.name}" />
                            <span class="guideline-id-badge"><c:out value="${dosingGuideline.id}" /></span>
                        </h3>

                        <div class="info-row">
                            <span class="info-label">Source:</span>
                            <c:choose>
                                <c:when test="${dosingGuideline.source != null && dosingGuideline.source != ''}">
                                    <c:out value="${dosingGuideline.source}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Drug ID:</span>
                            <c:choose>
                                <c:when test="${dosingGuideline.drugId != null && dosingGuideline.drugId != ''}">
                                    <c:out value="${dosingGuideline.drugId}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Recommendation:</span>
                            <c:choose>
                                <c:when test="${dosingGuideline.recommendation}">
                                    <span class="flag-yes">Yes</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="flag-no">No</span>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Condition type:</span>
                            <c:choose>
                                <c:when test="${dosingGuideline.conditionType != null && dosingGuideline.conditionType != ''}">
                                    <c:out value="${dosingGuideline.conditionType}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Condition value:</span>
                            <c:choose>
                                <c:when test="${dosingGuideline.conditionValue != null && dosingGuideline.conditionValue != ''}">
                                    <c:out value="${dosingGuideline.conditionValue}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="info-row">
                            <span class="info-label">Evidence level:</span>
                            <c:choose>
                                <c:when test="${dosingGuideline.evidenceLevel != null && dosingGuideline.evidenceLevel != ''}">
                                    <c:out value="${dosingGuideline.evidenceLevel}" />
                                </c:when>
                                <c:otherwise>Not available</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Summary</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${dosingGuideline.summaryMarkdown != null && dosingGuideline.summaryMarkdown != ''}">
                                    <c:out value="${dosingGuideline.summaryMarkdown}" />
                                </c:when>
                                <c:otherwise>No summary is currently available.</c:otherwise>
                            </c:choose>
                        </div>

                        <div class="section-title">Full Guideline Text</div>
                        <div class="content-box">
                            <c:choose>
                                <c:when test="${dosingGuideline.textMarkdown != null && dosingGuideline.textMarkdown != ''}">
                                    <c:out value="${dosingGuideline.textMarkdown}" />
                                </c:when>
                                <c:otherwise>No detailed text is currently available.</c:otherwise>
                            </c:choose>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-warning" role="alert">
                        Dosing guideline record was not found.
                    </div>
                    <a href="<%=request.getContextPath()%>/dosingGuideline" class="btn btn-primary btn-sm">
                        Back to Guideline List
                    </a>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>
</body>
</html>