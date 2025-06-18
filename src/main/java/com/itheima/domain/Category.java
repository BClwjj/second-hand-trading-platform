package com.itheima.domain;
import java.util.Date;
import java.util.List;

/**
 * 商品分类表实体类
 * 对应数据库中的category表
 */
public class Category {
    private Integer id;         // 分类ID
    private String name;        // 分类名称
    private String icon;      // FontAwesome图标类名
    private String image;     // 分类封面图
    private Integer parentId; // 父分类ID
    private Integer level;    // 分类层级
    private Integer sort;       // 排序权重
    private Integer status;     // 状态：1-显示, 0-隐藏
    private Date createTime;    // 创建时间
    private List<Goods> goodsList; // 关联商品
    // getters and setters

    public String getImage() {
        return image;
    }

    public void setImage(String image) {
        this.image = image;
    }

    public Integer getParentId() {
        return parentId;
    }

    public void setParentId(Integer parentId) {
        this.parentId = parentId;
    }

    public Integer getLevel() {
        return level;
    }

    public void setLevel(Integer level) {
        this.level = level;
    }

    public List<Goods> getGoodsList() {
        return goodsList;
    }

    public void setGoodsList(List<Goods> goodsList) {
        this.goodsList = goodsList;
    }

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

    public String getIcon() {
        return icon;
    }

    public void setIcon(String icon) {
        this.icon = icon;
    }

    public Integer getSort() {
        return sort;
    }

    public void setSort(Integer sort) {
        this.sort = sort;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public Date getCreateTime() {
        return createTime;
    }

    public void setCreateTime(Date createTime) {
        this.createTime = createTime;
    }
}