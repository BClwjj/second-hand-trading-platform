package com.itheima.service;

import com.itheima.domain.Goods;
import java.util.List;

public interface GoodsService {
    Goods getGoodsById(Integer id);
    void increaseViewCount(Integer goodsId);
    boolean publishGoods(Goods goods);
    Goods publishGoods(Goods goods, List<String> imagePaths);
    List<Goods> searchGoods(String keyword, Integer categoryId, String sort, Integer page, Integer size);
    List<Goods> findGoodsByUserId(Integer userId);
    boolean updateGoods(Goods goods);
    boolean takeDownGoods(Integer goodsId);
    List<Goods> getHotGoods(int limit);
    List<Goods> getNewestGoods(int limit);
    List<Goods> loadGoodsWithImages(List<Goods> goodsList);
    int getGoodsCount();
    List<Goods> getPendingGoods(int limit);
    void updateGoodsStatus(Integer goodsId, Integer status);
    Goods updateGoods(Goods goods, List<String> newImagePaths);
    void changeGoodsStatus(Integer goodsId, Integer status);
    List<Goods> searchGoodsForAdmin(String keyword, Integer status, Integer page, Integer size);  //分页查询方法
    int getPendingGoodsCount();  //统计待审核商品数量
    void deleteGoods(Integer id);

}