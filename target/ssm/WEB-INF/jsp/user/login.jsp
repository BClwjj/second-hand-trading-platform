<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>登录 - 二手优品</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/auth.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="auth-container">
    <div class="auth-card">
        <h2 class="auth-title"><i class="fas fa-sign-in-alt"></i> 欢迎回来</h2>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form id="loginForm" action="${pageContext.request.contextPath}/user/login" method="post">
            <div class="form-group">
                <label class="label-with-icon">用户名<i class="fas fa-user"></i></label>
                <div class="input-container">
                    <input type="text" class="form-control" id="username" name="username"
                           value="${username}" required placeholder="请输入用户名或邮箱">
                </div>
            </div>

            <div class="form-group">
                <label class="label-with-icon">密码<i class="fas fa-lock"></i></label>
                <div class="input-container">
                    <input type="password" class="form-control" id="password" name="password"
                           required placeholder="请输入密码">
                    <div class="text-end mt-2">
                        <a href="${pageContext.request.contextPath}/user/forgot-password" class="text-muted small">忘记密码？</a>
                    </div>
                </div>
            </div>

            <div class="form-group">
                <div class="d-flex justify-content-between align-items-center">
                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" id="remember" name="remember">
                        <label class="form-check-label" for="remember">记住我</label>
                    </div>
                    <a href="${pageContext.request.contextPath}/user/register" class="text-primary small">注册</a>
                </div>
            </div>

            <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-sign-in-alt me-2"></i>立即登录
            </button>

            <div class="social-login mt-4">
                <div class="social-login-title">其他登录方式</div>
                <div class="social-buttons">
                    <a href="#" class="social-btn wechat" title="微信登录">
                        <i class="fab fa-weixin"></i>
                    </a>
                    <a href="#" class="social-btn qq" title="QQ登录">
                        <i class="fab fa-qq"></i>
                    </a>
                    <a href="#" class="social-btn weibo" title="微博登录">
                        <i class="fab fa-weibo"></i>
                    </a>
                </div>
            </div>
        </form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>