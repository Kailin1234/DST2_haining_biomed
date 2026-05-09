<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>

<%
  String redirect = (String) request.getAttribute("redirect");
  if (redirect == null || redirect.trim().isEmpty()) {
    redirect = "/";
  }
%>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <meta name="viewport"
        content="width=device-width, initial-scale=1, shrink-to-fit=no">

  <title>Sign in - Precision Medicine Matching System</title>

  <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
  <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">

  <style>
    body {
      background-color: #f7f8fa;
      color: #202124;
    }

    .auth-wrapper {
      min-height: 100vh;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 2rem 1rem;
    }

    .auth-card {
      width: 100%;
      max-width: 430px;
      background-color: #ffffff;
      border: 1px solid #dfe3ea;
      border-radius: 4px;
      box-shadow: 0 2px 8px rgba(31, 41, 51, 0.06);
    }

    .auth-card-header {
      padding: 1.25rem 1.5rem;
      border-bottom: 1px solid #edf0f4;
      background-color: #fafbfc;
    }

    .auth-card-header h4 {
      font-size: 1.25rem;
      font-weight: 600;
      color: #1f2933;
      margin-bottom: 0.25rem;
    }

    .auth-card-header p {
      color: #6b7280;
      font-size: 0.9rem;
      margin-bottom: 0;
    }

    .auth-card-body {
      padding: 1.5rem;
    }

    .auth-label {
      font-weight: 500;
      color: #374151;
    }

    .auth-btn {
      background-color: #24476f;
      border-color: #24476f;
    }

    .auth-btn:hover {
      background-color: #1d3a5c;
      border-color: #1d3a5c;
    }

    .auth-link {
      color: #24476f;
      font-weight: 500;
    }

    .auth-link:hover {
      color: #1d3a5c;
      text-decoration: none;
    }

    .system-title {
      text-align: center;
      margin-bottom: 1.25rem;
      color: #1f2933;
      font-weight: 600;
    }
  </style>
</head>

<body>

<div class="auth-wrapper">
  <div>
    <h3 class="system-title">Precision Medicine Matching System</h3>

    <div class="auth-card">
      <div class="auth-card-header">
        <h4>Sign in</h4>
        <p>Access user-specific features and restricted guideline details.</p>
      </div>

      <div class="auth-card-body">

        <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger" role="alert">
          <%= request.getAttribute("error") %>
        </div>
        <% } %>

        <% if (request.getAttribute("message") != null) { %>
        <div class="alert alert-success" role="alert">
          <%= request.getAttribute("message") %>
        </div>
        <% } %>

        <form method="post" action="<%=request.getContextPath()%>/login">

          <input type="hidden" name="redirect" value="<%= redirect %>">

          <div class="form-group">
            <label class="auth-label" for="username">Username</label>
            <input type="text"
                   class="form-control"
                   id="username"
                   name="username"
                   placeholder="Enter username"
                   required>
          </div>

          <div class="form-group">
            <label class="auth-label" for="password">Password</label>
            <input type="password"
                   class="form-control"
                   id="password"
                   name="password"
                   placeholder="Enter password"
                   required>
          </div>

          <button type="submit" class="btn btn-primary auth-btn btn-block">
            Sign in
          </button>
        </form>

        <div class="text-center mt-3">
          <span class="text-muted">Do not have an account?</span>
          <a class="auth-link" href="<%=request.getContextPath()%>/register">
            Sign up
          </a>
        </div>

        <div class="text-center mt-2">
          <a class="auth-link" href="<%=request.getContextPath()%>/">
            Back to homepage
          </a>
        </div>

      </div>
    </div>
  </div>
</div>

</body>
</html>