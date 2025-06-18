// goods-detail.js
$(document).ready(function() {
    // 确保jQuery已加载（防御性检查）
    if (typeof $ === 'undefined') {
        console.error('jQuery未正确引入！');
        return;
    }
    // 1. 缩略图点击事件
    initThumbnailClick();

    // 2. 自动激活第一个缩略图
    activateFirstThumbnail();

    // 3. 检查收藏状态
    checkFavoriteStatus();

    // 4. 初始化评分控件
    initRatingStars();

    // 5. 初始化评论表单
    initCommentForm();

    // 6. 初始化删除评论按钮
    initDeleteComment();
});

// 联系卖家（使用window.ctxPath）
function contactSeller(sellerUsername, goodsName, goodsId) {
    if (!checkUserLogin()) return;
    const encodedTitle = encodeURIComponent(`[商品咨询] ${goodsName}`);
    const encodedContent = encodeURIComponent(`商品链接：${window.location.href}`);
    window.location.href = `${window.ctxPath}/message/send?recipientUsername=${encodeURIComponent(sellerUsername)}&title=${encodedTitle}&content=${encodedContent}`;
}

// 立即购买（使用window.ctxPath）
function buyNow(goodsId) {
    if (!checkUserLogin()) return;
    window.location.href = `${window.ctxPath}/order/create/${goodsId}`;
}

// 切换收藏（使用window.ctxPath）
function toggleFavorite(goodsId) {
    if (!checkUserLogin()) return;
    const btn = $('#favoriteBtn');
    btn.prop('disabled', true);
    $.post(`${window.ctxPath}/favorite/toggle`, { goodsId })
        .done((res) => {
            btn.toggleClass('btn-danger btn-outline-danger');
            btn.text(res.isFavorite ? '已收藏' : '收藏');
            showToast(res.message || (res.isFavorite ? '收藏成功' : '取消成功'));
        })
        .fail(handleAjaxError)
        .always(() => {
            btn.prop('disabled', false);
        });
}

// 缩略图切换
function initThumbnailClick() {
    $(document).on('click', '.thumbnail-item', function() {
        const url = $(this).find('img').attr('src');
        $('#mainImage').attr('src', url);
        $('.thumbnail-item').removeClass('active');
        $(this).addClass('active');
    });
}
// 激活首图
function activateFirstThumbnail() {
    setTimeout(function() {
        $('.thumbnail-item:first').trigger('click');
    }, 100);
}

// 检查收藏状态（使用window.ctxPath）
function checkFavoriteStatus() {
    const goodsId = $('#favoriteBtn').data('goods-id');
    $.get(`${window.ctxPath}/favorite/check`, { goodsId })
        .done((res) => {
            if (res.isFavorite) {
                $('#favoriteBtn')
                    .addClass('btn-danger')
                    .removeClass('btn-outline-danger')
                    .text('已收藏');
            }
        })
        .fail(handleAjaxError);
}

// 评分控件初始化
function initRatingStars() {
    $('.rating-star').click(function() {
        const rating = $(this).data('rating');
        $('#ratingValue').val(rating);
        $('.rating-star').each((i, star) => {
            $(star).toggleClass('fas far', $(star).data('rating') <= rating);
        });
    });
    $('.rating-star[data-rating="5"]').trigger('click'); // 默认5星
}

// 评论表单提交（使用window.ctxPath）
function initCommentForm() {
    $('#commentForm').submit((e) => {
        e.preventDefault();
        if (!checkUserLogin()) return;
        const $form = $(this);
        $form.find('button').prop('disabled', true);
        $.ajax({
            type: 'POST',
            url: `${window.ctxPath}/comment/add`,
            data: $form.serialize(),
            success: (res) => {
                if (res.success) {
                    $form.find('textarea').val('');
                    loadComments();
                    showToast('评论提交成功');
                } else {
                    showAlert(res.message || '提交失败', 'error');
                }
            },
            error: handleAjaxError,
            complete: () => {
                $form.find('button').prop('disabled', false);
            }
        });
    });
}

// 删除评论（使用window.ctxPath）
function initDeleteComment() {
    $(document).on('click', '.delete-comment-btn', function() {
        if (!confirm('删除评论？')) return;
        const commentId = $(this).data('comment-id');
        $(this).prop('disabled', true);
        $.post(`${window.ctxPath}/comment/delete/${commentId}`)
            .done((res) => {
                if (res.success) {
                    loadComments();
                    showToast('评论删除成功');
                } else {
                    showAlert(res.message || '删除失败', 'error');
                }
            })
            .fail(handleAjaxError)
            .always(() => {
                $(this).prop('disabled', false);
            });
    });
}

// 加载评论（使用window.ctxPath）
function loadComments() {
    const goodsId = $('#commentForm input[name="goodsId"]').val();
    $.get(`${window.ctxPath}/comment/list/${goodsId}`)
        .done((res) => {
            if (res.success) {
                renderComments(res.comments);
                updateRatingStats(res.avgRating, res.commentCount);
            } else {
                showAlert(res.message || '加载评论失败', 'warning');
            }
        })
        .fail(handleAjaxError);
}

// 渲染评论
function renderComments(comments) {
    let html = '';
    if (!comments || comments.length === 0) {
        html = '<div class="alert alert-info">暂无评论</div>';
    } else {
        comments.forEach((comment) => {
            const user = comment.user || { username: '匿名', avatar: '/static/images/default-avatar.png' };
            const stars = Array.from({ length: 5 }, (_, i) =>
                i < comment.rating ? '<i class="fas fa-star text-warning"></i>' : '<i class="far fa-star text-warning"></i>'
            ).join('');
            html += `
            <div class="card mb-3">
                <div class="card-body d-flex">
                    <img src="${window.ctxPath}${user.avatar}" class="rounded-circle me-3" width="50">
                    <div class="flex-grow-1">
                        <h5>${user.username}</h5>
                        <div class="rating">${stars}</div>
                        <p>${comment.content || ''}</p>
                        <small class="text-muted">${new Date(comment.createTime).toLocaleString()}</small>
                        ${comment.canDelete ? `<button class="btn btn-sm btn-danger delete-comment-btn" data-comment-id="${comment.commentId}">删除</button>` : ''}
                    </div>
                </div>
            </div>
            `;
        });
    }
    $('#commentList').html(html);
}

// 更新评分统计
function updateRatingStats(avgRating, commentCount) {
    $('.average-rating').text(avgRating ? avgRating.toFixed(1) : '0.0');
    $('.comment-count').text(`(${commentCount || 0}条)`);
    const stars = Array.from({ length: 5 }, (_, i) => {
        if (i < Math.floor(avgRating)) return '<i class="fas fa-star text-warning"></i>';
        if (i < avgRating) return '<i class="fas fa-star-half-alt text-warning"></i>';
        return '<i class="far fa-star text-warning"></i>';
    }).join('');
    $('.rating-summary .stars').html(stars || '<span class="text-muted">暂无评分</span>');
}

// 登录检查（使用window.isLoggedIn）
function checkUserLogin() {
    if (!window.isLoggedIn) {
        if (confirm('登录后操作？')) {
            window.location.href = `${window.ctxPath}/user/login?redirect=${encodeURIComponent(window.location.pathname)}`;
        }
        return false;
    }
    return true;
}

// AJAX错误处理
function handleAjaxError(xhr) {
    let msg = '请求失败';
    if (xhr.status === 401) msg = '会话过期，请重新登录';
    else if (xhr.responseJSON?.message) msg = xhr.responseJSON.message;
    showAlert(msg, 'error');
}

// 提示框（依赖Bootstrap）
function showAlert(message, type = 'info') {
    const alertClass = { error: 'alert-danger', warning: 'alert-warning', success: 'alert-success' }[type] || 'alert-info';
    const $alert = $(`
        <div class="alert ${alertClass} alert-dismissible fade show" role="alert">
            ${message}
            <button class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    `);
    $('#commentList').before($alert);
    setTimeout(() => $alert.alert('close'), 3000);
}

function showToast(message) {
    const $toast = $(`
        <div class="toast bg-success text-white" role="alert">
            <div class="toast-body">${message}</div>
            <button class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
        </div>
    `);
    $('body').append('<div id="toastContainer" class="position-fixed top-0 end-0 p-3"></div>');
    $('#toastContainer').append($toast);
    $toast.toast({ autohide: true, delay: 2000 }).toast('show');
}