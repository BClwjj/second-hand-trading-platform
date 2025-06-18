package com.itheima.service.impl;

import com.itheima.dao.GoodsMapper;
import com.itheima.domain.Goods;
import com.itheima.service.GoodsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.StringUtils;

import javax.servlet.http.HttpSession;
import java.util.*;

@Service
public class GoodsServiceImpl implements GoodsService {

    @Autowired
    private GoodsMapper goodsMapper;

    @Override
    public Goods getGoodsById(Integer id) {
        return goodsMapper.findById(id);
    }

    @Override
    @Transactional
    public void increaseViewCount(Integer goodsId) {
        goodsMapper.increaseViewCount(goodsId);
    }

    @Override
    @Transactional
    public boolean publishGoods(Goods goods) {
        // 设置默认状态为审核中（2），并绑定用户ID（从会话中获取）
        goods.setStatus(2);
        goods.setCreateTime(new Date());
        goods.setUpdateTime(new Date());
        return goodsMapper.insert(goods) > 0;
    }

    @Override
    @Transactional
    public Goods publishGoods(Goods goods, List<String> imagePaths) {
        if (!imagePaths.isEmpty()) {
            goods.setMainImage(imagePaths.get(0)); // 主图为第一张
            goods.setImages(String.join(",", imagePaths)); // 多图拼接
        }
        // 绑定用户ID
        goods.setStatus(2);
        goods.setCreateTime(new Date());
        goods.setUpdateTime(new Date());
        goodsMapper.insert(goods);
        return goods;
    }

    @Override
    public List<Goods> searchGoods(String keyword, Integer categoryId, String sort, Integer page, Integer size) {
        int offset = (page - 1) * size;
        String orderBy = "createTime DESC";
        if ("hot".equals(sort)) orderBy = "viewCount DESC";
        else if ("price_asc".equals(sort)) orderBy = "price ASC";
        else if ("price_desc".equals(sort)) orderBy = "price DESC";
        return goodsMapper.searchGoods(keyword, categoryId, orderBy, offset, size);
    }

    @Override
    public List<Goods> findGoodsByUserId(Integer userId) {
        return goodsMapper.findByUserId(userId);
    }

    @Override
    public boolean updateGoods(Goods goods) {
        goods.setUpdateTime(new Date());
        return goodsMapper.update(goods) > 0;
    }

    @Override
    @Transactional
    public boolean takeDownGoods(Integer goodsId) {
        return goodsMapper.updateStatus(goodsId, 0) > 0; // 0表示下架
    }

    @Override
    public List<Goods> getHotGoods(int limit) {
        return goodsMapper.findHotGoods(limit);
    }

    @Override
    public List<Goods> getNewestGoods(int limit) {
        return goodsMapper.findNewGoods(limit);
    }

    @Override
    public List<Goods> loadGoodsWithImages(List<Goods> goodsList) {
        // 若图片已存储在 goods.images 中，无需额外处理
        return goodsList;
    }

    @Override
    public int getGoodsCount() {
        return goodsMapper.countAll();
    }

    @Override
    public List<Goods> getPendingGoods(int limit) {
        return goodsMapper.findByStatus(2, limit); // 2表示审核中
    }

    @Override
    @Transactional
    public void updateGoodsStatus(Integer goodsId, Integer status) {
        goodsMapper.updateStatus(goodsId, status);
    }

    @Override
    @Transactional
    public Goods updateGoods(Goods goods, List<String> newImagePaths) {
        Goods existing = goodsMapper.findById(goods.getId());
        if (existing == null) throw new RuntimeException("商品不存在");

        // 更新基本信息
        if (StringUtils.hasText(goods.getName())) existing.setName(goods.getName());
        if (goods.getPrice() != null) existing.setPrice(goods.getPrice());
        if (StringUtils.hasText(goods.getDescription())) existing.setDescription(goods.getDescription());
        if (goods.getCategoryId() != null) existing.setCategoryId(goods.getCategoryId());
        existing.setUpdateTime(new Date());

        // 处理图片
        if (!newImagePaths.isEmpty()) {
            existing.setMainImage(newImagePaths.get(0));
            String images = existing.getImages() != null ? existing.getImages() : "";
            images += "," + String.join(",", newImagePaths);
            existing.setImages(images);
        }

        goodsMapper.update(existing);
        return existing;
    }

    @Override
    public void changeGoodsStatus(Integer goodsId, Integer status) {
        Goods goods = goodsMapper.findById(goodsId);
        if (goods == null) throw new RuntimeException("商品不存在");
        goods.setStatus(status);
        goods.setUpdateTime(new Date());
        goodsMapper.update(goods);
    }

    @Override
    public List<Goods> searchGoodsForAdmin(String keyword, Integer status, Integer page, Integer size) {
        int offset = (page - 1) * size;
        return goodsMapper.searchGoodsForAdmin(keyword, status, offset, size);
    }

    @Override
    public int getPendingGoodsCount() {
        return goodsMapper.countByStatus(2);
    }
    @Override
    public void deleteGoods(Integer id) {
        Goods goods = goodsMapper.findById(id);
        if (goods == null) {
            throw new RuntimeException("商品不存在");
        }

        if (goods.getStatus() != 0) {
            throw new RuntimeException("只有下架状态的商品可以删除");
        }
        goodsMapper.deleteById(id);
    }
}