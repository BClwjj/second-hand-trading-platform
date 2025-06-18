package com.itheima.domain;

import java.math.BigDecimal;
import java.util.Date;

public class Goods {
    private Integer id;             // 商品ID
    private String name;            // 商品名称
    private String description;     // 商品描述
    private BigDecimal price;       // 商品价格
    private String mainImage;       // 主图URL
    private String images;          // 商品图片(多图,逗号分隔)
    private Category category;      // 分类对象
    private Integer categoryId;     // 分类ID
    private User seller;            // 卖家信息
    private Integer userId;         // 发布用户ID（与数据库user_id一致）
    private Integer status;         // 状态(1-上架,0-下架,2-审核中)
    private Integer viewCount;      // 浏览量
    private Date createTime;        // 创建时间
    private Date updateTime;        // 更新时间

    // getter 和 setter 方法
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getMainImage() {
        return mainImage;
    }

    public void setMainImage(String mainImage) {
        this.mainImage = mainImage;
    }

    public String getImages() {
        return images;
    }

    public void setImages(String images) {
        this.images = images;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public Integer getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(Integer categoryId) {
        this.categoryId = categoryId;
    }

    public User getSeller() {
        return seller;
    }

    public void setSeller(User seller) {
        this.seller = seller;
    }

    public Integer getUserId() {
        return userId;
    }

    public void setUserId(Integer userId) {
        this.userId = userId;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Integer getViewCount() {
        return viewCount;
    }

    public void setViewCount(Integer viewCount) {
        this.viewCount = viewCount;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }

    public Date getUpdateTime() {
        return updateTime;
    }

    public void setUpdateTime(Date updateTime) {
        this.updateTime = updateTime;
    }

    @Override
    public String toString() {
        return "Goods{" +
                "id=" + id +
                ", name='" + name + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", mainImage='" + mainImage + '\'' +
                ", images='" + images + '\'' +
                ", categoryId=" + categoryId +
                ", userId=" + userId +
                ", seller=" + seller +
                ", status=" + status +
                ", viewCount=" + viewCount +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                '}';
    }
}