document.addEventListener('DOMContentLoaded', function() {
    // 侧边栏折叠/展开
    document.getElementById('menu-toggle').addEventListener('click', function(e) {
        e.preventDefault();
        document.getElementById('wrapper').classList.toggle('toggled');
    });

    // 响应式处理
    if (window.innerWidth < 768) {
        document.getElementById('wrapper').classList.add('toggled');
    }

    window.addEventListener('resize', function() {
        if (window.innerWidth < 768) {
            document.getElementById('wrapper').classList.add('toggled');
        } else {
            document.getElementById('wrapper').classList.remove('toggled');
        }
    });

    // 初始化工具提示
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl);
    });

    // 分类更新按钮事件
    document.querySelectorAll('.update-btn').forEach(function(btn) {
        btn.addEventListener('click', function() {
            var id = this.getAttribute('data-id');
            var name = document.getElementById('name_' + id).value;
            var icon = document.getElementById('icon_' + id).value;
            var sort = document.getElementById('sort_' + id).value;

            document.getElementById('nameInput_' + id).value = name;
            document.getElementById('iconInput_' + id).value = icon;
            document.getElementById('sortInput_' + id).value = sort;

            this.form.submit();
        });
    });
});