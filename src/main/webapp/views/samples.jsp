<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Sample Records</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">
</head>

<body>

<jsp:include page="top_nav.jsp"/>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="samples" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <div>
                    <h2>Sample Records</h2>
                    <p class="text-muted mb-0">
                        Review uploaded samples and open previous matching results.
                    </p>
                </div>

                <div>
                    <a href="<%=request.getContextPath()%>/matchingIndex" class="btn btn-primary btn-sm">
                        Upload New File
                    </a>
                </div>
            </div>

            <c:choose>
                <c:when test="${not empty samples}">
                    <div class="table-responsive">
                        <table class="table table-striped table-bordered table-sm">
                            <thead class="thead-light">
                            <tr>
                                <th style="width: 80px;">Sample ID</th>
                                <th style="width: 180px;">Uploaded By</th>
                                <th style="width: 220px;">Uploaded At</th>
                                <th style="width: 140px;">Action</th>
                            </tr>
                            </thead>

                            <tbody>
                            <c:forEach items="${samples}" var="item">
                                <tr>
                                    <td>${item.id}</td>
                                    <td><c:out value="${item.uploadedBy}" /></td>
                                    <td>${item.createdAt}</td>
                                    <td>
                                        <a href="<%=request.getContextPath()%>/matching?sampleId=${item.id}"
                                           class="btn btn-outline-primary btn-sm">
                                            View Result
                                        </a>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="alert alert-info" role="alert">
                        No sample records are available yet.
                    </div>

                    <a href="<%=request.getContextPath()%>/matchingIndex" class="btn btn-primary">
                        Upload Your First File
                    </a>
                </c:otherwise>
            </c:choose>

        </main>
    </div>
</div>
</body>
</html>