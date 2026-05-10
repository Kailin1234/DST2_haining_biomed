<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>User Settings - Precision Medicine Matching System</title>

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
            <jsp:param name="active" value="settings"/>
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <div>
                    <h2>User Settings</h2>
                    <p class="text-muted mb-0">
                        View current account information and system access status.
                    </p>
                </div>
            </div>

            <c:choose>

                <c:when test="${empty sessionScope.loginUser}">
                    <div class="alert alert-warning">
                        You are not signed in. Please sign in to view your user settings.
                    </div>

                    <div class="card shadow-sm">
                        <div class="card-body">
                            <h5 class="card-title">Account status</h5>
                            <p class="card-text">
                                Current status:
                                <span class="badge badge-secondary">Guest user</span>
                            </p>

                            <a class="btn btn-primary btn-sm"
                               href="<%=request.getContextPath()%>/login?redirect=/settings">
                                Sign in
                            </a>

                            <a class="btn btn-outline-secondary btn-sm"
                               href="<%=request.getContextPath()%>/register">
                                Create account
                            </a>
                        </div>
                    </div>
                </c:when>

                <c:otherwise>

                    <div class="alert alert-success">
                        You are signed in as
                        <strong><c:out value="${sessionScope.loginUser.username}"/></strong>.
                    </div>

                    <div class="row">

                        <div class="col-md-6 mb-4">
                            <div class="card shadow-sm h-100">
                                <div class="card-header">
                                    Account Information
                                </div>

                                <div class="card-body">
                                    <table class="table table-sm table-borderless mb-0">
                                        <tr>
                                            <th style="width: 35%;">User ID</th>
                                            <td>
                                                <c:out value="${sessionScope.loginUser.id}"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th>Username</th>
                                            <td>
                                                <c:out value="${sessionScope.loginUser.username}"/>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th>User role</th>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${sessionScope.loginUser.role == 'professional'}">
                                                        <span class="badge badge-primary">Professional user</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <span class="badge badge-info">General user</span>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>

                                        <tr>
                                            <th>Created at</th>
                                            <td>
                                                <c:out value="${sessionScope.loginUser.createdAt}"/>
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>

                        <div class="col-md-6 mb-4">
                            <div class="card shadow-sm h-100">
                                <div class="card-header">
                                    Security Settings
                                </div>

                                <div class="card-body">
                                    <p class="mb-2">
                                        Password:
                                        <span class="badge badge-secondary">Hidden</span>
                                    </p>

                                    <p class="text-muted mb-0">
                                        For security reasons, your password is not displayed on this page.
                                        This page is currently read-only.
                                    </p>
                                </div>
                            </div>
                        </div>

                    </div>

                    <div class="card shadow-sm mb-4">
                        <div class="card-header">
                            System Access
                        </div>

                        <div class="card-body">
                            <table class="table table-bordered table-sm mb-0">
                                <thead class="thead-light">
                                <tr>
                                    <th>Function</th>
                                    <th>Current access</th>
                                    <th>Description</th>
                                </tr>
                                </thead>

                                <tbody>
                                <tr>
                                    <td>Dashboard</td>
                                    <td>
                                        <span class="badge badge-success">Available</span>
                                    </td>
                                    <td>View the system homepage and general overview.</td>
                                </tr>

                                <tr>
                                    <td>Mutation-Drug Matching</td>
                                    <td>
                                        <span class="badge badge-success">Available</span>
                                    </td>
                                    <td>Upload mutation files and run mutation-drug matching analysis.</td>
                                </tr>

                                <tr>
                                    <td>Sample Records</td>
                                    <td>
                                        <span class="badge badge-success">Available</span>
                                    </td>
                                    <td>View uploaded sample records and related matching information.</td>
                                </tr>

                                <tr>
                                    <td>Knowledge Base</td>
                                    <td>
                                        <span class="badge badge-success">Available</span>
                                    </td>
                                    <td>Browse drug, drug label and dosing guideline information.</td>
                                </tr>

                                <tr>
                                    <td>Dosing Guideline Detail</td>
                                    <td>
                                        <span class="badge badge-success">Available after sign-in</span>
                                    </td>
                                    <td>Detailed dosing guideline information requires user login.</td>
                                </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div class="card shadow-sm mb-4">
                        <div class="card-header">
                            Account Actions
                        </div>

                        <div class="card-body">
                            <a class="btn btn-outline-danger btn-sm"
                               href="<%=request.getContextPath()%>/logout">
                                Logout
                            </a>

                            <span class="text-muted ml-2">
                                Editing username, password or role can be added later if required.
                            </span>
                        </div>
                    </div>

                </c:otherwise>

            </c:choose>

        </main>
    </div>
</div>

</body>
</html>