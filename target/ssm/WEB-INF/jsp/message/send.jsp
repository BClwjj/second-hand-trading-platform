<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>发送消息</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@include file="../common/header.jsp"%>

<div class="container mt-5" style="max-width: 800px;">
    <div class="card">
        <div class="card-header bg-primary text-white">
            <h4>发送消息</h4>
        </div>
        <div class="card-body">
            <c:if test="${not empty error}">
                <div class="alert alert-danger">${error}</div>
            </c:if>

            <form action="${pageContext.request.contextPath}/message/send" method="post">
                <div class="mb-3">
                    <label class="form-label">接收者用户名</label>
                    <!-- 只读显示，隐藏域提交实际值 -->
                    <input type="text" class="form-control"
                           value="${param.recipientUsername}" readonly>
                    <input type="hidden" name="recipientUsername"
                           value="${param.recipientUsername}">
                </div>

                <div class="mb-3">
                    <label class="form-label">消息标题</label>
                    <input type="text" class="form-control" name="title"
                           value="${param.title}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">消息内容</label>
                    <textarea class="form-control" name="content" rows="6" required>
                        ${param.content}
                    </textarea>
                </div>

                <div class="d-flex justify-content-end">
                    <a href="${pageContext.request.contextPath}/user/center#myMessages"
                       class="btn btn-secondary me-2">
                        返回
                    </a>
                    <button type="submit" class="btn btn-primary">
                        <i class="fas fa-paper-plane"></i> 发送消息
                    </button>
                </div>
            </form>
        </div>
    </div>
</div>

<%@include file="../common/footer.jsp"%>
</body>
</html>