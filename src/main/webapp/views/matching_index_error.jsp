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
    <title>Mutation-Drug Matching Error</title>

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

        pre {
            white-space: pre-wrap;
            word-break: break-word;
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
                <h2>Mutation-Drug Matching</h2>
            </div>

            <div class="table-responsive">
                <div class="alert alert-danger" role="alert">
                    <h4 class="alert-heading">Upload Validation Failed</h4>
                    <p class="mb-2">
                        The uploaded file could not be processed for mutation-drug matching.
                    </p>

                    <c:if test="${validateError != null}">
                        <hr>
                        <p class="mb-1"><strong>Error details:</strong></p>
                        <div><c:out value="${validateError}"></c:out></div>
                    </c:if>
                </div>

                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Possible Reasons</h5>
                        <ul class="mb-0">
                            <li>The uploaded file format is not supported.</li>
                            <li>The file does not contain the required mutation and annotation fields.</li>
                            <li>The header names are missing, incomplete, or inconsistent.</li>
                            <li>The uploaded VCF file does not contain usable gene annotation in the INFO column.</li>
                            <li>The uploaded file is empty or contains invalid data rows.</li>
                        </ul>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Supported File Formats</h5>
                        <p class="mb-2">
                            The system currently accepts the following input formats:
                        </p>
                        <ul class="mb-0">
                            <li>Annotated table files: CSV / TXT / TSV</li>
                            <li>Annotated VCF files</li>
                        </ul>
                        <p class="text-muted mt-2 mb-0">
                            Note: raw VCF files without gene-level annotation may not be matched successfully.
                        </p>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Required File Structure</h5>

                        <h6>1. Table-based files (CSV / TXT / TSV)</h6>
                        <p class="mb-1">
                            Your file should contain a header row and include the following fields:
                        </p>
                        <ul>
                            <li><strong>Required core fields:</strong> Chr, Start, End, Ref, Alt</li>
                            <li><strong>Required annotation fields:</strong> Gene / Gene.refGene / Gene.refGeneWithVer</li>
                            <li><strong>Required functional fields:</strong> ExonicFunc.refGene / ExonicFunc.refGeneWithVer</li>
                            <li><strong>Optional fields:</strong> Func.refGene, AAChange.refGene, and other annotation columns</li>
                        </ul>

                        <p class="mb-1"><strong>Example:</strong></p>
                        <pre class="bg-light p-2 border rounded">Chr    Start      End        Ref   Alt   Gene.refGene   Func.refGene   ExonicFunc.refGene   AAChange.refGene
7      140453136  140453136  A     T     EGFR           exonic         nonsynonymous SNV    EGFR:NM_005228:exon21:c.2573T&gt;G:p.L858R</pre>

                        <h6>2. VCF files</h6>
                        <p class="mb-1">
                            The system can accept <strong>annotated VCF</strong> files and will try to extract gene annotation
                            from the INFO column.
                        </p>
                        <p class="mb-1">
                            Supported annotation styles include common INFO tags such as
                            <code>ANN</code>, <code>CSQ</code>, <code>Gene.refGene</code>, <code>Gene</code>, and similar fields.
                        </p>

                        <p class="mb-1"><strong>Example:</strong></p>
                        <pre class="bg-light p-2 border rounded">#CHROM  POS        ID   REF  ALT  QUAL  FILTER  INFO
7       140453136  .    A    T    .     PASS    Gene.refGene=EGFR;Func.refGene=exonic;ExonicFunc.refGene=nonsynonymous SNV</pre>

                        <p class="text-muted mb-0">
                            Note: if a VCF contains only genomic coordinates but no gene annotation in INFO,
                            the system may not be able to perform matching.
                        </p>
                    </div>
                </div>

                <div class="card mb-3">
                    <div class="card-body">
                        <h5 class="card-title">Download Sample Files</h5>
                        <ul class="mb-0">
                            <li>
                                <a href="<%=request.getContextPath()%>/static/sample/sample_mutation.csv" download>
                                    Download sample CSV file
                                </a>
                            </li>
                            <li>
                                <a href="<%=request.getContextPath()%>/static/sample/sample_mutation.tsv" download>
                                    Download sample TSV file
                                </a>
                            </li>
                            <li>
                                <a href="<%=request.getContextPath()%>/static/sample/sample_mutation_annotated.vcf" download>
                                    Download sample annotated VCF file
                                </a>
                            </li>
                        </ul>
                    </div>
                </div>

                <div class="mb-4">
                    <a href="<%=request.getContextPath()%>/matchingIndex" class="btn btn-primary">Back to Upload Page</a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>