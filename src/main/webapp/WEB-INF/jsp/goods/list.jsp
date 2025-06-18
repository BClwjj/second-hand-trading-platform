<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>商品列表 - 二手优品</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/index.css">
</head>
<style>
    /* 商品列表容器 */
    .goods-list-container {
        display: flex;
        margin: 20px 0 40px;
    }

    /* 侧边栏样式 */
    .sidebar {
        width: 200px;
        margin-right: 20px;
    }

    .category-box {
        background: #fff;
        border-radius: 4px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        padding: 15px;
    }

    .category-box h3 {
        font-size: 16px;
        margin-bottom: 15px;
        padding-bottom: 10px;
        border-bottom: 1px solid #eee;
    }

    .category-box ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .category-box li {
        margin-bottom: 8px;
    }

    .category-box li a {
        color: #666;
        text-decoration: none;
        display: block;
        padding: 5px 0;
    }

    .category-box li a:hover {
        color: #e74c3c;
    }

    .category-box li.active a {
        color: #e74c3c;
        font-weight: bold;
    }

    .category-box li i {
        margin-right: 5px;
        width: 18px;
        text-align: center;
    }

    /* 主内容区 */
    .main-content {
        flex: 1;
        background: #fff;
        border-radius: 4px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.1);
        padding: 20px;
    }

    /* 排序和筛选 */
    .sort-filter {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 20px;
        padding-bottom: 15px;
        border-bottom: 1px solid #eee;
    }

    .sort-options {
        display: flex;
        align-items: center;
    }

    .sort-options span {
        margin-right: 10px;
        color: #666;
    }

    .sort-options a {
        margin-right: 15px;
        color: #666;
        text-decoration: none;
    }

    .sort-options a:hover {
        color: #e74c3c;
    }

    .sort-options a.active {
        color: #e74c3c;
        font-weight: bold;
    }

    .search-result-info {
        color: #999;
    }

    /* 商品网格布局 */
    .goods-grid {
        display: grid;
        grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
        gap: 20px;
    }

    .goods-item {
        background: #fff;
        border-radius: 4px;
        overflow: hidden;
        transition: all 0.3s ease;
        border: 1px solid #eee;
    }

    .goods-item:hover {
        box-shadow: 0 5px 15px rgba(0,0,0,0.1);
        transform: translateY(-3px);
    }

    .goods-img-container {
        height: 200px;
        overflow: hidden;
        display: flex;
        align-items: center;
        justify-content: center;
        background: #f9f9f9;
    }

    .goods-img {
        max-width: 100%;
        max-height: 100%;
        object-fit: contain;
    }

    .goods-info {
        padding: 15px;
    }

    .goods-title {
        font-size: 14px;
        height: 40px;
        overflow: hidden;
        margin: 0 0 10px;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
    }

    .goods-price {
        color: #e74c3c;
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 10px;
    }

    .goods-meta {
        display: flex;
        justify-content: space-between;
        color: #999;
        font-size: 12px;
    }

    .goods-meta i {
        margin-right: 3px;
    }

    /* 分页样式 */
    .pagination {
        margin-top: 30px;
        display: flex;
        justify-content: center;
        align-items: center;
    }

    .pagination a {
        color: #666;
        text-decoration: none;
        padding: 5px 10px;
        margin: 0 5px;
        border: 1px solid #ddd;
        border-radius: 3px;
    }

    .pagination a:hover {
        background: #f5f5f5;
    }

    .pagination .page-current {
        padding: 5px 15px;
        color: #333;
    }

    /* 响应式设计 */
    @media (max-width: 768px) {
        .goods-list-container {
            flex-direction: column;
        }

        .sidebar {
            width: 100%;
            margin-right: 0;
            margin-bottom: 20px;
        }

        .goods-grid {
            grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
        }

        .sort-filter {
            flex-direction: column;
            align-items: flex-start;
        }

        .sort-options {
            margin-bottom: 10px;
            flex-wrap: wrap;
        }

        .sort-options a {
            margin-bottom: 5px;
        }
    }
</style>
<body>
<!-- 头部 -->
<%@include file="../common/header.jsp"%>
<!-- 面包屑导航 -->
<div class="breadcrumb">
    <div class="container">
        <a href="${pageContext.request.contextPath}/index">首页</a>
        <c:if test="${not empty currentCategory}">
            &gt; <a href="${pageContext.request.contextPath}/goods/list?categoryId=${currentCategory.id}">${currentCategory.name}</a>
        </c:if>
        <c:if test="${not empty keyword}">
            &gt; <span>搜索: ${keyword}</span>
        </c:if>
    </div>
</div>

<!-- 主要内容 -->
<main class="container">
    <div class="goods-list-container">
        <!-- 侧边栏分类 -->
        <aside class="sidebar">
            <div class="category-box">
                <h3>全部分类</h3>
                <ul>
                    <c:forEach items="${categories}" var="category">
                        <li <c:if test="${not empty categoryId && categoryId == category.id}">class="active"</c:if>>
                            <a href="${pageContext.request.contextPath}/goods/list?categoryId=${category.id}">
                                <i class="fas ${category.icon}"></i> ${category.name}
                            </a>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </aside>

        <!-- 商品列表主内容 -->
        <div class="main-content">
            <!-- 排序和筛选 -->
            <div class="sort-filter">
                <div class="sort-options">
                    <span>排序:</span>
                    <a href="?keyword=${keyword}&categoryId=${categoryId}&sort=new"
                       class="<c:if test="${sort == 'new'}">active</c:if>">最新</a>
                    <a href="?keyword=${keyword}&categoryId=${categoryId}&sort=hot"
                       class="<c:if test="${sort == 'hot'}">active</c:if>">最热</a>
                    <a href="?keyword=${keyword}&categoryId=${categoryId}&sort=price_asc"
                       class="<c:if test="${sort == 'price_asc'}">active</c:if>">价格从低到高</a>
                    <a href="?keyword=${keyword}&categoryId=${categoryId}&sort=price_desc"
                       class="<c:if test="${sort == 'price_desc'}">active</c:if>">价格从高到低</a>
                </div>
                <div class="search-result-info">
                    <c:if test="${not empty keyword}">
                        搜索"${keyword}"结果:
                    </c:if>
                    共找到 ${goodsList.size()} 件商品
                </div>
            </div>

            <!-- 商品列表 -->
            <div class="goods-grid">
                <c:forEach items="${goodsList}" var="goods">
                    <div class="goods-item">
                        <a href="${pageContext.request.contextPath}/goods/detail/${goods.id}">
                            <div class="goods-img-container">
                                <img src="${pageContext.request.contextPath}${goods.mainImage}"
                                     alt="${goods.name}" class="goods-img">
                            </div>
                            <div class="goods-info">
                                <h3 class="goods-title">${goods.name}</h3>
                                <div class="goods-price">
                                    ¥<fmt:formatNumber value="${goods.price}" pattern="#,##0.00"/>
                                </div>
                                <div class="goods-meta">
                                    <span><i class="fas fa-eye"></i> ${goods.viewCount}</span>
                                    <span><i class="fas fa-map-marker-alt"></i> ${goods.seller.address}</span>
                                </div>
                            </div>
                        </a>
                    </div>
                </c:forEach>
            </div>
            <!-- 分页 -->
            <div class="pagination">
                <c:if test="${page > 1}">
                    <a href="?keyword=${keyword}&categoryId=${categoryId}&sort=${sort}&page=${page-1}&size=${size}"
                       class="page-prev"><i class="fas fa-angle-left"></i> 上一页</a>
                </c:if>

                <span class="page-current">第 ${page} 页</span>

                <c:if test="${goodsList.size() == size}">
                    <a href="?keyword=${keyword}&categoryId=${categoryId}&sort=${sort}&page=${page+1}&size=${size}"
                       class="page-next">下一页 <i class="fas fa-angle-right"></i></a>
                </c:if>
            </div>
        </div>
    </div>
</main>

<!-- 引入页脚 -->
<%@include file="../common/footer.jsp"%>
<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script>
    // 搜索功能
    document.querySelector('.search-box input').addEventListener('keypress', function(e) {
        if(e.key === 'Enter') {
            searchGoods();
        }
    });
</script>
</body>
</html>