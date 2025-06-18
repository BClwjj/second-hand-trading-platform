<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<html>
<head>
    <title>消息详情</title>
    <link href="${pageContext.request.contextPath}/static/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .container {
            max-width: 800px;
        }
        .message-header {
            border-bottom: 1px solid #eee;
            padding-bottom: 15px;
            margin-bottom: 20px;
        }
        .message-sender {
            font-weight: bold;
            color: #0d6efd;
        }
        .message-time {
            font-size: 0.9em;
            color: #6c757d;
        }
        .message-content {
            line-height: 1.8;
            min-height: 150px;
            padding: 15px;
            background-color: #f8f9fa;
            border-radius: 5px;
        }
    </style>
</head>
<body>
<%@include file="../common/header.jsp"%>

<div class="container mt-5">
    <div class="card">
        <div class="card-header bg-primary text-white">
            <h4>${message.title}</h4>
        </div>
        <div class="card-body">
            <div class="message-header">
                <div class="message-sender">
                    <i class="fas fa-user-circle me-2"></i>
                    发件人：${message.senderUsername}
                </div>
                <div class="message-time">
                    <i class="fas fa-clock me-2"></i>
                    发送时间：<fmt:formatDate value="${message.createTime}" pattern="yyyy-MM-dd HH:mm:ss"/>
                </div>
                <div class="mt-2">
                    <span class="badge ${message.status == 0 ? 'bg-danger' : 'bg-secondary'}">
                        ${message.status == 0 ? '未读' : '已读'}
                    </span>
                </div>
            </div>

            <div class="message-content">
                ${message.content}
            </div>

            <div class="mt-4 d-flex justify-content-end">
                <c:if test="${message.status == 0}">
                    <button type="button" class="btn btn-sm btn-primary me-2"
                            onclick="markAsRead(${message.messageId})">
                        <i class="fas fa-envelope-open"></i> 标记为已读
                    </button>
                </c:if>
                <button type="button" class="btn btn-sm btn-danger me-2"
                        onclick="deleteMessage(${message.messageId})">
                    <i class="fas fa-trash"></i> 删除消息
                </button>
                <a href="javascript:void(0);"
                   class="btn btn-sm btn-secondary me-2"
                   data-recipient="${message.senderUsername}"
                   data-title="${message.title}"
                   data-content="${message.content}"
                   id="replyBtn">
                    <i class="fas fa-reply"></i> 回复
                </a>
                <a href="${pageContext.request.contextPath}/user/center#myMessages"
                   class="btn btn-sm btn-outline-secondary">
                    返回消息列表
                </a>
            </div>
        </div>
    </div>
</div>

<%@include file="../common/footer.jsp"%>

<!-- 修正JavaScript库加载顺序 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // 使用DOM加载完成事件
    $(document).ready(function() {
        // 使用事件委托绑定回复按钮事件
        $('#replyBtn').on('click', function() {
            try {
                // 从data属性获取参数，避免引号问题
                const recipient = $(this).data('recipient');
                let title = $(this).data('title');
                let content = $(this).data('content');

                // 处理标题：添加"回复："前缀，避免重复
                let newTitle = "回复：" + title.replace(/^回复：/, '');

                // 处理内容：添加原消息前缀
                let newContent = "【原消息】" + content;

                // 构建URL
                const baseUrl = '${pageContext.request.contextPath}/message/send';
                const params = new URLSearchParams();
                params.append('recipientUsername', recipient);
                params.append('title', newTitle);
                params.append('content', newContent);

                window.location.href = baseUrl + '?' + params.toString();
            } catch (error) {
                console.error("回复消息时出错:", error);
                alert("回复消息失败: " + error.message);
            }
        });
    });

    // 标记消息为已读
    function markAsRead(messageId) {
        if (confirm('确定要标记为已读吗？')) {
            $.post('${pageContext.request.contextPath}/message/markAllAsRead', {
                messageId: messageId
            })
                .done(function(result) {
                    if (result.success) {
                        alert('标记成功');
                        location.reload();
                    } else {
                        alert('错误：' + result.message);
                    }
                })
                .fail(function() {
                    alert('网络请求失败');
                });
        }
    }

    // 删除消息
    function deleteMessage(messageId) {
        if (confirm('确定要删除这条消息吗？')) {
            $.post('${pageContext.request.contextPath}/message/delete/' + messageId)
                .done(function(result) {
                    if (result.success) {
                        alert('删除成功');
                        location.href = '${pageContext.request.contextPath}/user/center#myMessages';
                    } else {
                        alert('错误：' + result.message);
                    }
                })
                .fail(function() {
                    alert('网络请求失败');
                });
        }
    }
</script>
</body>
</html>