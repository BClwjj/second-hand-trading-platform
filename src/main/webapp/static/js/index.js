// 初始化轮播图
document.addEventListener('DOMContentLoaded', function() {
    // 轮播图初始化
    const swiper = new Swiper('.swiper-container', {
        loop: true,
        autoplay: {
            delay: 3000,
            disableOnInteraction: false,
        },
        pagination: {
            el: '.swiper-pagination',
            clickable: true,
        },
        navigation: {
            nextEl: '.swiper-button-next',
            prevEl: '.swiper-button-prev',
        },
    });

    // 分类导航悬停效果
    document.querySelectorAll('.category-nav ul li').forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.style.backgroundColor = 'rgba(0, 0, 0, 0.05)';
        });
        item.addEventListener('mouseleave', function() {
            this.style.backgroundColor = 'transparent';
        });
    });

    // 商品项悬停效果
    document.querySelectorAll('.goods-item').forEach(item => {
        item.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
            this.style.boxShadow = '0 5px 15px rgba(0, 0, 0, 0.1)';
        });
        item.addEventListener('mouseleave', function() {
            this.style.transform = 'none';
            this.style.boxShadow = '0 2px 8px rgba(0, 0, 0, 0.05)';
        });
    });
});
// 公告功能
$(function() {
    // 委托绑定点击事件
    $(document).on('click', '.announce-item', function() {
        const title = $(this).data('title');
        const content = $(this).data('content');
        if (!title || !content) {
            alert('公告信息不完整');
            return;
        }
        showAnnounceModal(title, content);
    });

    // 更多公告按钮
    $('#showAllAnnounce').on('click', function() {
        alert('所有公告功能待实现');
    });
});

function showAnnounceModal(title, content) {
    const $backdrop = $('<div class="modal-backdrop"></div>');
    const $modal = $(`
        <div class="announce-modal">
            <h3><i class="fas fa-bullhorn"></i> ${title}</h3>
            <div class="announce-content">${content}</div>
            <div class="announce-footer">
                <button class="close-btn">关闭</button>
            </div>
        </div>
    `);
    $('body').append($backdrop, $modal);

    $modal.css({
        position: 'fixed',
        top: '50%',
        left: '50%',
        transform: 'translate(-50%, -50%)',
        display: 'block',
        width: '90%',
        maxWidth: '600px'
    });

    $backdrop.on('click', () => {
        $modal.remove();
        $backdrop.remove();
    });
    $modal.on('click', '.close-btn', () => {
        $modal.remove();
        $backdrop.remove();
    });
}