package com.itheima.service;

import com.itheima.domain.Favorite;
import java.util.List;

public interface FavoriteService {
    // 添加收藏
    boolean addFavorite(Integer userId, Integer goodsId);

    // 取消收藏
    boolean removeFavorite(Integer userId, Integer goodsId);

    // 切换收藏状态
    boolean toggleFavorite(Integer userId, Integer goodsId);

    // 检查是否收藏
    boolean isFavorite(Integer userId, Integer goodsId);

    // 获取用户收藏列表
    List<Favorite> findFavoritesByUserId(Integer userId);

    // 获取商品被收藏次数
    int getFavoriteCount(Integer goodsId);
}