<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>分类管理</title>
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
        <h1 class="page-title">分类管理</h1>
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
            <h5 class="mb-0">分类列表</h5>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addCategoryModal">
                <i class="fas fa-plus"></i> 添加分类
            </button>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>分类名称</th>
                        <th>排序</th>
                        <th>状态</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${categories}" var="category">
                        <tr>
                            <td>${category.id}</td>
                            <td>${category.name}</td>
                            <td>${category.sort}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${category.status == 1}">
                                        <span class="badge bg-success">显示</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-danger">隐藏</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatDate value="${category.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                            <td>
                                <div class="d-flex">
                                    <!-- 编辑按钮 -->
                                    <button type="button" class="btn btn-info btn-sm me-2"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editCategoryModal${category.id}">
                                        <i class="fas fa-edit"></i> 编辑
                                    </button>

                                    <!-- 状态切换按钮 -->
                                    <form action="<c:url value='/admin/categories/update-status'/>" method="post" class="me-2">
                                        <input type="hidden" name="id" value="${category.id}">
                                        <input type="hidden" name="status" value="${category.status == 1 ? 0 : 1}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="btn ${category.status == 1 ? 'btn-warning' : 'btn-success'} btn-sm">
                                            <i class="fas ${category.status == 1 ? 'fa-eye-slash' : 'fa-eye'}"></i>
                                                ${category.status == 1 ? '隐藏' : '显示'}
                                        </button>
                                    </form>

                                    <!-- 删除按钮 -->
                                    <button type="button" class="btn btn-danger btn-sm"
                                            onclick="showDeleteModal(${category.id}, '${category.name}')">
                                        <i class="fas fa-trash-alt"></i> 删除
                                    </button>
                                </div>

                                <!-- 编辑分类模态框 -->
                                <div class="modal fade" id="editCategoryModal${category.id}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">编辑分类</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <form action="<c:url value='/admin/categories/update'/>" method="post">
                                                <input type="hidden" name="id" value="${category.id}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label">分类名称</label>
                                                        <input type="text" class="form-control" name="name" value="${category.name}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">排序权重</label>
                                                        <input type="number" class="form-control" name="sort" value="${category.sort}">
                                                    </div>
                                                </div>
                                                <div class="modal-footer">
                                                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                                                    <button type="submit" class="btn btn-primary">保存更改</button>
                                                </div>
                                            </form>
                                        </div>
                                    </div>
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

<!-- 添加分类模态框 -->
<div class="modal fade" id="addCategoryModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">添加分类</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<c:url value='/admin/categories/add'/>" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">分类名称</label>
                        <input type="text" class="form-control" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">排序权重</label>
                        <input type="number" class="form-control" name="sort" value="0">
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">添加分类</button>
                </div>
            </form>
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
                <p>确定要删除分类 <strong id="deleteCategoryName"></strong> 吗？此操作不可恢复！</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <form id="deleteCategoryForm" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="id" id="deleteCategoryId">
                    <button type="submit" class="btn btn-danger">确认删除</button>
                </form>
            </div>
        </div>
    </div>
</div>
<!-- 引入必要的JS库 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 删除分类功能
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));

    function showDeleteModal(categoryId, categoryName) {
        document.getElementById('deleteCategoryName').textContent = categoryName;
        document.getElementById('deleteCategoryId').value = categoryId;

        const form = document.getElementById('deleteCategoryForm');
        form.action = '<c:url value="/admin/categories/delete"/>'; // 设置正确的 action
        deleteModal.show();
    }

    // 自动关闭警告消息
    setTimeout(function() {
        const alerts = document.querySelectorAll('.alert');
        alerts.forEach(alert => {
            new bootstrap.Alert(alert).close();
        });
    }, 5000);
</script>
</body>
</html>