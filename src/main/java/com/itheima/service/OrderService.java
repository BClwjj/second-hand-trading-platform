package com.itheima.service;

import com.itheima.domain.Order;
import java.util.List;

public interface OrderService {
    List<Order> findOrdersByUserId(Integer userId);
    int getOrderCount();
    List<Order> getRecentOrders(int limit);
    List<Order> getAllOrders();
    void updateOrderStatus(String orderId, Integer status);
    void createOrder(Order order);
    Order getOrderById(String orderId);
    // 删除方法
    void deleteOrder(String orderId);
}