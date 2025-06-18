<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>管理员登录 - 二手优品</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/auth.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="auth-container">
<div class="auth-card">
    <h2 class="auth-title"><i class="fas fa-lock"></i> 管理员登录</h2>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="fas fa-exclamation-circle me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <form action="${pageContext.request.contextPath}/admin/login" method="post">
        <div class="form-group">
            <label class="label-with-icon">管理员账号<i class="fas fa-user-shield"></i></label>
            <div class="input-container">
                <input type="text" class="form-control" id="username" name="username" required>
            </div>
        </div>

        <div class="form-group">
            <label class="label-with-icon">密码<i class="fas fa-key"></i></label>
            <div class="input-container">
                <input type="password" class="form-control" id="password" name="password" required>
            </div>
        </div>

        <button type="submit" class="btn btn-primary w-100">
            <i class="fas fa-sign-in-alt me-2"></i>登录管理后台
        </button>
    </form>

    <div class="auth-footer mt-3">
        <a href="${pageContext.request.contextPath}/user/login"><i class="fas fa-arrow-left me-1"></i>返回用户登录</a>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>