package com.itheima.domain;

import java.util.Date;

public class Message {
    private Integer messageId;
    private Integer userId;      // 接收者ID
    private Integer senderId;    // 发送者ID
    private String title;        // 消息标题
    private String content;      // 消息内容
    private Integer status;      // 状态：0-未读，1-已读
    private Integer deleted;     // 0-未删除，1-已删除
    private Date createTime;     // 创建时间

    // 非数据库字段，用于显示发送者用户名
    private String senderUsername;

    // Getters and Setters
    public Integer getMessageId() { return messageId; }
    public void setMessageId(Integer messageId) { this.messageId = messageId; }
    public Integer getUserId() { return userId; }
    public void setUserId(Integer userId) { this.userId = userId; }
    public Integer getSenderId() { return senderId; }
    public void setSenderId(Integer senderId) { this.senderId = senderId; }
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }
    public Integer getStatus() { return status; }
    public void setStatus(Integer status) { this.status = status; }

    public Integer getDeleted() {
        return deleted;
    }

    public void setDeleted(Integer deleted) {
        this.deleted = deleted;
    }

    public Date getCreateTime() { return createTime; }
    public void setCreateTime(Date createTime) { this.createTime = createTime; }
    public String getSenderUsername() { return senderUsername; }
    public void setSenderUsername(String senderUsername) { this.senderUsername = senderUsername; }
}