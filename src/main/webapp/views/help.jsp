<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page isELIgnored="false" %>

<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  <title>Help - Precision Medicine Matching System</title>

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
      <jsp:param name="active" value="help"/>
    </jsp:include>

    <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

      <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
        <div>
          <h2>Help / Tutorial</h2>
          <p class="text-muted mb-0">
            Basic guidance for using the precision medicine matching system.
          </p>
        </div>
      </div>

      <div class="card shadow-sm mb-4">
        <div class="card-header">
          Basic Workflow
        </div>

        <div class="card-body">
          <ol class="mb-0">
            <li>
              Open the Mutation-Drug Matching page.
            </li>
            <li>
              Upload a mutation annotation file.
            </li>
            <li>
              The system parses mutation information and performs drug-related matching.
            </li>
            <li>
              Review the result page and check matched drug explanations.
            </li>
            <li>
              Use the knowledge base to browse related drug labels and dosing guidelines.
            </li>
          </ol>
        </div>
      </div>

      <div class="card shadow-sm mb-4">
        <div class="card-header">
          Main Modules
        </div>

        <div class="card-body">
          <table class="table table-bordered table-sm mb-0">
            <thead class="thead-light">
            <tr>
              <th style="width: 30%;">Module</th>
              <th>Function</th>
            </tr>
            </thead>

            <tbody>
            <tr>
              <td>Mutation-Drug Matching</td>
              <td>
                Upload mutation files and generate drug-related matching results.
              </td>
            </tr>

            <tr>
              <td>Sample Records</td>
              <td>
                Review uploaded samples and previous analysis records.
              </td>
            </tr>

            <tr>
              <td>Drugs</td>
              <td>
                Browse basic drug information.
              </td>
            </tr>

            <tr>
              <td>Drug Labels</td>
              <td>
                Check medication label information related to pharmacogenetics.
              </td>
            </tr>

            <tr>
              <td>Dosing Guideline</td>
              <td>
                Browse dosing recommendations and guideline information.
              </td>
            </tr>

            <tr>
              <td>User Settings</td>
              <td>
                View current account information, user role, security status,
                and available system access.
              </td>
            </tr>
            </tbody>
          </table>
        </div>
      </div>

      <div class="card shadow-sm mb-4">
        <div class="card-header">
          User Access Notes
        </div>

        <div class="card-body">
          <p class="text-muted mb-2">
            Visitors can browse public knowledge base pages and help information.
          </p>

          <p class="text-muted mb-2">
            Signed-in users can access additional mutation analysis and sample record functions.
          </p>

          <p class="text-muted mb-0">
            Role-based user support can be further extended by adding different page views
            for visitors, general users and professional users.
          </p>
        </div>
      </div>

    </main>
  </div>
</div>

</body>
</html>