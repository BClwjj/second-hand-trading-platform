package com.itheima.service.impl;

import com.itheima.dao.OrderMapper;
import com.itheima.domain.Order;
import com.itheima.service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class OrderServiceImpl implements OrderService {

    @Autowired
    private OrderMapper orderMapper;

    @Override
    @Transactional
    public void createOrder(Order order) {
        orderMapper.insert(order);
    }
    @Override
    public Order getOrderById(String orderId) {
        return orderMapper.findById(orderId);
    }
    @Override
    public List<Order> findOrdersByUserId(Integer userId) {
        return orderMapper.findByUserId(userId);
    }
    @Override
    public int getOrderCount() {
        return orderMapper.countAll();
    }

    @Override
    public List<Order> getRecentOrders(int limit) {
        return orderMapper.findRecent(limit);
    }

    @Override
    public List<Order> getAllOrders() {
        return orderMapper.findAll();
    }

    @Override
    @Transactional
    public void updateOrderStatus(String orderId, Integer status) {
        orderMapper.updateStatus(orderId, status);
    }
    @Override
    public void deleteOrder(String orderId) {
        orderMapper.deleteById(orderId);
    }
}