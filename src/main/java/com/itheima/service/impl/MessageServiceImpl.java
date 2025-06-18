package com.itheima.service.impl;

import com.itheima.dao.MessageMapper;
import com.itheima.domain.Message;
import com.itheima.service.MessageService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional
public class MessageServiceImpl implements MessageService {

    @Autowired
    private MessageMapper messageMapper;

    @Override
    public void sendMessage(Message message) {
        messageMapper.insert(message);
    }

    @Override
    public List<Message> findMessagesByUserId(Integer userId) {
        return messageMapper.selectByUserId(userId);
    }

    @Override
    public Message getMessageById(Integer messageId, Integer userId) {
        Message message = messageMapper.selectById(messageId);
        if (message == null || !message.getUserId().equals(userId)) {
            return null; // 消息不存在或无权限查看
        }
        return message;
    }

    @Override
    public void markAsRead(Integer messageId) {
        messageMapper.updateStatus(messageId, 1); // 1表示已读
    }

    @Override
    public void markAllAsRead(Integer userId) {
        messageMapper.updateAllStatus(userId, 1);
    }

    @Override
    public void deleteMessage(Integer messageId, Integer userId) {
        Message message = messageMapper.selectById(messageId);
        if (message == null || !message.getUserId().equals(userId)) {
            throw new IllegalArgumentException("消息不存在或无权限删除");
        }
        messageMapper.deleteById(messageId);
    }
    @Override
    public void markOrderMessagesAsDeleted(String orderId) {
        // 逻辑：将与该订单相关的所有消息标记为已删除（如设置deleted=1）
        messageMapper.markOrderMessagesAsDeleted(orderId);
    }
    @Override
    public List<Message> findValidMessagesByUserId(Integer userId) {
        List<Message> messages = messageMapper.findMessagesByUserId(userId);
        // 过滤掉已删除的消息
        return messages != null ?
                messages.stream().filter(m -> m != null && m.getDeleted() == 0).collect(Collectors.toList()) :
                Collections.emptyList();
    }
    @Override
    public List<Message> getConversation(Integer currentUserId, Integer otherUserId) {
        return messageMapper.getConversation(currentUserId, otherUserId);
    }
}