package com.itheima.domain;

import java.util.Date;

public class Favorite {
    private Integer favoriteId;  // 收藏ID
    private Integer userId;     // 用户ID
    private Integer goodsId;    // 商品ID
    private Date createTime;    // 创建时间

    // 关联对象（非数据库字段）
    private Goods goods;        // 关联的商品信息
    private User user;          // 关联的用户信息

    // getter & setter
    public Integer getFavoriteId() { return favoriteId; }
    public void setFavoriteId(Integer favoriteId) { this.favoriteId = favoriteId; }

    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }

    public Integer getGoodsId() { return goodsId; }
    public void setGoodsId(Integer goodsId) { this.goodsId = goodsId; }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }

    public Goods getGoods() { return goods; }
    public void setGoods(Goods goods) { this.goods = goods; }

    public User getUser() { return user; }
    public void setUser(User user) { this.user = user; }
}