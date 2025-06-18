package com.itheima.dao;

import com.itheima.domain.Order;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface OrderMapper {
    List<Order> findByUserId(Integer userId);
    int countAll();
    List<Order> findRecent(Integer limit);
    List<Order> findAll();
    int updateStatus(@Param("orderId")String orderId, @Param("status")Integer status);
    int insert(Order order);
    Order findById(String orderId);
    void deleteById(String orderId);
}