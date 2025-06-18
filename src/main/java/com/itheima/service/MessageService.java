package com.itheima.service;

import com.itheima.domain.Message;

import java.util.List;

public interface MessageService {
    // 发送消息
    void sendMessage(Message message);

    // 获取用户消息列表
    List<Message> findMessagesByUserId(Integer userId);
    // 新增方法：获取用户有效消息（过滤已删除的）
    List<Message> findValidMessagesByUserId(Integer userId);
    // 获取消息详情（带权限校验）
    Message getMessageById(Integer messageId, Integer userId);

    // 标记消息为已读
    void markAsRead(Integer messageId);

    // 标记所有消息为已读
    void markAllAsRead(Integer userId);
    // 标记与订单相关的消息为已删除状态
    void markOrderMessagesAsDeleted(String orderId);
    // 删除消息
    void deleteMessage(Integer messageId, Integer userId);
    /**
     * 获取与指定用户的对话历史
     * @param currentUserId 当前用户ID
     * @param otherUserId 对方用户ID
     * @return 消息列表
     */
    List<Message> getConversation(Integer currentUserId, Integer otherUserId);
}