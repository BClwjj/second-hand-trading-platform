<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>仪表盘</title>
    <!-- 预加载字体 -->
    <link rel="preload" href="https://cdn.jsdelivr.net/npm/font-awesome@4.7.0/fonts/fontawesome-webfont.woff2?v=4.7.0" as="font" type="font/woff2" crossorigin="anonymous">

    <!-- 引入 ECharts CDN -->
    <script src="https://cdn.jsdelivr.net/npm/echarts/dist/echarts.min.js"></script>
    <style>
        /* 保持原有样式不变，新增图表相关样式 */
        .row { margin: 0 -15px; display: flex; flex-wrap: wrap; }
        .col-md-6, .col-lg-3 { padding: 0 15px; box-sizing: border-box; }
        .stat-card {
            background: #fff;
            border: 1px solid #e4e7ed;
            border-radius: 4px;
            padding: 15px;
            margin-bottom: 15px;
            box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
        }
        .stat-card-header { display: flex; justify-content: space-between; align-items: center; }
        .stat-card-title { font-weight: 600; color: #303133; }
        .stat-card-icon {
            width: 36px;
            height: 36px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
        }
        .stat-card-value {
            font-size: 24px;
            font-weight: 600;
            margin-top: 10px;
            color: #303133;
        }

        /* 新增图表容器样式 */
        .chart-container {
            height: 350px;
            margin-top: 20px;
            border: 1px solid #e4e7ed;
            border-radius: 4px;
            padding: 15px;
            box-sizing: border-box;
            box-shadow: 0 2px 12px 0 rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
<div class="page-header">
    <h1 class="page-title">仪表盘</h1>
</div>

<div class="row">
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-card-header">
                <div class="stat-card-title">用户总数</div>
                <div class="stat-card-icon" style="background-color: #165DFF;">
                    <i class="fa fa-users"></i>
                </div>
            </div>
            <div class="stat-card-value">${userCount}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-card-header">
                <div class="stat-card-title">商品总数</div>
                <div class="stat-card-icon" style="background-color: #34c759;">
                    <i class="fa fa-cubes"></i>
                </div>
            </div>
            <div class="stat-card-value">${goodsCount}</div>
        </div>
    </div>
    <div class="col-md-6 col-lg-3">
        <div class="stat-card">
            <div class="stat-card-header">
                <div class="stat-card-title">待审核商品</div>
                <div class="stat-card-icon" style="background-color: #ff9500;">
                    <i class="fa fa-clock-o"></i>
                </div>
            </div>
            <div class="stat-card-value">${pendingGoodsCount}</div>
        </div>
    </div>
</div>

<!-- 新增：图表区域 -->
<div class="row">
    <!-- 1. 近30日新增商品数（折线图） -->
    <div class="col-md-6">
        <div class="chart-container" id="newGoodsChart"></div>
    </div>
    <!-- 2. 商品分类数量占比（饼图） -->
    <div class="col-md-6">
        <div class="chart-container" id="goodsCategoryChart"></div>
    </div>
</div>

<script>
    // ========== 1. 近30日新增商品数（折线图）- 静态数据 ==========
    var newGoodsChart = echarts.init(document.getElementById('newGoodsChart'));

    // 生成近30天日期（格式：YYYY-MM-DD）
    function generateLast30Days() {
        const dates = [];
        for (let i = 29; i >= 0; i--) {
            const date = new Date();
            date.setDate(date.getDate() - i);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');
            dates.push(`${year}-${month}-${day}`);
        }
        return dates;
    }

    // 生成随机数据（10-30之间的整数）
    function generateRandomData(length) {
        return Array.from({length}, () => Math.floor(Math.random() * 21) + 10);
    }

    const dates = generateLast30Days();
    const newGoodsData = generateRandomData(30);

    var newGoodsOption = {
        title: { text: '近30日新增商品数', left: 'center' },
        tooltip: {
            trigger: 'axis',
            formatter: function(params) {
                return `${params[0].name}<br/>新增商品: ${params[0].value}`;
            }
        },
        xAxis: {
            type: 'category',
            data: dates,
            axisLabel: {
                color: '#666',
                fontSize: 10,
                rotate: 45,
                interval: 5 // 每5天显示一个标签
            }
        },
        yAxis: {
            type: 'value',
            name: '新增数量',
            axisLabel: { color: '#666', fontSize: 12 }
        },
        series: [{
            name: '新增商品',
            type: 'line',
            data: newGoodsData,
            smooth: true,
            itemStyle: { color: '#34c759' },
            label: { show: false }, // 不显示每个点的数值
            areaStyle: { // 添加面积图效果
                color: {
                    type: 'linear',
                    x: 0, y: 0, x2: 0, y2: 1,
                    colorStops: [{
                        offset: 0, color: 'rgba(52, 199, 89, 0.4)' // 0% 处的颜色
                    }, {
                        offset: 1, color: 'rgba(52, 199, 89, 0)' // 100% 处的颜色
                    }],
                    global: false // 缺省为 false
                }
            }
        }],
        grid: { left: '5%', right: '5%', bottom: '20%', top: '10%' }
    };
    newGoodsChart.setOption(newGoodsOption);

    // ========== 2. 商品分类数量占比（饼图）- 真实数据 ==========
    var goodsCategoryChart = echarts.init(document.getElementById('goodsCategoryChart'));

    // 使用后端传递的真实数据
    var categoryData = [];
    var totalGoods = 0;

    <c:if test="${not empty categoryGoodsData}">
    <c:forEach items="${categoryGoodsData}" var="category">
    // 确保值有效，无效时设为0
    var count = ${category.goodsCount != null ? category.goodsCount : 0};
    categoryData.push({
        name: '${fn:escapeXml(category.name)}',
        value: count
    });
    totalGoods += count;
    </c:forEach>
    </c:if>

    // 如果没有数据，显示提示
    if (categoryData.length === 0) {
        categoryData = [{ name: '暂无数据', value: 1 }];
        totalGoods = 1;
    }

    var goodsCategoryOption = {
        title: {
            text: '商品分类数量占比',
            subtext: '总计: ' + totalGoods + ' 件',
            left: 'center'
        },
        tooltip: {
            trigger: 'item',
            formatter: function(params) {
                var percent = (params.value / totalGoods * 100).toFixed(1);
                return params.name + ': ' + params.value + ' 件 (' + percent + '%)';
            }
        },
        legend: {
            type: 'scroll',
            orient: 'vertical',
            right: 10,
            top: 20,
            bottom: 20,
            data: categoryData.map(item => item.name)
        },
        series: [{
            name: '商品数量',
            type: 'pie',
            radius: ['40%', '70%'],
            center: ['35%', '50%'],
            data: categoryData,
            label: {
                show: true,
                formatter: function(params) {
                    return params.name + ': ' + params.value + ' 件\n(' + params.percent + '%)';
                },
                color: '#333',
                fontSize: 12
            },
            emphasis: {
                itemStyle: {
                    shadowBlur: 10,
                    shadowOffsetX: 0,
                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                }
            }
        }]
    };
    goodsCategoryChart.setOption(goodsCategoryOption);

    // 响应式调整
    window.addEventListener('resize', function() {
        if (newGoodsChart) newGoodsChart.resize();
        if (goodsCategoryChart) goodsCategoryChart.resize();
    });
</script>
</body>
</html>