package com.itheima.service.impl;

import com.itheima.dao.FavoriteMapper;
import com.itheima.domain.Favorite;
import com.itheima.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.Date;
import java.util.List;

@Service
public class FavoriteServiceImpl implements FavoriteService {

    @Autowired
    private FavoriteMapper favoriteMapper;

    @Override
    public boolean addFavorite(Integer userId, Integer goodsId) {
        // 检查是否已收藏
        if (favoriteMapper.findByUserAndGoods(userId, goodsId) != null) {
            return false;
        }

        Favorite favorite = new Favorite();
        favorite.setUserId(userId);
        favorite.setGoodsId(goodsId);
        favorite.setCreateTime(new Date());

        return favoriteMapper.insert(favorite) > 0;
    }

    @Override
    public boolean removeFavorite(Integer userId, Integer goodsId) {
        return favoriteMapper.delete(userId, goodsId) > 0;
    }

    @Override
    public boolean toggleFavorite(Integer userId, Integer goodsId) {
        Favorite favorite = favoriteMapper.findByUserAndGoods(userId, goodsId);
        if (favorite != null) {
            return removeFavorite(userId, goodsId);
        } else {
            return addFavorite(userId, goodsId);
        }
    }

    @Override
    public boolean isFavorite(Integer userId, Integer goodsId) {
        return favoriteMapper.findByUserAndGoods(userId, goodsId) != null;
    }

    @Override
    public List<Favorite> findFavoritesByUserId(Integer userId) {
        return favoriteMapper.findByUserId(userId);
    }

    @Override
    public int getFavoriteCount(Integer goodsId) {
        return favoriteMapper.countByGoodsId(goodsId);
    }
}