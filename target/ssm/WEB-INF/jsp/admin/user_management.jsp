<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>用户管理</title>
    <!-- 引入Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- 引入Font Awesome图标 -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        .action-btn {
            padding: 0.25rem 0.5rem;
            font-size: 0.875rem;
            margin: 0 2px;
        }
        .badge {
            font-size: 0.85em;
        }
        .table-responsive {
            overflow-x: auto;
        }
    </style>
</head>
<body>
<div class="container-fluid mt-3">
    <div class="page-header mb-4">
        <h1 class="page-title">用户管理</h1>
    </div>

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show">
                ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show">
                ${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">用户列表</h5>
            <form class="d-flex" action="<c:url value='/admin/users'/>" method="get">
                <input class="form-control me-2" type="search" name="keyword" placeholder="搜索用户..." value="${param.keyword}">
                <button class="btn btn-primary" type="submit">搜索</button>
            </form>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>用户名</th>
                        <th>邮箱</th>
                        <th>注册时间</th>
                        <th>状态</th>
                        <th>角色</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${users}" var="user">
                        <tr>
                            <td>${user.userId}</td>
                            <td>${user.username}</td>
                            <td>${user.email}</td>
                            <td>
                                <fmt:formatDate value="${user.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.status == 1}">
                                        <span class="badge bg-success">启用</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">禁用</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${user.role == 1}">
                                        <span class="badge bg-primary">管理员</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">普通用户</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <div class="d-flex">
                                    <c:choose>
                                        <c:when test="${user.status == 1}">
                                            <form action="<c:url value='/admin/users/update-status'/>" method="post" class="me-2">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="status" value="0">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-warning btn-sm">
                                                    <i class="fas fa-lock"></i> 禁用
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="<c:url value='/admin/users/update-status'/>" method="post" class="me-2">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="status" value="1">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-success btn-sm">
                                                    <i class="fas fa-unlock"></i> 启用
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>

                                    <c:choose>
                                        <c:when test="${user.role == 1}">
                                            <form action="<c:url value='/admin/users/update-role'/>" method="post" class="me-2">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="role" value="0">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-info btn-sm">
                                                    <i class="fas fa-user-minus"></i> 取消管理员
                                                </button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <form action="<c:url value='/admin/users/update-role'/>" method="post" class="me-2">
                                                <input type="hidden" name="userId" value="${user.userId}">
                                                <input type="hidden" name="role" value="1">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <button type="submit" class="btn btn-primary btn-sm">
                                                    <i class="fas fa-user-plus"></i> 设为管理员
                                                </button>
                                            </form>
                                        </c:otherwise>
                                    </c:choose>

                                    <!-- 删除按钮 - 使用AJAX方式 -->
                                    <button type="button" class="btn btn-danger btn-sm delete-btn"
                                            data-user-id="${user.userId}"
                                            data-user-name="${user.username}">
                                        <i class="fas fa-trash-alt"></i> 删除
                                    </button>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<!-- 删除确认模态框 -->
<div class="modal fade" id="deleteConfirmModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">确认删除</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>确定要删除用户 <strong id="deleteUserName"></strong> 吗？此操作不可恢复！</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <button type="button" class="btn btn-danger" id="confirmDeleteBtn">确认删除</button>
            </div>
        </div>
    </div>
</div>

<!-- 引入必要的JS库 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    $(document).ready(function() {
        let currentUserId = null;
        const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));

        // 删除按钮点击事件
        $('.delete-btn').click(function() {
            currentUserId = $(this).data('user-id');
            const userName = $(this).data('user-name');
            $('#deleteUserName').text(userName);
            deleteModal.show();
        });

        // 确认删除按钮事件
        $('#confirmDeleteBtn').click(function() {
            if (!currentUserId) return;

            $.ajax({
                url: '<c:url value="/admin/users/delete"/>',
                type: 'POST',
                data: {
                    userId: currentUserId,
                    '${_csrf.parameterName}': '${_csrf.token}'
                },
                success: function() {
                    deleteModal.hide();
                    location.reload(); // 刷新页面
                },
                error: function(xhr) {
                    alert('删除失败: ' + xhr.responseText);
                    deleteModal.hide();
                }
            });
        });

        // 自动关闭警告消息
        setTimeout(function() {
            $('.alert').alert('close');
        }, 5000);
    });
</script>
</body>
</html>