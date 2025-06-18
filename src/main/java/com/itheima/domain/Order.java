package com.itheima.domain;

import java.math.BigDecimal;
import java.util.Date;

/**
 * 订单实体类
 */
public class Order {
    private String orderId;         // 订单ID
    private Integer buyerId;        // 买家ID
    private String buyerName;       // 买家用户名（非数据库字段）
    private Integer productId;      // 商品ID
    private String productName;     // 商品名称（非数据库字段）
    private Integer sellerId;       // 卖家ID
    private String sellerName;      // 卖家用户名（非数据库字段）
    private Integer status;         // 订单状态(0-待确认,1-已完成,2-已取消)
    private BigDecimal price;       // 成交价格
    private String buyerMessage;    // 买家留言
    private String tradeMethod;     // 交易方式
    private Date createTime;        // 创建时间
    private Date updateTime;        // 更新时间

    // 关联字段
    private Goods product;  // 商品信息
    private User buyer;     // 买家信息
    private User seller;    // 卖家信息
    // 无参构造方法
    public Order() {
    }

    // 带参构造方法
    public Order(String orderId, Integer buyerId, Integer productId, Integer sellerId,
                 Integer status, BigDecimal price) {
        this.orderId = orderId;
        this.buyerId = buyerId;
        this.productId = productId;
        this.sellerId = sellerId;
        this.status = status;
        this.price = price;
    }

    // getter 和 setter 方法
    public String getOrderId() {
        return orderId;
    }

    public void setOrderId(String orderId) {
        this.orderId = orderId;
    }

    public Integer getBuyerId() {
        return buyerId;
    }

    public void setBuyerId(Integer buyerId) {
        this.buyerId = buyerId;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public Integer getProductId() {
        return productId;
    }

    public void setProductId(Integer productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public Integer getSellerId() {
        return sellerId;
    }

    public void setSellerId(Integer sellerId) {
        this.sellerId = sellerId;
    }

    public String getSellerName() {
        return sellerName;
    }

    public void setSellerName(String sellerName) {
        this.sellerName = sellerName;
    }

    public Integer getStatus() {
        return status;
    }

    public void setStatus(Integer status) {
        this.status = status;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public String getBuyerMessage() {
        return buyerMessage;
    }

    public void setBuyerMessage(String buyerMessage) {
        this.buyerMessage = buyerMessage;
    }

    public String getTradeMethod() {
        return tradeMethod;
    }

    public void setTradeMethod(String tradeMethod) {
        this.tradeMethod = tradeMethod;
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

    public Goods getProduct() {
        return product;
    }

    public void setProduct(Goods product) {
        this.product = product;
    }

    public User getBuyer() {
        return buyer;
    }

    public void setBuyer(User buyer) {
        this.buyer = buyer;
    }

    public User getSeller() {
        return seller;
    }

    public void setSeller(User seller) {
        this.seller = seller;
    }

    // 获取状态文本
    public String getStatusText() {
        switch (status) {
            case 0: return "待确认";
            case 1: return "已完成";
            case 2: return "已取消";
            default: return "未知状态";
        }
    }

    @Override
    public String toString() {
        return "Order{" +
                "orderId='" + orderId + '\'' +
                ", buyerId=" + buyerId +
                ", buyerName='" + buyerName + '\'' +
                ", productId=" + productId +
                ", productName='" + productName + '\'' +
                ", sellerId=" + sellerId +
                ", sellerName='" + sellerName + '\'' +
                ", status=" + status +
                ", price=" + price +
                ", buyerMessage='" + buyerMessage + '\'' +
                ", tradeMethod='" + tradeMethod + '\'' +
                ", createTime=" + createTime +
                ", updateTime=" + updateTime +
                ", product=" + product +
                ", buyer=" + buyer +
                ", seller=" + seller +
                '}';
    }
}