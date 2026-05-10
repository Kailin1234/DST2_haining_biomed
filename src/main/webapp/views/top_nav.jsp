<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="cn.edu.zju.bean.UserAccount" %>
<%@ page isELIgnored="false" %>

<%
    UserAccount loginUser = (UserAccount) session.getAttribute("loginUser");

    String displayRole = "Visitor";
    String roleClass = "role-visitor";

    if (loginUser != null && loginUser.getRole() != null) {
        if ("professional".equalsIgnoreCase(loginUser.getRole())) {
            displayRole = "Professional user";
            roleClass = "role-professional";
        } else if ("general".equalsIgnoreCase(loginUser.getRole())) {
            displayRole = "General user";
            roleClass = "role-general";
        } else {
            displayRole = loginUser.getRole();
            roleClass = "role-general";
        }
    }
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
        display: flex;
        align-items: center;
        gap: 0.45rem;
        white-space: nowrap;
    }

    .top-auth-navbar .visitor-summary {
        color: #e5e7eb;
        font-size: 0.9rem;
        margin-right: 0.8rem;
        display: flex;
        align-items: center;
        gap: 0.45rem;
        white-space: nowrap;
    }

    .top-auth-navbar .role-badge {
        display: inline-block;
        padding: 3px 8px;
        border-radius: 999px;
        font-size: 0.78rem;
        font-weight: 600;
        line-height: 1.2;
    }

    .top-auth-navbar .role-visitor {
        color: #374151;
        background-color: #e5e7eb;
    }

    .top-auth-navbar .role-general {
        color: #1f2937;
        background-color: #dbeafe;
    }

    .top-auth-navbar .role-professional {
        color: #ffffff;
        background-color: #2563eb;
    }

    .top-auth-navbar .btn {
        margin-left: 0.4rem;
    }

    @media (max-width: 768px) {
        .top-auth-navbar .visitor-summary,
        .top-auth-navbar .user-summary {
            display: none;
        }
    }
</style>

<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0"
       href="<%=request.getContextPath()%>/">
        Precision Medicine Matching System
    </a>

    <div class="top-auth-navbar">
        <% if (loginUser == null) { %>

        <span class="visitor-summary">
            Current mode:
            <span class="role-badge <%= roleClass %>">
                <%= displayRole %>
            </span>
        </span>

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
            Signed in as:
            <strong><%= loginUser.getUsername() %></strong>
            <span class="role-badge <%= roleClass %>">
                <%= displayRole %>
            </span>
        </span>

        <a class="btn btn-sm btn-outline-light"
           href="<%=request.getContextPath()%>/logout">
            Logout
        </a>

        <% } %>
    </div>
</nav>