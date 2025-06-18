<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>404 Not Found</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<div class="container text-center mt-5">
    <h1 class="display-1">404</h1>
    <p class="lead">您访问的页面不存在</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-primary">返回首页</a>
</div>
</body>
</html>