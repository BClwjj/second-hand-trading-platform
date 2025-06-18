<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!-- 引入Bootstrap CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- 引入Font Awesome图标 -->
<link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">

<div class="page-header">
    <h1 class="page-title">商品管理</h1>
</div>

<c:if test="${not empty success}">
    <div class="alert alert-success">${success}</div>
</c:if>
<c:if test="${not empty error}">
    <div class="alert alert-danger">${error}</div>
</c:if>

<div class="data-table">
    <div class="table-header">
        <div class="table-title">商品列表</div>
        <form class="d-flex" action="<c:url value='/admin/goods'/>" method="get">
            <input class="form-control me-2" type="search" name="keyword" placeholder="搜索商品..." value="${param.keyword}">
            <select class="form-select me-2" name="status" style="width: 120px;">
                <option value="">全部状态</option>
                <option value="0" ${param.status == '0' ? 'selected' : ''}>已下架</option>
                <option value="1" ${param.status == '1' ? 'selected' : ''}>已上架</option>
                <option value="2" ${param.status == '2' ? 'selected' : ''}>待审核</option>
                <option value="3" ${param.status == '3' ? 'selected' : ''}>审核不通过</option>
            </select>
            <button class="action-btn action-btn-primary" type="submit">搜索</button>
        </form>
    </div>
    <div class="card-body"> <!-- 卡片内容区 -->
        <div class="table-responsive">
            <table class="table table-striped table-hover">
                <thead class="table-light">
                <tr>
                    <th>ID</th>
                    <th>商品名称</th>
                    <th>价格</th>
                    <th>主图</th>
                    <th>卖家</th>
                    <th>发布时间</th>
                    <th>状态</th>
                    <th>操作</th>
                </tr>
                </thead>
                <tbody>
                <c:forEach items="${goodsList}" var="goods">
                    <tr>
                        <td>${goods.id}</td>
                        <td>${goods.name}</td>
                        <td>¥<fmt:formatNumber value="${goods.price}" pattern="#,##0.00"/></td>
                        <td>
                            <img src="${pageContext.request.contextPath}${goods.mainImage}"
                                 alt="${goods.name}" style="width:50px;height:50px;object-fit:cover;">
                        </td>
                        <td>${goods.seller.username}</td>
                        <td>
                            <fmt:formatDate value="${goods.createTime}" pattern="yyyy-MM-dd HH:mm"/>
                        </td>
                        <td>
                        <c:choose>
                            <c:when test="${goods.status == 0}">
                                <span class="badge bg-danger">已下架</span>
                            </c:when>
                            <c:when test="${goods.status == 1}">
                                <span class="badge bg-success">已上架</span>
                            </c:when>
                            <c:when test="${goods.status == 2}">
                                <span class="badge bg-warning">待审核</span>
                            </c:when>
                            <c:when test="${goods.status == 3}">
                                <span class="badge bg-secondary">审核不通过</span>
                            </c:when>
                        </c:choose>
                    </td>
                    <td>
                        <div class="d-flex">
                            <c:if test="${goods.status == 2}">
                                <!-- 审核通过表单 -->
                                <form action="<c:url value='/admin/goods/approve/${goods.id}'/>" method="post" class="me-2">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-success btn-sm"
                                            data-confirm="确定要通过此商品的审核吗？">
                                        <i class="fa fa-check"></i> 通过
                                    </button>
                                </form>

                                <!-- 拒绝审核表单 -->
                                <form action="<c:url value='/admin/goods/reject/${goods.id}'/>" method="post" class="me-2">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-warning btn-sm"
                                            data-confirm="确定要拒绝此商品的审核吗？">
                                        <i class="fa fa-times"></i> 拒绝
                                    </button>
                                </form>
                            </c:if>

                            <c:if test="${goods.status == 1}">
                                <!-- 下架商品表单 -->
                                <form action="<c:url value='/admin/goods/take-down/${goods.id}'/>" method="post" class="me-2">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-danger btn-sm"
                                            data-confirm="确定要下架此商品吗？">
                                        <i class="fa fa-ban"></i> 下架
                                    </button>
                                </form>
                            </c:if>

                            <a href="<c:url value='/goods/detail/${goods.id}'/>"
                               class="action-btn btn-info me-2" target="_blank">
                                <i class="fa fa-eye"></i> 查看
                            </a>
                            <!-- 在管理员商品列表的操作列中修改删除按钮显示条件 -->
                            <c:if test="${goods.status == 0}"> <!-- 只有下架状态的商品显示删除按钮 -->
                                <form action="<c:url value='/admin/goods/delete/${goods.id}'/>" method="post" class="d-inline">
                                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                    <button type="submit" class="btn btn-danger btn-sm"
                                            onclick="return confirm('确定要删除此商品吗？删除后不可恢复！')">
                                        <i class="fa fa-trash"></i> 删除
                                    </button>
                                </form>
                            </c:if>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            </tbody>
            </table>
        </div>
    </div>
</div>
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    $(document).ready(function() {
        // 审核通过
        $('.approve-btn').click(function() {
            const goodsId = $(this).data('goods-id');
            if (confirm('确定要通过此商品的审核吗？')) {
                $.ajax({
                    url: '<c:url value="/admin/goods/approve/{id}"/>',
                    type: 'POST',
                    data: {
                        '${_csrf.parameterName}': '${_csrf.token}'
                    },
                    success: function() {
                        location.reload();
                    },
                    error: function(xhr) {
                        alert('操作失败: ' + xhr.responseText);
                    }
                });
            }
        });

        // 拒绝审核
        $('.reject-btn').click(function() {
            const goodsId = $(this).data('goods-id');
            if (confirm('确定要拒绝此商品的审核吗？')) {
                $.ajax({
                    url: '<c:url value="/admin/goods/reject/{id}"/>',
                    type: 'POST',
                    data: {
                        '${_csrf.parameterName}': '${_csrf.token}'
                    },
                    success: function() {
                        location.reload();
                    },
                    error: function(xhr) {
                        alert('操作失败: ' + xhr.responseText);
                    }
                });
            }
        });

        // 下架商品
        $('.take-down-btn').click(function() {
            const goodsId = $(this).data('goods-id');
            if (confirm('确定要下架此商品吗？')) {
                $.ajax({
                    url: '<c:url value="/admin/goods/approve/{id}"/>',
                    type: 'POST',
                    data: {
                        '${_csrf.parameterName}': '${_csrf.token}'
                    },
                    success: function() {
                        location.reload();
                    },
                    error: function(xhr) {
                        alert('操作失败: ' + xhr.responseText);
                    }
                });
            }
        });
        // 删除确认 - 添加状态检查
        $(document).on('submit', 'form[action*="/delete/"]', function(e) {
            const status = $(this).closest('tr').find('.badge').text().trim();
            if (status !== "已下架") {
                alert('只有下架状态的商品可以删除！');
                return false;
            }
            return confirm('确定要删除此商品吗？删除后不可恢复！');
        });
    });
</script>