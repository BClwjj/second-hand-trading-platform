package com.itheima.domain;

import java.util.Date;

/**
 * 轮播图表实体类
 * 对应数据库中的banner表
 */
public class Banner {
    private Integer id;         // 轮播图ID
    private String title;       // 标题
    private String imageUrl;    // 图片URL
    private String linkUrl;     // 跳转链接
    private Integer sort;       // 排序
    private Integer status;     // 状态(1-显示)
    private Date createTime;    // 创建时间

    // getters and setters
    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getLinkUrl() {
        return linkUrl;
    }

    public void setLinkUrl(String linkUrl) {
        this.linkUrl = linkUrl;
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