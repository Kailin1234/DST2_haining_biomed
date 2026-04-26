<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page isELIgnored="false" %>

<!doctype html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <title>Mutation-Drug Matching</title>

    <link href="<%=request.getContextPath()%>/static/bootstrap/css/bootstrap.css" rel="stylesheet">
    <script src="<%=request.getContextPath()%>/static/jquery/jquery-3.4.1.js"></script>
    <script src="<%=request.getContextPath()%>/static/bootstrap/js/bootstrap.bundle.min.js"></script>
    <link href="<%=request.getContextPath()%>/static/css/app.css" rel="stylesheet">

    <style>
        pre {
            white-space: pre-wrap;
            word-break: break-word;
        }
    </style>
</head>

<body>
<nav class="navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow">
    <a class="navbar-brand col-sm-3 col-md-2 mr-0" href="<%=request.getContextPath()%>/">
        Precision Medicine Matching System
    </a>
</nav>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="nav.jsp">
            <jsp:param name="active" value="matching_index" />
        </jsp:include>

        <main role="main" class="col-md-9 ml-sm-auto col-lg-10 px-4">

            <div class="d-flex justify-content-between flex-wrap flex-md-nowrap align-items-center pt-3 pb-2 mb-3 border-bottom">
                <div>
                    <h2>Mutation-Drug Matching</h2>
                    <p class="text-muted mb-0">
                        Upload mutation data and run gene-based drug label matching.
                    </p>
                </div>
            </div>

            <div class="card mb-4">
                <div class="card-body">
                    <h5 class="card-title">Upload Mutation File</h5>

                    <p class="card-text">
                        Please upload a mutation file containing variant information for drug matching.
                        The system supports annotated table files and annotated VCF files.
                    </p>

                    <p class="card-text text-muted mb-4">
                        To perform direct drug matching, the uploaded file must contain gene-level annotation.
                        Raw VCF files without gene annotation may not be matched successfully.
                    </p>

                    <div class="card mb-3">
                        <div class="card-body">
                            <h5 class="card-title">File Upload Guide</h5>
                            <p class="card-text">
                                The system extracts core mutation fields and gene annotation, then performs downstream drug matching.
                            </p>

                            <h6>1. Table-based files: CSV / TSV / TXT</h6>
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
7       140453136  .    A    T    .     PASS    ANN=T|missense_variant|MODERATE|EGFR|...</pre>

                            <p class="text-muted mb-0">
                                Note: if a VCF contains only genomic coordinates but no gene annotation in INFO,
                                the system may not be able to perform matching.
                            </p>

                            <hr>

                            <h6>3. Download sample files</h6>
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

                    <form method="post" action="<%=request.getContextPath()%>/upload" enctype="multipart/form-data">

                        <div class="form-group">
                            <label for="mutationFile">Mutation File</label>
                            <input type="file"
                                   class="form-control-file"
                                   id="mutationFile"
                                   name="annovar"
                                   accept=".txt,.csv,.tsv,.vcf"
                                   required>
                            <small class="form-text text-muted">
                                Supported formats: annotated TXT, CSV, TSV, and VCF.
                            </small>
                        </div>

                        <div class="form-group">
                            <label for="uploaded_by">Uploaded By</label>
                            <input type="text"
                                   class="form-control"
                                   id="uploaded_by"
                                   name="uploaded_by"
                                   placeholder="Enter uploader name"
                                   required>
                        </div>

                        <button type="submit" class="btn btn-primary">
                            Upload and Match
                        </button>

                    </form>
                </div>
            </div>

        </main>
    </div>
</div>
</body>
</html>