<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.edu.zju.bean.UserAccount" %>
<%@ page isELIgnored="false" %>

<%
    UserAccount loginUser = (UserAccount) session.getAttribute("loginUser");
%>

<style>
    .top-auth-navbar {
        color: #ffffff;
        display: flex;
        align-items: center;
        justify-content: flex-end;
        width: 100%;
        padding-right: 1rem;
    }

    .top-auth-navbar .user-summary {
        color: #e5e7eb;
        font-size: 0.9rem;
        margin-right: 0.8rem;
    }

    .top-auth-navbar .user-role {
        color: #cbd5e1;
        font-size: 0.82rem;
        margin-left: 0.35rem;
    }

    .top-auth-navbar .btn {
        margin-left: 0.4rem;
    }
</style>

<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0"
       href="<%=request.getContextPath()%>/">
        Precision Medicine Matching System
    </a>

    <div class="top-auth-navbar">
        <% if (loginUser == null) { %>
        <a class="btn btn-sm btn-outline-light"
           href="<%=request.getContextPath()%>/login">
            Sign in
        </a>

        <a class="btn btn-sm btn-light"
           href="<%=request.getContextPath()%>/register">
            Sign up
        </a>
        <% } else { %>
        <span class="user-summary">
                <%= loginUser.getUsername() %>
                <span class="user-role">
                    (<%= "professional".equals(loginUser.getRole()) ? "Professional user" : "General user" %>)
                </span>
            </span>

        <a class="btn btn-sm btn-outline-light"
           href="<%=request.getContextPath()%>/logout">
            Logout
        </a>
        <% } %>
    </div>
</nav>