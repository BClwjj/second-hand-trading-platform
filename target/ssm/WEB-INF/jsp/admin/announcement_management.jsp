<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>公告管理</title>
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
        .modal-content {
            border-radius: 0.5rem;
        }
        .modal-header {
            border-bottom: 1px solid #e9ecef;
        }
        .modal-footer {
            border-top: 1px solid #e9ecef;
        }
    </style>
</head>
<body>
<div class="container-fluid mt-3">
    <div class="page-header mb-4">
        <h1 class="page-title">公告管理</h1>
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
            <h5 class="mb-0">公告列表</h5>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addAnnouncementModal">
                <i class="fas fa-plus"></i> 添加公告
            </button>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-striped table-hover">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>标题</th>
                        <th>创建时间</th>
                        <th>操作</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${announcements}" var="announcement">
                        <tr>
                            <td>${announcement.id}</td>
                            <td>${announcement.title}</td>
                            <td>
                                <fmt:formatDate value="${announcement.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                            </td>
                            <td>
                                <div class="d-flex">
                                    <!-- 编辑按钮 -->
                                    <button type="button" class="btn btn-info btn-sm me-2"
                                            data-bs-toggle="modal"
                                            data-bs-target="#editAnnouncementModal${announcement.id}">
                                        <i class="fas fa-edit"></i> 编辑
                                    </button>

                                    <!-- 删除按钮 -->
                                    <button type="button" class="btn btn-danger btn-sm"
                                            onclick="showDeleteModal(${announcement.id}, '${announcement.title}')">
                                        <i class="fas fa-trash-alt"></i> 删除
                                    </button>
                                </div>

                                <!-- 编辑公告模态框 -->
                                <div class="modal fade" id="editAnnouncementModal${announcement.id}" tabindex="-1" aria-hidden="true">
                                    <div class="modal-dialog modal-lg">
                                        <div class="modal-content">
                                            <div class="modal-header">
                                                <h5 class="modal-title">编辑公告</h5>
                                                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                                            </div>
                                            <form action="<c:url value='/admin/announcements/edit'/>" method="post">
                                                <input type="hidden" name="id" value="${announcement.id}">
                                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                                <div class="modal-body">
                                                    <div class="mb-3">
                                                        <label class="form-label">公告标题</label>
                                                        <input type="text" class="form-control" name="title" value="${announcement.title}" required>
                                                    </div>
                                                    <div class="mb-3">
                                                        <label class="form-label">公告内容</label>
                                                        <textarea class="form-control" name="content" rows="8" required>${announcement.content}</textarea>
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

<!-- 添加公告模态框 -->
<div class="modal fade" id="addAnnouncementModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">添加公告</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="<c:url value='/admin/announcements/add'/>" method="post">
                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                <div class="modal-body">
                    <div class="mb-3">
                        <label class="form-label">公告标题</label>
                        <input type="text" class="form-control" name="title" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">公告内容</label>
                        <textarea class="form-control" name="content" rows="8" required></textarea>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                    <button type="submit" class="btn btn-primary">添加公告</button>
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
                <p>确定要删除公告 <strong id="deleteAnnouncementName"></strong> 吗？此操作不可恢复！</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">取消</button>
                <form id="deleteAnnouncementForm" method="post">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="id" id="deleteAnnouncementId">
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
    // 删除公告功能
    const deleteModal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));

    function showDeleteModal(announcementId, announcementName) {
        document.getElementById('deleteAnnouncementName').textContent = announcementName;
        document.getElementById('deleteAnnouncementId').value = announcementId;

        const form = document.getElementById('deleteAnnouncementForm');
        form.action = '<c:url value="/admin/announcements/delete"/>';
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