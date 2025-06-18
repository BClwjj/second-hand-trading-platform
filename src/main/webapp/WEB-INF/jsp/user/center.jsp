<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<html>
<head>
    <title>个人中心 - 二手交易平台</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        /* 基础布局样式 */
        .user-center-container {
            display: flex;
            margin-top: 20px;
        }

        .user-sidebar {
            width: 250px;
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
            margin-right: 20px;
        }

        .user-content {
            flex: 1;
            background-color: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        /* 用户信息样式 */
        .user-avatar {
            width: 120px;
            height: 120px;
            border-radius: 50%;
            object-fit: cover;
            margin: 0 auto 15px;
            display: block;
            border: 3px solid #f0f0f0;
        }

        .user-name {
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
        }

        /* 菜单样式 */
        .user-menu {
            list-style: none;
            padding: 0;
        }

        .user-menu li {
            margin-bottom: 10px;
        }

        .user-menu a {
            display: block;
            padding: 10px;
            color: #333;
            border-radius: 4px;
            transition: all 0.3s;
            text-decoration: none;
        }

        .user-menu a:hover, .user-menu a.active {
            background-color: #f5f5f5;
            color: #0d6efd;
        }

        .user-menu a i {
            margin-right: 10px;
            width: 20px;
            text-align: center;
        }

        /* 通用内容样式 */
        .section-title {
            font-size: 20px;
            font-weight: bold;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 1px solid #eee;
        }

        .tab-content {
            display: none;
        }

        .tab-content.active {
            display: block;
        }

        /* 商品和收藏列表统一为每行4个 */
        .goods-list, .favorite-list {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(23%, 1fr));
            gap: 20px;
        }

        /* 商品和收藏项统一样式 */
        .goods-item, .favorite-item {
            border: 1px solid #eee;
            border-radius: 8px;
            overflow: hidden;
            transition: all 0.3s;
            display: flex;
            flex-direction: column;
        }

        .goods-item:hover, .favorite-item:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        /* 图片统一高度 */
        .goods-img, .favorite-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .goods-info, .favorite-body {
            padding: 15px;
            flex: 1;
        }

        .goods-title {
            font-size: 16px;
            margin-bottom: 8px;
            height: 40px;
            overflow: hidden;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
        }

        .goods-price {
            color: #0d6efd;
            font-weight: bold;
        }

        /* 链接悬停效果 */
        a.order-link, a.goods-link {
            color: #0d6efd;
            text-decoration: none;
            transition: all 0.2s;
        }

        a.order-link:hover, a.goods-link:hover {
            color: #0a58ca;
            text-decoration: underline;
        }

        /* 列表项通用样式 */
        .list-item {
            border: 1px solid #eee;
            border-radius: 8px;
            padding: 15px;
            margin-bottom: 15px;
            transition: all 0.3s;
        }

        .list-item:hover {
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.1);
        }

        /* 订单特定样式 */
        .order-item .d-flex {
            margin-bottom: 10px;
        }

        /* 消息特定样式 */
        .message-item {
            border-left: 3px solid #0d6efd;
            background-color: #f8f9fa;
        }

        .message-unread {
            border-left-color: #dc3545;
            background-color: #fff;
        }

        /* 状态标签样式 */
        .status-badge {
            display: inline-block;
            padding: 3px 8px;
            border-radius: 4px;
            font-size: 12px;
        }

        .status-pending {
            background-color: #fff3cd;
            color: #856404;
        }

        .status-completed {
            background-color: #d4edda;
            color: #155724;
        }

        .status-cancelled {
            background-color: #f8d7da;
            color: #721c24;
        }

        /* 导航标签样式 */
        .nav-tabs .nav-link.active {
            font-weight: bold;
            color: #0d6efd;
        }

        /* 响应式调整 - 小屏幕时每行显示2个 */
        @media (max-width: 992px) {
            .goods-list, .favorite-list {
                grid-template-columns: repeat(auto-fill, minmax(48%, 1fr));
            }
        }

        /* 响应式调整 - 超小屏幕时每行显示1个 */
        @media (max-width: 576px) {
            .goods-list, .favorite-list {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
<!-- 头部 -->
<%@include file="../common/header.jsp"%>
<!-- 个人中心内容 -->
<div class="container user-center-container">
    <!-- 左侧菜单 -->
    <div class="user-sidebar">
        <img src="${pageContext.request.contextPath}${user.avatar}" class="user-avatar" alt="${user.username}">
        <div class="user-name">${user.username}</div>

        <ul class="user-menu">
            <li><a href="#" class="active" onclick="showTab('profile')"><i class="fas fa-user"></i> 个人资料</a></li>
            <li><a href="#" onclick="showTab('myGoods')"><i class="fas fa-box-open"></i> 我的商品</a></li>
            <li><a href="#" onclick="showTab('myOrders')"><i class="fas fa-receipt"></i> 我的订单</a></li>
            <li><a href="#" onclick="showTab('myFavorites')"><i class="fas fa-heart"></i> 我的收藏</a></li>
            <li><a href="#" onclick="showTab('myMessages')"><i class="fas fa-envelope"></i> 我的消息
                <c:if test="${unreadCount > 0}">//显示未读信息
                    <span class="badge bg-danger rounded-pill ms-2">${unreadCount}</span>
                </c:if></a></li>
            <li><a href="#" onclick="showTab('password')"><i class="fas fa-lock"></i> 修改密码</a></li>
            <li><a href="${pageContext.request.contextPath}/goods/publish"><i class="fas fa-plus"></i> 发布商品</a></li>
        </ul>
    </div>

    <!-- 右侧内容 -->
    <div class="user-content">
        <c:if test="${not empty success}">
            <div class="alert alert-success alert-dismissible fade show" role="alert">
                    ${success}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <c:if test="${not empty error}">
            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    ${error}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            </div>
        </c:if>

        <!-- 个人资料 -->
        <div id="profile" class="tab-content active">
            <h2 class="section-title"><i class="fas fa-user me-2"></i>个人资料</h2>
            <form action="${pageContext.request.contextPath}/user/center/update" method="post" enctype="multipart/form-data">
                <div class="mb-3">
                    <label class="form-label">用户名</label>
                    <input type="text" class="form-control" name="username" value="${user.username}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">邮箱</label>
                    <input type="email" class="form-control" name="email" value="${user.email}" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">电话</label>
                    <input type="tel" class="form-control" name="phone" value="${user.phone}">
                </div>

                <div class="mb-3">
                    <label class="form-label">地址</label>
                    <input type="text" class="form-control" name="address" value="${user.address}">
                </div>

                <div class="mb-3">
                    <label class="form-label">头像</label>
                    <input type="file" class="form-control" name="avatarFile">
                    <div class="form-text">当前头像: <a href="${pageContext.request.contextPath}${user.avatar}" target="_blank">查看</a></div>
                </div>
                <button type="submit" class="btn btn-primary">保存修改</button>
            </form>
        </div>

        <!-- 我的商品 -->
        <div id="myGoods" class="tab-content">
            <h2 class="section-title"><i class="fas fa-box-open me-2"></i>我的商品</h2>
            <c:if test="${empty myGoods}">
                <div class="alert alert-info">您还没有发布过商品，<a href="${pageContext.request.contextPath}/goods/publish" class="alert-link">去发布</a></div>
            </c:if>

            <div class="goods-list">
                <c:forEach items="${myGoods}" var="goods">
                    <div class="goods-item">
                        <a class="goods-link" href="${pageContext.request.contextPath}/goods/detail/${goods.id}">
                            <img src="${pageContext.request.contextPath}${goods.mainImage}" class="goods-img" alt="${goods.name}">
                            <div class="goods-info">
                                <div class="goods-title">${goods.name}</div>
                                <div class="goods-price">¥<fmt:formatNumber value="${goods.price}" pattern="#,##0.00"/></div>
                                <div>
                        <span class="status-badge ${goods.status == 1 ? 'status-completed' : goods.status == 0 ? 'status-cancelled' : 'status-pending'}">
                            <c:choose>
                                <c:when test="${goods.status == 1}">上架中</c:when>
                                <c:when test="${goods.status == 0}">已下架</c:when>
                                <c:when test="${goods.status == 2}">审核中</c:when>
                            </c:choose>
                        </span>
                                </div>
                            </div>
                        </a>

                        <div class="action-buttons mt-3">
                            <a href="${pageContext.request.contextPath}/goods/edit/${goods.id}"
                               class="btn btn-sm btn-primary me-2">
                                <i class="fas fa-edit"></i> 编辑
                            </a>

                            <c:if test="${goods.status == 1}">
                                <form action="${pageContext.request.contextPath}/goods/off/${goods.id}"
                                      method="post"
                                      style="display: inline;">
                                    <button type="submit"
                                            class="btn btn-sm btn-danger me-2"
                                            onclick="return confirm('确定要下架该商品吗？')">
                                        <i class="fas fa-eye-slash"></i> 下架
                                    </button>
                                </form>
                            </c:if>

                            <c:if test="${goods.status == 0}">
                                <form action="${pageContext.request.contextPath}/goods/on/${goods.id}"
                                      method="post"
                                      style="display: inline;">
                                    <button type="submit"
                                            class="btn btn-sm btn-success"
                                            onclick="return confirm('确定要上架该商品吗？')">
                                        <i class="fas fa-eye"></i> 上架
                                    </button>
                                </form>
                            </c:if>
                            <!-- 在用户中心的商品列表部分修改删除按钮显示条件 -->
                            <c:if test="${goods.status == 0}"> <!-- 只有下架状态的商品显示删除按钮 -->
                                <form action="<c:url value='/goods/delete/${goods.id}'/>" method="post" class="d-inline">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-danger btn-sm"
                                            onclick="return confirm('确定要删除此商品吗？删除后不可恢复！')">
                                        <i class="fa fa-trash"></i> 删除
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 我的订单 -->
        <div id="myOrders" class="tab-content">
            <h2 class="section-title"><i class="fas fa-receipt me-2"></i>我的订单</h2>

            <ul class="nav nav-tabs mb-3">
                <li class="nav-item">
                    <a class="nav-link active" href="#" onclick="filterOrders('all')">全部订单</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" onclick="filterOrders('pending')">待确认</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" onclick="filterOrders('completed')">已完成</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link" href="#" onclick="filterOrders('cancelled')">已取消</a>
                </li>
            </ul>

            <c:if test="${empty myOrders}">
                <div class="alert alert-info">您还没有订单</div>
            </c:if>

            <div class="order-list">
                <c:forEach items="${myOrders}" var="order">
                    <div class="list-item order-item" data-status="${order.status}">
                        <div class="d-flex justify-content-between mb-2">
                            <div>
                                <strong>订单号：</strong>
                                <a class="order-link" href="${pageContext.request.contextPath}/order/detail/${order.orderId}">${order.orderId}</a>
                            </div>
                            <div>
                                <span class="status-badge
                                    ${order.status == 0 ? 'status-pending' :
                                      order.status == 1 ? 'status-completed' : 'status-cancelled'}">
                                    <c:choose>
                                        <c:when test="${order.status == 0}">待确认</c:when>
                                        <c:when test="${order.status == 1}">已完成</c:when>
                                        <c:when test="${order.status == 2}">已取消</c:when>
                                    </c:choose>
                                </span>
                            </div>
                        </div>
                        <div class="mb-2">
                            <strong>商品：</strong>
                            <a class="order-link" href="${pageContext.request.contextPath}/goods/detail/${order.productId}">${order.productName}</a>
                        </div>
                        <div class="mb-2">
                            <strong>金额：</strong>¥<fmt:formatNumber value="${order.price}" pattern="#,##0.00"/>
                        </div>
                        <div class="mb-2">
                            <c:if test="${sessionScope.user.userId == order.buyerId}">
                                <strong>卖家：</strong>${order.sellerName}
                            </c:if>
                            <c:if test="${sessionScope.user.userId == order.sellerId}">
                                <strong>买家：</strong>${order.buyerName}
                            </c:if>
                        </div>
                        <div class="mb-2">
                            <strong>交易方式：</strong>${order.tradeMethod}
                        </div>
                        <div>
                            <strong>下单时间：</strong><fmt:formatDate value="${order.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </div>

                        <div class="mt-3 text-end">
                            <a href="${pageContext.request.contextPath}/order/detail/${order.orderId}"
                               class="btn btn-sm btn-outline-primary me-2">
                                <i class="fas fa-eye"></i> 查看详情
                            </a>
                            <c:if test="${order.status == 0}">
                                <c:if test="${sessionScope.user.userId == order.sellerId}">
                                    <form action="${pageContext.request.contextPath}/order/confirm/${order.orderId}"
                                          method="post" style="display: inline;">
                                        <button type="submit" class="btn btn-sm btn-success me-2">
                                            <i class="fas fa-check"></i> 确认订单
                                        </button>
                                    </form>
                                </c:if>
                                <c:if test="${sessionScope.user.userId == order.buyerId || sessionScope.user.userId == order.sellerId}">
                                    <form action="${pageContext.request.contextPath}/order/cancel/${order.orderId}"
                                          method="post" style="display: inline;">
                                        <button type="submit" class="btn btn-sm btn-danger"
                                                onclick="return confirm('确定要取消此订单吗？')">
                                            <i class="fas fa-times"></i> 取消订单
                                        </button>
                                    </form>
                                </c:if>
                            </c:if>
                            <c:if test="${order.status == 1 || order.status == 2}"> <!-- 允许删除的状态 -->
                                <form action="${pageContext.request.contextPath}/order/delete/${order.orderId}"
                                      method="post"
                                      style="display: inline;"
                                      onsubmit="return confirm('确定要删除此订单吗？删除后不可恢复！')">
                                    <button type="submit" class="btn btn-sm btn-danger me-2">
                                        <i class="fas fa-trash"></i> 删除订单
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 我的收藏 -->
        <div id="myFavorites" class="tab-content">
            <h2 class="section-title"><i class="fas fa-heart me-2"></i>我的收藏</h2>

            <c:if test="${empty myFavorites}">
                <div class="alert alert-info">您还没有收藏商品</div>
            </c:if>

            <div class="favorite-list">
                <c:forEach items="${myFavorites}" var="favorite">
                    <div class="list-item favorite-item">
                        <a class="goods-link" href="${pageContext.request.contextPath}/goods/detail/${favorite.goods.id}">
                            <img src="${pageContext.request.contextPath}${favorite.goods.mainImage}" class="favorite-img" alt="${favorite.goods.name}">
                            <div class="favorite-body">
                                <h5 class="goods-title">${favorite.goods.name}</h5>
                                <div class="text-danger">¥<fmt:formatNumber value="${favorite.goods.price}" pattern="#,##0.00"/></div>
                            </div>
                        </a>

                        <div class="favorite-footer">
                            <button onclick="removeFavorite(${favorite.goods.id})"
                                    class="btn btn-sm btn-outline-danger">
                                <i class="fas fa-heart-broken"></i> 取消收藏
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 我的消息 -->
        <div id="myMessages" class="tab-content">
            <h2 class="section-title"><i class="fas fa-envelope me-2"></i>我的消息</h2>

            <div class="d-flex justify-content-between mb-3">
                <button type="button" class="btn btn-sm btn-outline-secondary" id="markAllAsReadBtn">
                    <i class="fas fa-envelope-open"></i> 全部标记为已读
                </button>
                <a href="${pageContext.request.contextPath}/message/send" class="btn btn-sm btn-primary">
                    <i class="fas fa-paper-plane"></i> 发送消息
                </a>
            </div>

            <c:if test="${empty myMessages}">
                <div class="alert alert-info">您还没有消息</div>
            </c:if>

            <div class="message-list">
                <c:forEach items="${myMessages}" var="message">
                    <div class="list-item ${message.status == 0 ? 'message-unread' : ''}">
                        <div class="d-flex justify-content-between">
                            <h5>${message.title}</h5>
                            <c:if test="${message.status == 0}">
                                <span class="badge bg-danger">未读</span>
                            </c:if>
                        </div>
                        <p class="text-muted small">
                            <i class="fas fa-user-circle me-1"></i> ${message.senderUsername}
                            <i class="fas fa-clock ms-2 me-1"></i>
                            <fmt:formatDate value="${message.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </p>
                        <p class="mb-3">${message.content}</p>
                        <div class="d-flex justify-content-end">
                            <a href="${pageContext.request.contextPath}/message/detail/${message.messageId}"
                               class="btn btn-sm btn-outline-primary me-2">
                                <i class="fas fa-eye"></i> 查看详情
                            </a>
                            <button type="button" class="btn btn-sm btn-outline-danger"
                                    onclick="deleteMessage(${message.messageId})">
                                <i class="fas fa-trash"></i> 删除
                            </button>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- 修改密码 -->
        <div id="password" class="tab-content">
            <h2 class="section-title"><i class="fas fa-lock me-2"></i>修改密码</h2>
            <form action="${pageContext.request.contextPath}/user/center/change-password" method="post">
                <div class="mb-3">
                    <label class="form-label">原密码</label>
                    <input type="password" class="form-control" name="oldPassword" required>
                </div>

                <div class="mb-3">
                    <label class="form-label">新密码</label>
                    <input type="password" class="form-control" name="newPassword" required minlength="6" maxlength="20">
                </div>

                <div class="mb-3">
                    <label class="form-label">确认新密码</label>
                    <input type="password" class="form-control" name="confirmNewPassword" required minlength="6" maxlength="20">
                </div>

                <button type="submit" class="btn btn-primary">修改密码</button>
            </form>
        </div>
    </div>
</div>

<!-- 引入页脚 -->
<%@include file="../common/footer.jsp"%>
<script src="${pageContext.request.contextPath}/static/js/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 切换标签页
    function showTab(tabId) {
        // 隐藏所有标签页
        $('.tab-content').removeClass('active');
        // 显示选中的标签页
        $('#' + tabId).addClass('active');

        // 更新菜单项激活状态
        $('.user-menu a').removeClass('active');
        // 设置当前菜单项为激活状态
        $(`.user-menu a[onclick="showTab('${tabId}')"]`).addClass('active');

        // 更新URL锚点
        window.location.hash = tabId;
        return false;
    }

    // 页面加载时检查URL锚点
    $(document).ready(function() {
        if (window.location.hash) {
            const tabId = window.location.hash.substring(1);
            showTab(tabId);
        }

        // 密码表单验证
        $('#password form').on('submit', function(e) {
            const newPassword = $('input[name="newPassword"]').val();
            const confirmPassword = $('input[name="confirmNewPassword"]').val();

            if (newPassword !== confirmPassword) {
                e.preventDefault();
                alert('两次输入的新密码不一致');
            }
        });
    });

    // 订单筛选
    function filterOrders(status) {
        $('.order-item').each(function() {
            const itemStatus = $(this).data('status');
            let showItem = false;

            switch(status) {
                case 'all':
                    showItem = true;
                    break;
                case 'pending':
                    showItem = (itemStatus == 0);
                    break;
                case 'completed':
                    showItem = (itemStatus == 1);
                    break;
                case 'cancelled':
                    showItem = (itemStatus == 2);
                    break;
            }

            $(this).toggle(showItem);
        });

        // 更新选项卡状态
        $('.nav-tabs .nav-link').removeClass('active');
        $(`.nav-link[onclick="filterOrders('${status}')"]`).addClass('active');
    }

    // 取消收藏
    function removeFavorite(goodsId) {
        if (confirm('确定要取消收藏吗？')) {
            $.post('${pageContext.request.contextPath}/favorite/remove', { goodsId: goodsId })
                .done(function(response) {
                    if (response.success) {
                        alert(response.message);
                        location.reload();
                    } else {
                        alert(response.message);
                    }
                })
                .fail(function() {
                    alert('网络错误，请重试');
                });
        }
    }
    // 标记所有消息为已读
    function markAllAsRead() {
        if (confirm('确定要将所有消息标记为已读吗？')) {
            $.post('${pageContext.request.contextPath}/message/markAllAsRead')
                .done(function(result) {
                    if (result.success) {
                        alert(result.message);
                        location.reload();
                    } else {
                        alert('错误：' + result.message);
                    }
                })
                .fail(function() {
                    alert('网络请求失败，请重试');
                });
        }
    }

    // 删除消息
    function deleteMessage(messageId) {
        if (confirm('确定要删除这条消息吗？')) {
            $.post('${pageContext.request.contextPath}/message/delete/' + messageId)
                .done(function(result) {
                    if (result.success) {
                        alert(result.message);
                        location.reload();
                    } else {
                        alert('错误：' + result.message);
                    }
                })
                .fail(function() {
                    alert('网络请求失败，请重试');
                });
        }
    }

    // 绑定标记所有已读按钮
    $(document).ready(function() {
        $('#markAllAsReadBtn').click(markAllAsRead);
    });

</script>
</body>
</html>