package com.itheima.service.impl;

import com.itheima.dao.AnnouncementMapper;
import com.itheima.dao.BannerMapper;
import com.itheima.dao.CategoryMapper;
import com.itheima.dao.GoodsMapper;
import com.itheima.domain.Banner;
import com.itheima.domain.Category;
import com.itheima.domain.Goods;
import com.itheima.domain.Announcement;
import com.itheima.service.IndexService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class IndexServiceImpl implements IndexService {

    @Autowired
    private BannerMapper bannerMapper;
    @Autowired
    private CategoryMapper categoryMapper;
    @Autowired
    private GoodsMapper goodsMapper;
    @Autowired
    private AnnouncementMapper announcementMapper;

    @Override
    public List<Banner> getActiveBanners() {
        return bannerMapper.findActiveBanners(); // 假设 Banner 表无问题，无需修改
    }

    @Override
    public List<Category> getAllCategories() {
        return categoryMapper.findAll(); // 分类表无关联用户，无需修改
    }

    @Override
    public List<Goods> getHotGoods(int limit) {
        return goodsMapper.findHotGoods(limit); // 依赖 GoodsMapper 的正确 SQL
    }

    @Override
    public List<Goods> getNewGoods(int limit) {
        return goodsMapper.findNewGoods(limit); // 依赖 GoodsMapper 的正确 SQL
    }

    @Override
    public List<Goods> getRecommendGoods(int limit) {
        return goodsMapper.findRecommendGoods(limit); // 依赖 GoodsMapper 的正确 SQL
    }
    @Override
    public List<Announcement> getLatestAnnouncements(int count) {
        return announcementMapper.selectLatestAnnouncements(count);
    }
}