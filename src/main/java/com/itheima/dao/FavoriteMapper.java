package com.itheima.dao;

import com.itheima.domain.Favorite;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface FavoriteMapper {
    // 新增收藏
    int insert(Favorite favorite);

    // 删除收藏
    int delete(@Param("userId") Integer userId, @Param("goodsId") Integer goodsId);

    // 查询用户的收藏列表
    List<Favorite> findByUserId(Integer userId);

    // 检查是否已收藏
    Favorite findByUserAndGoods(@Param("userId") Integer userId,
                                @Param("goodsId") Integer goodsId);

    // 统计商品被收藏次数
    int countByGoodsId(Integer goodsId);
}