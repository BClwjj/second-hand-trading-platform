<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>订单详情 - ${order.orderId}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        .order-detail-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .order-header {
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .order-status {
            font-size: 18px;
            font-weight: bold;
        }
        .order-info {
            margin-bottom: 20px;
        }
        .info-label {
            font-weight: bold;
            color: #666;
            width: 120px;
        }
        .goods-item {
            display: flex;
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }
        .goods-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            margin-right: 15px;
            border-radius: 4px;
        }
        .action-buttons {
            margin-top: 30px;
            display: flex;
            gap: 15px;
        }
    </style>
</head>
<body>
<!-- 头部 -->
<%@include file="../common/header.jsp"%>
<div class="container">
    <div class="order-detail-container">
        <div class="order-header">
            <h2>订单详情</h2>
            <div class="order-status">
                订单状态:
                <c:choose>
                    <c:when test="${order.status == 0}">
                        <span class="badge bg-warning">待确认</span>
                    </c:when>
                    <c:when test="${order.status == 1}">
                        <span class="badge bg-success">已完成</span>
                    </c:when>
                    <c:otherwise>
                        <span class="badge bg-danger">已取消</span>
                    </c:otherwise>
                </c:choose>
            </div>
            <div>订单编号: ${order.orderId}</div>
            <div>创建时间: <fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
        </div>

        <div class="order-info">
            <h4>商品信息</h4>
            <div class="goods-item">
                <img src="${pageContext.request.contextPath}${order.product.mainImage}"
                     class="goods-image" alt="${order.product.name}">
                <div>
                    <h5>${order.product.name}</h5>
                    <p class="text-danger">¥<fmt:formatNumber value="${order.price}" pattern="#,##0.00"/></p>
                    <p>卖家: ${order.seller.username}</p>
                </div>
            </div>
        </div>

        <div class="order-info">
            <h4>订单信息</h4>
            <div class="row mb-2">
                <div class="col-md-2 info-label">买家:</div>
                <div class="col-md-10">${order.buyer.username}</div>
            </div>
            <div class="row mb-2">
                <div class="col-md-2 info-label">交易方式:</div>
                <div class="col-md-10">${order.tradeMethod}</div>
            </div>
            <div class="row mb-2">
                <div class="col-md-2 info-label">买家留言:</div>
                <div class="col-md-10">${empty order.buyerMessage ? '无' : order.buyerMessage}</div>
            </div>
            <div class="row mb-2">
                <div class="col-md-2 info-label">创建时间:</div>
                <div class="col-md-10"><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/></div>
            </div>
            <div class="row mb-2">
                <div class="col-md-2 info-label">更新时间:</div>
                <div class="col-md-10"><fmt:formatDate value="${order.updateTime}" pattern="yyyy-MM-dd HH:mm"/></div>
            </div>
        </div>

        <div class="action-buttons">
            <c:if test="${order.status == 0}">
                <c:if test="${sessionScope.user.userId == order.seller.userId}">
                    <form action="${pageContext.request.contextPath}/order/confirm/${order.orderId}"
                          method="post" style="display: inline;">
                        <button type="submit" class="btn btn-success">确认订单</button>
                    </form>
                </c:if>
                <c:if test="${sessionScope.user.userId == order.buyer.userId ||
                                 sessionScope.user.userId == order.seller.userId}">
                    <form action="${pageContext.request.contextPath}/order/cancel/${order.orderId}"
                          method="post" style="display: inline;">
                        <button type="submit" class="btn btn-danger">取消订单</button>
                    </form>
                </c:if>
            </c:if>
            <a href="${pageContext.request.contextPath}/user/center#myOrders" class="btn btn-outline-secondary">返回订单列表</a>
        </div>
    </div>
</div>
<!-- 页脚 -->
<%@include file="../common/footer.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>