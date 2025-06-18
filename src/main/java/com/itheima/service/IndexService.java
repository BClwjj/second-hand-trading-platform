package com.itheima.service;

import com.itheima.domain.Announcement;
import com.itheima.domain.Banner;
import com.itheima.domain.Category;
import com.itheima.domain.Goods;
import java.util.List;

public interface IndexService {
    List<Banner> getActiveBanners();
    List<Category> getAllCategories();
    List<Goods> getHotGoods(int limit);
    List<Goods> getNewGoods(int limit);
    List<Goods> getRecommendGoods(int limit);
    List<Announcement> getLatestAnnouncements(int count);
}