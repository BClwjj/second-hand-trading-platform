<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
  <title>发布商品 - 二手交易平台</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/static/css/index.css">
  <style>
    .publish-container {
      max-width: 800px;
      margin: 30px auto;
      padding: 20px;
      background-color: white;
      border-radius: 8px;
      box-shadow: 0 0 15px rgba(0, 0, 0, 0.1);
    }

    .image-upload {
      border: 2px dashed #ddd;
      border-radius: 8px;
      padding: 20px;
      text-align: center;
      cursor: pointer;
      margin-bottom: 20px;
    }

    .image-upload:hover {
      border-color: #aaa;
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

    .preview-item img {
      width: 100%;
      height: 100%;
      object-fit: cover;
    }

    .preview-item .remove-btn {
      position: absolute;
      top: 5px;
      right: 5px;
      width: 20px;
      height: 20px;
      background-color: rgba(255, 0, 0, 0.7);
      color: white;
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      cursor: pointer;
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
<div class="container">
  <div class="publish-container">
    <h3 class="text-center mb-4"><i class="fas fa-plus-circle"></i> 发布商品</h3>

    <c:if test="${not empty error}">
      <div class="alert alert-danger alert-dismissible fade show" role="alert">
          ${error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
      </div>
    </c:if>

    <form id="publishForm" action="${pageContext.request.contextPath}/goods/publish" method="post" enctype="multipart/form-data">
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

      <!-- 图片上传 -->
      <div class="mb-3">
        <label class="form-label">商品图片</label>
        <p class="text-muted small">第一张图片将作为主图，最多可上传6张图片</p>

        <div class="image-upload" id="mainImageUpload">
          <i class="fas fa-cloud-upload-alt fa-3x mb-2"></i>
          <p>点击上传主图</p>
          <input type="file" id="mainImage" name="mainImage" accept="image/*" style="display: none;" required>
        </div>

        <div class="image-upload" id="otherImagesUpload">
          <i class="fas fa-images fa-3x mb-2"></i>
          <p>点击上传其他图片</p>
          <input type="file" id="images" name="images" accept="image/*" multiple style="display: none;">
        </div>

        <div class="image-preview" id="imagePreview"></div>
      </div>
      <div class="d-grid gap-2">
        <button type="submit" class="btn btn-primary btn-lg">
          <i class="fas fa-paper-plane"></i> 发布商品
        </button>
      </div>
    </form>
  </div>
</div>
<!-- 引入页脚 -->
<%@include file="../common/footer.jsp"%>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
  // 主图上传
  document.getElementById('mainImageUpload').addEventListener('click', function() {
    document.getElementById('mainImage').click();
  });

  document.getElementById('mainImage').addEventListener('change', function(e) {
    if (e.target.files.length > 0) {
      const file = e.target.files[0];
      const reader = new FileReader();

      reader.onload = function(event) {
        const previewContainer = document.getElementById('imagePreview');
        previewContainer.innerHTML = ''; // 清空预览

        // 创建预览项
        const previewItem = document.createElement('div');
        previewItem.className = 'preview-item';
        previewItem.innerHTML = `
                    <img src="${event.target.result}" alt="主图预览">
                    <div class="main-image-label">主图</div>
                    <div class="remove-btn" onclick="removeImage(this, 'mainImage')">
                        <i class="fas fa-times"></i>
                    </div>
                `;

        previewContainer.appendChild(previewItem);
      };

      reader.readAsDataURL(file);
    }
  });

  // 其他图片上传
  document.getElementById('otherImagesUpload').addEventListener('click', function() {
    document.getElementById('images').click();
  });

  document.getElementById('images').addEventListener('change', function(e) {
    if (e.target.files.length > 0) {
      const previewContainer = document.getElementById('imagePreview');
      const files = e.target.files;

      // 检查图片数量是否超过限制
      const existingCount = previewContainer.querySelectorAll('.preview-item').length;
      if (existingCount + files.length > 6) {
        alert('最多只能上传6张图片');
        return;
      }

      for (let i = 0; i < files.length; i++) {
        const file = files[i];
        const reader = new FileReader();

        reader.onload = function(event) {
          const previewItem = document.createElement('div');
          previewItem.className = 'preview-item';
          previewItem.innerHTML = `
                        <img src="${event.target.result}" alt="图片预览">
                        <div class="remove-btn" onclick="removeImage(this, 'images')">
                            <i class="fas fa-times"></i>
                        </div>
                    `;

          previewContainer.appendChild(previewItem);
        };

        reader.readAsDataURL(file);
      }
    }
  });

  // 移除图片
  function removeImage(element, inputType) {
    const previewItem = element.closest('.preview-item');
    previewItem.remove();

    if (inputType === 'mainImage') {
      document.getElementById('mainImage').value = '';
    }
  }

  // 表单验证
  document.getElementById('publishForm').addEventListener('submit', function(e) {
    const mainImage = document.getElementById('mainImage');
    if (mainImage.files.length === 0) {
      e.preventDefault();
      alert('请上传商品主图');
      return false;
    }

    const price = document.getElementById('price').value;
    if (price <= 0) {
      e.preventDefault();
      alert('价格必须大于0');
      return false;
    }

    return true;
  });
</script>
</body>
</html>