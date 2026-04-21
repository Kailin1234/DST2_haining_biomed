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
    <title>Matching Result</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">

    <style>
        .bd-placeholder-img {
            font-size: 1.125rem;
            text-anchor: middle;
            -webkit-user-select: none;
            -moz-user-select: none;
            -ms-user-select: none;
            user-select: none;
        }

        @media (min-width: 768px) {
            .bd-placeholder-img-lg {
                font-size: 3.5rem;
            }
        }

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
    </style>
</head>
<body>
<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="#">Precision Medicine Matching System</a>
</nav>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="matching_index" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">
            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <h2>Matching Result</h2>
            </div>

            <c:if test="${sample != null}">
                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Sample Information</h5>
                        <p class="mb-1"><strong>Sample ID:</strong> ${sample.id}</p>
                        <p class="mb-1"><strong>Uploaded at:</strong> ${sample.createdAt}</p>
                        <p class="mb-0"><strong>Uploaded by:</strong> ${sample.uploadedBy}</p>
                    </div>
                </div>
            </c:if>

            <div class="card mb-3">
                <div class="card-body">
                    <h5 class="card-title">Matched Genes</h5>

                    <c:choose>
                        <c:when test="${refGenes != null && !refGenes.isEmpty()}">
                            <p class="mb-2">
                                <strong>Total matched genes:</strong> ${refGenes.size()}
                            </p>
                            <div>
                                <c:forEach items="${refGenes}" var="gene">
                                    <span class="gene-badge">${gene}</span>
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
                        <c:when test="${matched != null && !matched.isEmpty()}">
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
                <a href="<%=request.getContextPath()%>/matchingIndex" class="btn btn-primary mr-2">Upload Another File</a>
                <a href="<%=request.getContextPath()%>/samples" class="btn btn-secondary">View All Samples</a>
            </div>
        </main>
    </div>
</div>
</body>
</html>