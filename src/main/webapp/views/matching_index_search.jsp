<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>
<%@ page import="cn.edu.zju.bean.UserAccount" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Matching Result</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">

    <style>
        .gene-badge {
            display: inline-block;
            margin: 0 6px 6px 0;
            padding: 6px 10px;
            background-color: #e9ecef;
            border-radius: 12px;
            font-size: 0.9rem;
        }

        .summary-cell {
            white-space: pre-wrap;
            word-break: break-word;
            max-width: 500px;
        }

        .role-result-notice {
            background-color: #ffffff;
            border: 1px solid #dfe3ea;
            border-radius: 4px;
            padding: 1rem 1.25rem;
            margin-bottom: 1.25rem;
            box-shadow: 0 2px 6px rgba(31, 41, 51, 0.04);
        }

        .role-result-professional {
            border-left: 5px solid #24476f;
        }

        .role-result-general {
            border-left: 5px solid #6b7280;
        }

        .role-result-title {
            font-size: 0.95rem;
            font-weight: 600;
            color: #1f2933;
            margin-bottom: 0.35rem;
        }

        .role-result-notice p {
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
            <jsp:param name="active" value="matching_index" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <div>
                    <h2>Matching Result</h2>
                    <p class="text-muted mb-0">
                        Review extracted genes and matched drug label records.
                    </p>
                </div>
            </div>

            <% if (loginUser != null && "professional".equalsIgnoreCase(loginUser.getRole())) { %>
            <div class="role-result-notice role-result-professional">
                <div class="role-result-title">Professional result interpretation notice</div>
                <p>
                    You are reviewing this matching result as a professional user. The matched drug labels can support
                    structured review of mutation-related drug information, but the result should be interpreted together
                    with clinical context, evidence quality, external guideline sources, and professional judgement.
                </p>
            </div>
            <% } else if (loginUser != null && "general".equalsIgnoreCase(loginUser.getRole())) { %>
            <div class="role-result-notice role-result-general">
                <div class="role-result-title">General user result interpretation notice</div>
                <p>
                    You are reviewing this matching result as a general user. The matched drug labels are provided for
                    educational reference only and should not be interpreted as direct treatment advice. Please discuss
                    any medical interpretation with qualified professionals.
                </p>
            </div>
            <% } %>

            <c:if test="${sample != null}">
                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Sample Information</h5>
                        <p class="mb-1"><strong>Sample ID:</strong> ${sample.id}</p>
                        <p class="mb-1"><strong>Uploaded at:</strong> ${sample.createdAt}</p>
                        <p class="mb-0"><strong>Uploaded by:</strong> <c:out value="${sample.uploadedBy}" /></p>
                    </div>
                </div>
            </c:if>

            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title">Extracted Genes Used for Matching</h5>

                    <c:choose>
                        <c:when test="${not empty refGenes}">
                            <p class="mb-2">
                                <strong>Total extracted genes:</strong> ${refGenes.size()}
                            </p>
                            <div>
                                <c:forEach items="${refGenes}" var="gene">
                                    <span class="gene-badge"><c:out value="${gene}" /></span>
                                </c:forEach>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="alert alert-warning mb-0" role="alert">
                                No valid genes were extracted from this sample for matching.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Matched Drug Labels</h5>

                    <c:choose>
                        <c:when test="${not empty matched}">
                            <p class="mb-3">
                                <strong>Total matched drug labels:</strong> ${matched.size()}
                            </p>

                            <div class="table-responsive">
                                <table class="table table-striped table-bordered table-sm">
                                    <thead class="thead-light">
                                    <tr>
                                        <th style="width: 60px;">#</th>
                                        <th style="width: 180px;">Name</th>
                                        <th style="width: 140px;">Source</th>
                                        <th>Summary</th>
                                    </tr>
                                    </thead>

                                    <tbody>
                                    <c:forEach items="${matched}" var="item" varStatus="loop">
                                        <tr>
                                            <td>${loop.index + 1}</td>
                                            <td><c:out value="${item.name}" /></td>
                                            <td><c:out value="${item.source}" /></td>
                                            <td class="summary-cell"><c:out value="${item.summaryMarkdown}" /></td>
                                        </tr>
                                    </c:forEach>
                                    </tbody>
                                </table>
                            </div>
                        </c:when>

                        <c:otherwise>
                            <div class="alert alert-warning mb-0" role="alert">
                                No drug labels were matched for this sample.
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <div class="mb-4">
                <a href="<%=request.getContextPath()%>/matchingIndex" class="btn btn-primary mr-2">
                    Upload Another File
                </a>
                <a href="<%=request.getContextPath()%>/samples" class="btn btn-secondary">
                    View All Samples
                </a>
            </div>

        </main>
    </div>
</div>
</body>
</html>