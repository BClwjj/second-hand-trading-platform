<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
  <title>编辑商品 - 二手交易平台</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/index.css">
  <style>
    .edit-container {
      max-width: 800px;
      margin: 30px auto;
      padding: 20px;
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    }

    .image-preview {
      display: flex;
      flex-wrap: wrap;
      gap: 10px;
      margin-top: 15px;
    }

    .preview-item {
      position: relative;
      width: 120px;
      height: 120px;
      border-radius: 4px;
      overflow: hidden;
    }

    .main-image-label {
      position: absolute;
      bottom: 5px;
      left: 5px;
      background-color: rgba(0, 123, 255, 0.8);
      color: white;
      padding: 2px 5px;
      border-radius: 4px;
      font-size: 12px;
    }
  </style>
</head>
<body>
<!-- 头部 -->
<%@include file="../common/header.jsp"%>
<%--主要内容--%>
<div class="container edit-container">
  <h3 class="text-center mb-4"><i class="fas fa-edit"></i> 编辑商品</h3>

  <c:if test="${not empty error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${error}
      <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
  </c:if>

  <form id="editForm"
        action="${pageContext.request.contextPath}/goods/edit/${goods.id}"
        method="post"
        enctype="multipart/form-data">

    <!-- 基本信息 -->
    <div class="mb-3">
      <label for="name" class="form-label">商品名称</label>
      <input type="text" class="form-control" id="name" name="name" value="${goods.name}" required>
    </div>

    <div class="row mb-3">
      <div class="col-md-6">
        <label for="price" class="form-label">价格</label>
        <div class="input-group">
          <span class="input-group-text">¥</span>
          <input type="number" class="form-control" id="price" name="price" value="${goods.price}" min="0" step="0.01" required>
        </div>
      </div>
      <div class="col-md-6">
        <label for="categoryId" class="form-label">分类</label>
        <select class="form-select" id="categoryId" name="categoryId" required>
          <option value="">请选择分类</option>
          <c:forEach items="${categories}" var="category">
            <option value="${category.id}" ${goods.categoryId == category.id ? 'selected' : ''}>${category.name}</option>
          </c:forEach>
        </select>
      </div>
    </div>

    <div class="mb-3">
      <label for="description" class="form-label">商品描述</label>
      <textarea class="form-control" id="description" name="description" rows="5" required>${goods.description}</textarea>
    </div>

    <!-- 图片编辑 -->
    <!-- 图片编辑 -->
    <div class="mb-3">
      <label class="form-label">商品图片</label>
      <p class="text-muted small">第一张图片将作为主图，最多可上传6张图片</p>

      <!-- 现有图片预览 -->
      <div class="image-preview" id="imagePreview">
        <c:forEach items="${fn:split(goods.images, ',')}" var="image" varStatus="status">
          <div class="preview-item">
            <img src="${pageContext.request.contextPath}${image}" alt="商品图片">
            <c:if test="${status.first}">
              <div class="main-image-label">主图</div>
            </c:if>
            <input type="hidden" name="existingImages" value="${image}">
            <div class="remove-btn" onclick="removeExistingImage(this, '${image}')">
              <i class="fas fa-times"></i>
            </div>
          </div>
        </c:forEach>
      </div>

      <!-- 新主图上传 -->
      <div class="mb-3">
        <label class="form-label">更换主图</label>
        <input type="file" class="form-control" id="mainImage" name="mainImage" accept="image/*">
      </div>

      <!-- 其他图片上传 -->
      <div class="mb-3">
        <label class="form-label">添加更多图片</label>
        <input type="file" class="form-control" id="images" name="images" accept="image/*" multiple>
      </div>
    </div>

    <!-- 操作按钮 -->
    <div class="d-grid gap-2 mt-4">
      <button type="submit" class="btn btn-primary btn-lg">
        <i class="fas fa-save"></i> 保存修改
      </button>

      <!-- 下架/上架按钮（根据状态显示） -->
      <c:if test="${goods.status == 1}">
        <form action="${pageContext.request.contextPath}/goods/off/${goods.id}"
              method="post"
              style="display: inline;">
          <button type="submit"
                  class="btn btn-warning btn-lg"
                  onclick="return confirm('确定要下架该商品吗？')">
            <i class="fas fa-eye-slash"></i> 下架商品
          </button>
        </form>
      </c:if>

      <c:if test="${goods.status == 0}">
        <form action="${pageContext.request.contextPath}/goods/on/${goods.id}"
              method="post"
              style="display: inline;">
          <button type="submit"
                  class="btn btn-success btn-lg"
                  onclick="return confirm('确定要上架该商品吗？')">
            <i class="fas fa-eye"></i> 上架商品
          </button>
        </form>
      </c:if>
    </div>
  </form>
</div>
<!-- 页脚 -->
<%@include file="../common/footer.jsp"%>
<!-- 图片移除逻辑 -->
<script>
  function removeExistingImage(element, imagePath) {
    if (confirm('确定要删除这张图片吗？')) {
      // 添加隐藏字段标记要删除的图片
      const hiddenInput = document.createElement('input');
      hiddenInput.type = 'hidden';
      hiddenInput.name = 'removedImages';
      hiddenInput.value = imagePath;
      document.getElementById('editForm').appendChild(hiddenInput);

      // 移除预览项
      element.closest('.preview-item').remove();
    }
  }
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>