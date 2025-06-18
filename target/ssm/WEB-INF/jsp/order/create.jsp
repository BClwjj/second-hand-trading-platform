<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>创建订单 - ${goods.name}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .order-container {
            max-width: 800px;
            margin: 30px auto;
            padding: 20px;
            background-color: white;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .goods-info {
            display: flex;
            margin-bottom: 20px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }
        .goods-image {
            width: 150px;
            height: 150px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 20px;
        }
        .form-label {
            font-weight: bold;
        }
    </style>
</head>
<body>
<!-- 头部 -->
<%@include file="../common/header.jsp"%>
<div class="container">
    <div class="order-container">
        <h2 class="mb-4">创建订单</h2>

        <div class="goods-info">
            <img src="${pageContext.request.contextPath}${goods.mainImage}"
                 class="goods-image" alt="${goods.name}">
            <div>
                <h4>${goods.name}</h4>
                <p class="text-danger fs-4">¥<fmt:formatNumber value="${goods.price}" pattern="#,##0.00"/></p>
                <p>卖家: ${goods.seller.username}</p>
            </div>
        </div>

        <form action="${pageContext.request.contextPath}/order/create" method="post">
            <input type="hidden" name="goodsId" value="${goods.id}">

            <div class="mb-3">
                <label class="form-label">交易方式</label>
                <select name="tradeMethod" class="form-select" required>
                    <option value="线下交易">线下交易</option>
                    <option value="快递邮寄">快递邮寄</option>
                    <option value="平台担保">平台担保</option>
                </select>
            </div>

            <div class="mb-3">
                <label class="form-label">买家留言</label>
                <textarea name="buyerMessage" class="form-control" rows="3"
                          placeholder="请输入留言信息(选填)"></textarea>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-primary btn-lg">提交订单</button>
                <a href="${pageContext.request.contextPath}/goods/detail/${goods.id}"
                   class="btn btn-outline-secondary">返回商品详情</a>
            </div>
        </form>
    </div>
</div>
<!-- 页脚 -->
<%@include file="../common/footer.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>