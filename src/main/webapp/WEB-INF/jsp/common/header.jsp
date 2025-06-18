<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<link rel="stylesheet" href="https://unpkg.com/swiper/swiper-bundle.min.css">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/index.css">
<div class="top-bar">
    <div class="container">
        <div class="welcome">欢迎来到二手优品交易平台</div>
        <div class="top-links">
            <c:if test="${not empty sessionScope.user}">
                <a href="<%= request.getContextPath() %>/user/center"><i class="fas fa-user"></i> 个人中心</a>
                <a href="<%= request.getContextPath() %>/user/logout"><i class="fas fa-sign-out-alt"></i> 退出</a>
            </c:if>
            <c:if test="${empty sessionScope.user}">
                <a href="<%= request.getContextPath() %>/user/login"><i class="fas fa-sign-in-alt"></i> 登录</a>
                <a href="<%= request.getContextPath() %>/user/register"><i class="fas fa-user-plus"></i> 注册</a>
                <a href="<%= request.getContextPath() %>/admin/login"><i class="fas fa-lock"></i> 管理员</a>
            </c:if>
            <a href="<%= request.getContextPath() %>/goods/publish"><i class="fas fa-plus"></i> 发布商品</a>
        </div>
    </div>
</div>

<!-- 主头部 -->
<header class="main-header">
    <div class="container">
        <div class="header-content">
            <div class="logo">
                <div class="logo-text">二手优品</div>
            </div>

            <div class="search-box">
                <input type="text" placeholder="搜索你想要的商品..." id="searchInput">
                <button id="searchButton"><i class="fas fa-search"></i> 搜索</button>
            </div>

            <div class="user-actions">
                <a href="<%= request.getContextPath() %>/user/center#myMessages"><i class="fas fa-envelope"></i> 消息
                    <c:if test="${unreadCount > 0}">
                        <span class="badge bg-danger rounded-pill ms-2">${unreadCount}</span>
                    </c:if></a>
                <a href="<%= request.getContextPath() %>/user/center#myFavorites"><i class="fas fa-heart"></i> 收藏</a>
                <a href="<%= request.getContextPath() %>/user/center#myOrders">
                    <i class="fas fa-shopping-cart"></i> 订单
                </a>
            </div>
        </div>
    </div>
</header>

<!-- 主导航菜单 -->
<nav class="main-nav">
    <div class="container">
        <ul>
            <li><a href="<%= request.getContextPath() %>/index"><i class="fas fa-home"></i> 首页</a></li>
            <li><a href="<%= request.getContextPath() %>/goods/list"><i class="fas fa-list"></i> 全部商品</a></li>
            <c:forEach items="${categories}" var="category" end="5">
                <li>
                    <a href="<%= request.getContextPath() %>/goods/list?categoryId=${category.id}">
                        <i class="fas ${category.icon}"></i> ${category.name}
                    </a>
                </li>
            </c:forEach>
        </ul>
    </div>
</nav>

<!-- 搜索功能JS代码（直接写在头部） -->
<script>
    document.addEventListener('DOMContentLoaded', function() {
        const searchButton = document.getElementById('searchButton');
        const searchInput = document.getElementById('searchInput');

        if (searchButton) {
            searchButton.addEventListener('click', function() {
                searchGoods();
            });
        }

        if (searchInput) {
            searchInput.addEventListener('keypress', function(e) {
                if (e.key === 'Enter') {
                    searchGoods();
                }
            });
        }
    });

    function searchGoods() {
        const keyword = document.getElementById('searchInput').value.trim();
        if (keyword) {
            window.location.href = '<%= request.getContextPath() %>/goods/list?keyword=' + encodeURIComponent(keyword);
        }
    }
</script>