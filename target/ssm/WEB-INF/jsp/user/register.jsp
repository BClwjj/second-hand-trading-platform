<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>注册 - 二手优品</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/static/css/auth.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body>
<div class="auth-container">
    <div class="auth-card">
        <h2 class="auth-title"><i class="fas fa-user-plus"></i> 注册二手优品</h2>

        <c:if test="${not empty param.error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                <i class="fas fa-exclamation-circle me-2"></i>${param.error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/user/register" method="post">
            <!-- 用户名 -->
            <div class="form-group">
                <label class="label-with-icon">用户名<i class="fas fa-user"></i></label>
                <div class="input-container">
                    <input type="text" class="form-control" name="username"
                           required minlength="4" maxlength="20" placeholder="4-20位字符">
                </div>
            </div>

            <!-- 邮箱 -->
            <div class="form-group">
                <label class="label-with-icon">邮箱<i class="fas fa-envelope"></i></label>
                <div class="input-container">
                    <input type="email" class="form-control" name="email"
                           required placeholder="请输入常用邮箱">
                </div>
            </div>

            <!-- 密码 -->
            <div class="form-group">
                <label class="label-with-icon">密码<i class="fas fa-lock"></i></label>
                <div class="input-container">
                    <input type="password" class="form-control" name="password"
                           required minlength="6" maxlength="20" placeholder="6-20位字符">
                    <div class="text-end mt-2">
                        <span class="length-hint">长度6-20位</span>
                    </div>
                </div>
            </div>

            <!-- 确认密码 -->
            <div class="form-group">
                <label class="label-with-icon">确认密码<i class="fas fa-lock"></i></label>
                <div class="input-container">
                    <input type="password" class="form-control" name="confirmPassword"
                           required placeholder="请再次输入密码">
                </div>
            </div>

            <!-- 手机号 -->
            <div class="form-group">
                <label class="label-with-icon">手机号<i class="fas fa-phone"></i></label>
                <div class="input-container">
                    <input type="tel" class="form-control" name="phone" placeholder="选填，方便联系">
                </div>
            </div>

            <!-- 协议 -->
            <div class="form-group">
                <div class="offset-label">
                    <input type="checkbox" class="form-check-input" name="agree" required>
                    <label class="form-check-label">
                        我已阅读并同意 <a href="#" class="text-primary">《用户协议》</a> 和 <a href="#" class="text-primary">《隐私政策》</a>
                    </label>
                </div>
            </div>

            <!-- 注册按钮 -->
            <button type="submit" class="btn btn-primary w-100">
                <i class="fas fa-user-plus me-2"></i>立即注册
            </button>

            <!-- 底部链接 -->
            <div class="auth-footer mt-4">
                已有账号？ <a href="${pageContext.request.contextPath}/user/login">立即登录</a>
            </div>
        </form>
    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>