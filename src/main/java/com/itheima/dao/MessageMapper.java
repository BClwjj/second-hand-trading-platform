package com.itheima.dao;

import com.itheima.domain.Message;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MessageMapper {
    // 插入消息
    void insert(Message message);

    // 根据用户ID查询消息
    List<Message> selectByUserId(Integer userId);

    // 根据ID查询消息
    Message selectById(Integer messageId);

    // 更新消息状态
    void updateStatus(@Param("messageId")Integer messageId,@Param("status") Integer status);

    // 更新用户所有消息状态
    void updateAllStatus(Integer userId, Integer status);

    // 根据ID删除消息
    void deleteById(Integer messageId);
    // 新增：标记订单相关消息为已删除
    void markOrderMessagesAsDeleted(String orderId);
    // 新增：获取用户有效消息（未删除的）
    List<Message> findMessagesByUserId(Integer userId);
    List<Message> getConversation(@Param("currentUserId") Integer currentUserId,
                                  @Param("otherUserId") Integer otherUserId);
}