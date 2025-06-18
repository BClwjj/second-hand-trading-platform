<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>${goods.name} - 二手优品</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/index.css">
    <style>
        .goods-detail-container {
            display: flex;
            margin: 20px 0;
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .goods-images {
            width: 50%;
            padding-right: 20px;
        }

        .goods-info {
            width: 50%;
            padding-left: 20px;
        }

        .main-image {
            width: 100%;
            max-height: 500px;
            object-fit: contain;
            margin-bottom: 15px;
            border: 1px solid #eee;
        }

        .thumbnail-list {
            display: flex;
            gap: 10px;
            overflow-x: auto;
            padding-bottom: 10px;
        }

        .thumbnail-item {
            width: 80px;
            height: 80px;
            border: 2px solid #eee;
            cursor: pointer;
            flex-shrink: 0;
        }

        .thumbnail-item.active {
            border-color: var(--primary-color);
        }

        .thumbnail-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .goods-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 15px;
        }

        .goods-price {
            color: var(--primary-color);
            font-size: 28px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        .goods-meta {
            margin-bottom: 20px;
        }

        .meta-item {
            display: flex;
            margin-bottom: 10px;
            align-items: center; /* 垂直居中 */
        }

        .meta-label {
            color: var(--gray-color);
            /* 原min-width:80px导致间距过大，改为更小的值或auto */
            min-width: 5px; /* 缩短标签最小宽度 */
            flex-shrink: 1; /* 允许标签适当收缩 */
            margin-right: 10px; /* 增加右侧间距，保持呼吸感 */
            white-space: nowrap; /* 防止标签文本换行 */
        }

        .meta-value {
            flex: 1; /* 自动填充剩余空间 */
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        /* 小屏幕进一步缩小标签宽度 */
        @media (max-width: 768px) {
            .meta-label {
                min-width: 50px;
            }
        }

        .seller-info {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 15px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }

        .seller-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            margin-right: 15px;
            object-fit: cover;
        }

        .action-buttons {
            display: flex;
            gap: 15px;
            margin-top: 30px;
        }

        .btn {
            padding: 12px 25px;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
            transition: all 0.3s;
            border: none;
        }

        .btn-primary {
            background-color: var(--primary-color);
            color: white;
        }

        .btn-outline {
            background-color: white;
            color: var(--primary-color);
            border: 1px solid var(--primary-color);
        }

        .goods-description {
            margin-top: 30px;
            padding: 20px;
            background-color: #f9f9f9;
            border-radius: 8px;
        }

        .description-title {
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 15px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }
    </style>
</head>
<body>
<!-- 头部 -->
<%@include file="../common/header.jsp"%>

<!-- 商品详情内容 -->
<main class="container">
    <div class="goods-detail-container">
        <!-- 商品图片 -->
        <div class="goods-images">
            <!-- 安全处理图片列表 -->
            <c:set var="imageList" value="${fn:split(goods.images, ',')}" />
            <c:set var="finalImageList" value="" />

            <c:choose>
                <c:when test="${not empty goods.mainImage}">
                    <!-- 添加主图 -->
                    <c:set var="finalImageList" value="${goods.mainImage}" />

                    <!-- 添加其他非主图图片 -->
                    <c:forEach items="${imageList}" var="img">
                        <c:if test="${not empty img && img ne goods.mainImage}">
                            <c:set var="finalImageList" value="${finalImageList},${img}" />
                        </c:if>
                    </c:forEach>
                </c:when>
                <c:otherwise>
                    <!-- 没有主图时直接使用原图列表 -->
                    <c:forEach items="${imageList}" var="img" varStatus="loop">
                        <c:if test="${not empty img}">
                            <c:choose>
                                <c:when test="${empty finalImageList}">
                                    <c:set var="finalImageList" value="${img}" />
                                </c:when>
                                <c:otherwise>
                                    <c:set var="finalImageList" value="${finalImageList},${img}" />
                                </c:otherwise>
                            </c:choose>
                        </c:if>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

            <!-- 转换为数组 -->
            <c:set var="finalImageArray" value="${fn:split(finalImageList, ',')}" />
            <!-- 主图 -->
            <img id="mainImage"
                 src="${pageContext.request.contextPath}${not empty finalImageArray[0] ? finalImageArray[0] : '/static/images/default.png'}"
                 class="main-image"
                 alt="${goods.name}" />

            <!-- 缩略图列表 -->
            <div class="thumbnail-list">
                <c:forEach items="${finalImageArray}" var="image" varStatus="status">
                    <c:if test="${not empty image}">
                        <div class="thumbnail-item ${status.first ? 'active' : ''}">
                            <img src="${pageContext.request.contextPath}${image}" alt="商品图片">
                        </div>
                    </c:if>
                </c:forEach>
            </div>
        </div>

        <!-- 商品信息 -->
        <div class="goods-info">
            <h1 class="goods-title">${goods.name}</h1>
            <div class="goods-price">¥<fmt:formatNumber value="${goods.price}" pattern="#,##0.00"/></div>

            <div class="goods-meta">
                <div class="meta-item">
                    <span class="meta-label">浏览量：</span>
                    <span class="meta-value">${goods.viewCount}</span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">发布时间：</span>
                    <span class="meta-value"><fmt:formatDate value="${goods.createTime}" pattern="yyyy-MM-dd HH:mm"/></span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">商品状态：</span>
                    <span class="meta-value">
            <c:choose>
                <c:when test="${goods.status == 1}">上架中</c:when>
                <c:when test="${goods.status == 0}">已下架</c:when>
                <c:when test="${goods.status == 2}">审核中</c:when>
            </c:choose>
        </span>
                </div>
                <div class="meta-item">
                    <span class="meta-label">商品分类：</span>
                    <span class="meta-value">${goods.category.name}</span>
                </div>
            </div>

            <!-- 卖家信息 -->
            <div class="seller-info">
                <img src="${pageContext.request.contextPath}${goods.seller.avatar}" class="seller-avatar" alt="${goods.seller.username}">
                <div>
                    <div style="font-weight: bold;">${goods.seller.username}</div>
                    <div>${goods.seller.address}</div>
                </div>
            </div>

            <!-- 操作按钮 -->
            <div class="action-buttons">
                <button class="btn btn-primary" onclick="buyNow(${goods.id})">
                    <i class="fas fa-bolt"></i> 立即购买
                </button>
                <button id="favoriteBtn" class="btn btn-outline-danger" onclick="toggleFavorite(${goods.id})">
                    <i class="fas fa-heart"></i>
                    <span id="favoriteText">收藏</span>
                    <span class="spinner-border spinner-border-sm ms-2 d-none" id="favoriteSpinner"></span>
                </button>
                <!-- 修改为传递商品名称和ID -->
                <button class="btn btn-primary"
                        onclick="contactSeller('${goods.seller.username}', '${goods.name}', ${goods.id})">
                    <i class="fas fa-comment-dots"></i> 联系卖家
                </button>
            </div>
        </div>

    </div>

    <!-- 商品描述 -->
    <div class="goods-description">
        <div class="description-title">商品描述</div>
        <div>${goods.description}</div>
    </div>
</main>

<!-- 页脚 -->
<%@include file="../common/footer.jsp"%>

<!-- 引入JS -->
<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script>
    /// 联系卖家函数
    function contactSeller(sellerUsername, goodsName, goodsId) {
        <c:if test="${empty sessionScope.user}">
        if(confirm('您还未登录，是否前往登录？')) {
            window.location.href = '${pageContext.request.contextPath}/user/login?redirect=' +
                encodeURIComponent(window.location.pathname);
            return;
        }
        </c:if>

        // 使用JavaScript原生的encodeURIComponent
        const encodedTitle = encodeURIComponent('[商品咨询] ' + goodsName);
        const encodedContent = encodeURIComponent('你好，我想咨询商品：' + goodsName + '\n商品链接：' + window.location.href);
        window.location.href = '${pageContext.request.contextPath}/message/send?' +
            'recipientUsername=' + encodeURIComponent(sellerUsername) +
            '&title=' + encodedTitle +
            '&content=' + encodedContent;
    }

    $(document).ready(function() {
        // 1. 缩略图点击事件
        $(document).on('click', '.thumbnail-item', function() {
            const url = $(this).find('img').attr('src');
            $('#mainImage').attr('src', url);
            $('.thumbnail-item').removeClass('active');
            $(this).addClass('active');
        });

        // 2. 自动激活第一个缩略图
        setTimeout(function() {
            $('.thumbnail-item:first').trigger('click');
        }, 100);

        // 3. 立即购买（保持在 ready 内，通过 window 暴露为全局函数）
        window.buyNow = function(goodsId) {
            <c:if test="${empty sessionScope.user}">
            if(confirm('您还未登录，是否前往登录？')) {
                window.location.href = '${pageContext.request.contextPath}/user/login?redirect=' +
                    encodeURIComponent(window.location.pathname);
            }
            return;
            </c:if>
            window.location.href = '${pageContext.request.contextPath}/order/create/' + goodsId;
        }

        // 4. 收藏商品（保持在 ready 内，通过 window 暴露为全局函数）
        window.toggleFavorite = function(goodsId) {
            const btn = $('#favoriteBtn');
            const text = $('#favoriteText');
            const spinner = $('#favoriteSpinner');
            btn.prop('disabled', true);
            spinner.removeClass('d-none');
            text.text('处理中...');

            $.post('${pageContext.request.contextPath}/favorite/toggle', { goodsId: goodsId })
                .done(function(response) {
                    if (response.success) {
                        btn.toggleClass('btn-danger btn-outline-danger');
                        text.text(btn.hasClass('btn-danger') ? '已收藏' : '收藏');
                        alert(response.message);
                    } else {
                        alert(response.message);
                    }
                })
                .always(function() {
                    btn.prop('disabled', false);
                    spinner.addClass('d-none');
                });
        }

        // 5. 检查收藏状态
        const goodsId = ${goods.id};
        $.get('${pageContext.request.contextPath}/favorite/check', { goodsId: goodsId })
            .done(function(response) {
                if (response.isFavorite) {
                    $('#favoriteBtn').removeClass('btn-outline-danger').addClass('btn-danger').find('#favoriteText').text('已收藏');
                }
            });

    });
</script>
</body>
</html>     