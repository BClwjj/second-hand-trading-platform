<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>二手优品 - ${param.title}</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/css/font-awesome.min.css" rel="stylesheet">
    <style>
        :root {
            --primary-color: #165DFF;
            --sidebar-bg: #091E42;
            --sidebar-text: rgba(255, 255, 255, 0.8);
            --sidebar-active: #165DFF;
            --card-bg: #ffffff;
            --card-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: #f5f7fa;
        }

        /* 侧边栏样式 */
        .sidebar {
            position: fixed;
            top: 0;
            left: 0;
            bottom: 0;
            width: 240px;
            background-color: var(--sidebar-bg);
            color: var(--sidebar-text);
            z-index: 100;
            padding-top: 20px;
        }

        .sidebar-header {
            padding: 20px;
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
        }

        .sidebar-header h3 {
            margin: 0;
            color: white;
            font-weight: 600;
            display: flex;
            align-items: center;
        }

        .sidebar-header i {
            margin-right: 10px;
            font-size: 24px;
        }
        .sidebar-menu ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }

        .sidebar-menu li {
            margin: 5px 0;
        }

        .sidebar-menu a {
            display: flex;
            align-items: center;
            padding: 12px 20px;
            color: var(--sidebar-text);
            text-decoration: none;
            transition: all 0.2s ease;
            border-radius: 0 24px 24px 0;
        }

        .sidebar-menu a:hover {
            background-color: rgba(255, 255, 255, 0.1);
            color: white;
        }

        .sidebar-menu a.active {
            background-color: var(--sidebar-active);
            color: white;
            font-weight: 500;
        }

        .sidebar-menu i {
            margin-right: 12px;
            width: 20px;
            text-align: center;
        }
        /* 主内容区样式 */
        .main-content {
            margin-left: 240px;
            padding: 20px;
            /*padding-top: 84px;*/
            min-height: 100vh;
        }
        /* 退出按钮样式 */
        .logout-btn {
            position: absolute;
            top: 20px;
            right: 20px;
            padding: 8px 16px;
            background-color: #dc3545;
            color: white;
            border-radius: 4px;
            text-decoration: none;
            transition: background-color 0.3s;
        }
        .logout-btn:hover {
            background-color: #c82333;
        }
        .page-header {
            margin-bottom: 24px;
        }

        .page-title {
            font-size: 24px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }
        .btn-danger {
            background-color: #ff3b30;
            color: white;
            border: none;
        }

        .btn-danger:hover {
            background-color: #e0352b;
        }
        /* 卡片样式 */
        .stat-card {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            padding: 20px;
            margin-bottom: 24px;
        }

        .stat-card-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .stat-card-title {
            font-size: 16px;
            font-weight: 500;
            color: #666;
        }

        .stat-card-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }

        .stat-card-value {
            font-size: 28px;
            font-weight: 600;
            color: #333;
        }

        /* 表格样式 */
        .data-table {
            background-color: var(--card-bg);
            border-radius: 12px;
            box-shadow: var(--card-shadow);
            overflow: hidden;
        }

        .table-header {
            padding: 20px;
            border-bottom: 1px solid #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .table-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .table-responsive {
            overflow-x: auto;
        }

        .data-table table {
            width: 100%;
            border-collapse: collapse;
        }

        .data-table th {
            padding: 16px 20px;
            text-align: left;
            font-weight: 600;
            color: #666;
            background-color: #f5f7fa;
        }

        .data-table td {
            padding: 16px 20px;
            border-bottom: 1px solid #f0f0f0;
            color: #333;
        }

        .badge {
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
            font-weight: 500;
        }

        .badge-success {
            background-color: rgba(52, 199, 89, 0.1);
            color: #34c759;
        }

        .badge-danger {
            background-color: rgba(255, 59, 48, 0.1);
            color: #ff3b30;
        }

        .badge-primary {
            background-color: rgba(22, 93, 255, 0.1);
            color: #165DFF;
        }

        .badge-secondary {
            background-color: rgba(152, 161, 173, 0.1);
            color: #98a1ad;
        }

        .action-btn {
            padding: 6px 12px;
            border-radius: 6px;
            font-size: 14px;
            cursor: pointer;
            transition: all 0.2s ease;
            border: 1px solid #e0e0e0;
            background-color: white;
            color: #666;
        }

        .action-btn:hover {
            background-color: #f5f7fa;
        }

        .action-btn-primary {
            background-color: var(--primary-color);
            color: white;
            border: none;
        }

        .action-btn-primary:hover {
            background-color: #0e4cca;
        }
    </style>
</head>
<body>
<!-- 侧边栏 -->
<div class="sidebar">
    <div class="sidebar-header">
        <h3><i class="fa fa-shopping-bag"></i>二手优品
        </h3>
    </div>
    <div class="sidebar-menu">
        <ul>
            <li>
                <a href="<c:url value='/admin/dashboard'/>" class="${active == 'dashboard' ? 'active' : ''}">
                    <i class="fa fa-tachometer"></i>
                    <span>仪表盘</span>
                </a>
            </li>
            <li>
                <a href="<c:url value='/admin/users'/>" class="${active == 'users' ? 'active' : ''}">
                    <i class="fa fa-users"></i>
                    <span>用户管理</span>
                </a>
            </li>
            <li>
                <a href="<c:url value='/admin/goods'/>" class="${active == 'goods' ? 'active' : ''}">
                    <i class="fa fa-cubes"></i>
                    <span>商品管理</span>
                </a>
            </li>
            <li>
                <a href="<c:url value='/admin/categories'/>" class="${active == 'categories' ? 'active' : ''}">
                    <i class="fa fa-list-alt"></i>
                    <span>分类管理</span>
                </a>
            </li>
            <li>
                <a href="<c:url value='/admin/announcements'/>" class="${active == 'announcements' ? 'active' : ''}">
                    <i class="fa fa-bullhorn"></i>
                    <span>公告管理</span>
                </a>
            </li>
        </ul>
    </div>
</div>


<!-- 主内容区 -->
<div class="main-content">
    <!-- 退出登录按钮 -->
    <a href="<c:url value='/admin/logout'/>" class="logout-btn">
        <i class="fa fa-sign-out"></i> 退出登录
    </a>
    <jsp:include page="${contentPage}.jsp"/>
</div>
<script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>