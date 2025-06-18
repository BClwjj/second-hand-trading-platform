<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>二手优品 - 二手交易平台</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/index.css">
</head>
<body>
<!-- 头部 -->
<%@include file="common/header.jsp"%>
<!-- 主要内容 -->
<main class="container">
    <!-- 轮播图 -->
    <div class="swiper-container">
        <div class="swiper-wrapper">
            <c:forEach items="${banners}" var="banner">
                <div class="swiper-slide">
                    <a href="${banner.linkUrl}">
                        <img src="${pageContext.request.contextPath}${banner.imageUrl}" alt="${banner.title}">
                    </a>
                </div>
            </c:forEach>
        </div>
        <!-- 添加分页器 -->
        <div class="swiper-pagination"></div>
        <!-- 添加导航按钮 -->
        <div class="swiper-button-prev"></div>
        <div class="swiper-button-next"></div>
    </div>
    <!-- +++ 新增公告区域 +++ -->
    <div class="announcement-bar">
        <div class="announcement-icon">
            <i class="fas fa-bullhorn"></i>
        </div>
        <div class="announcement-content">
            <c:forEach items="${announcements}" var="announce">
                <a href="javascript:void(0)"
                   class="announce-item"
                   data-id="${announce.id}"
                   data-title="${announce.title}"
                   data-content="${announce.content}">
                        ${announce.title}
                </a>
            </c:forEach>
        </div>
        <div class="announce-more">
            <a href="javascript:void(0)" id="showAllAnnounce">更多 <i class="fas fa-angle-right"></i></a>
        </div>
    </div>

    <!-- 热门商品 -->
    <div class="section-title">
        <h2><i class="fas fa-fire"></i> 热门商品</h2>
        <a href="${pageContext.request.contextPath}/goods/list?sort=view">查看更多 <i class="fas fa-angle-right"></i></a>
    </div>

    <div class="goods-list">
        <c:forEach items="${hotGoods}" var="goods"  >
            <div class="goods-item">
                <a href="${pageContext.request.contextPath}/goods/detail/${goods.id}">
                    <img src="${pageContext.request.contextPath}${goods.mainImage}" class="goods-img" alt="${goods.name}">
                    <div class="goods-info">
                        <div class="goods-title">${goods.name}</div>
                        <div class="goods-price">¥<fmt:formatNumber value="${goods.price}" pattern="#,##0.00"/></div>
                        <div class="goods-meta">
                            <span><i class="fas fa-eye"></i> ${goods.viewCount}</span>
                            <span><fmt:formatDate value="${goods.createTime}" pattern="yyyy-MM-dd"/></span>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>

    <!-- 最新商品 -->
    <div class="section-title">
        <h2><i class="fas fa-clock"></i> 最新上架</h2>
        <a href="${pageContext.request.contextPath}/goods/list?sort=new">查看更多 <i class="fas fa-angle-right"></i></a>
    </div>

    <div class="goods-list">
        <c:forEach items="${newGoods}" var="goods">
            <div class="goods-item">
                <a href="${pageContext.request.contextPath}/goods/detail/${goods.id}">
                    <img src="${pageContext.request.contextPath}${goods.mainImage}" class="goods-img" alt="${goods.name}">
                    <div class="goods-info">
                        <div class="goods-title">${goods.name}</div>
                        <div class="goods-price">¥<fmt:formatNumber value="${goods.price}" pattern="#,##0.00"/></div>
                        <div class="goods-meta">
                            <span><i class="fas fa-user"></i> ${goods.seller.username}</span>
                            <span><fmt:formatDate value="${goods.createTime}" pattern="yyyy-MM-dd"/></span>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>

    <!-- 推荐商品 -->
    <div class="section-title">
        <h2><i class="fas fa-thumbs-up"></i> 猜你喜欢</h2>
        <a href="${pageContext.request.contextPath}/goods/list">换一批 <i class="fas fa-sync-alt"></i></a>
    </div>

    <div class="goods-list">
        <c:forEach items="${recommendGoods}" var="goods">
            <div class="goods-item">
                <a href="${pageContext.request.contextPath}/goods/detail/${goods.id}">
<%--                    <img src="${pageContext.request.contextPath}${goods.mainImage}" class="goods-img" alt="${goods.name}">--%>
    <c:choose>
        <c:when test="${not empty goods.mainImage}">
            <img src="${pageContext.request.contextPath}${goods.mainImage}" class="goods-img" alt="${goods.name}">
        </c:when>
        <c:otherwise>
            <img src="${pageContext.request.contextPath}/static/images/avatar.jpg" class="goods-img" alt="默认图片">
        </c:otherwise>
    </c:choose>
                    <div class="goods-info">
                        <div class="goods-title">${goods.name}</div>
                        <div class="goods-price">¥<fmt:formatNumber value="${goods.price}" pattern="#,##0.00"/></div>
                        <div class="goods-meta">
                            <span><i class="fas fa-map-marker-alt"></i> ${goods.seller.address}</span>
                            <span><fmt:formatDate value="${goods.createTime}" pattern="yyyy-MM-dd"/></span>
                        </div>
                    </div>
                </a>
            </div>
        </c:forEach>
    </div>
</main>

<!-- 页脚 -->
<%@include file="common/footer.jsp"%>
<!-- 引入JS -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://unpkg.com/swiper/swiper-bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/index.js"></script>

</body>
</html>