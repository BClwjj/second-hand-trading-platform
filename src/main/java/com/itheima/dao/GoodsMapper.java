package com.itheima.dao;

import com.itheima.domain.Goods;
import org.apache.ibatis.annotations.Param;
import java.util.List;

public interface GoodsMapper {
    Goods findById(Integer id);
    void increaseViewCount(Integer goodsId);
    int insert(Goods goods);
    List<Goods> searchGoods(
            @Param("keyword") String keyword,
            @Param("categoryId") Integer categoryId,
            @Param("orderBy") String orderBy,
            @Param("offset") int offset,
            @Param("size") int size);

    List<Goods> findByUserId(Integer userId);
    int update(Goods goods);
    int updateStatus(@Param("goodsId") Integer goodsId, @Param("status") Integer status);
    List<Goods> findHotGoods(int limit);
    List<Goods> findNewGoods(int limit);
    List<Goods> findRecommendGoods(int limit);
    int countAll();
    int countByStatus(Integer status);
    List<Goods> findByStatus(@Param("status") Integer status, @Param("limit") Integer limit);
    List<Goods> findByStatusWithPagination(
            @Param("status") Integer status,
            @Param("offset") int offset,
            @Param("size") int size);

    List<Goods> findAllForAdmin(
            @Param("offset") int offset,
            @Param("size") int size);

    // 管理员搜索商品
    List<Goods> searchGoodsForAdmin(
            @Param("keyword") String keyword,
            @Param("status") Integer status,
            @Param("offset") int offset,
            @Param("size") int size
    );
    //删除商品
    int deleteById(@Param("id") Integer id);
}