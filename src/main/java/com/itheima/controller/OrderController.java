package com.itheima.controller;
import com.itheima.domain.*;
import com.itheima.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.Date;
import java.util.UUID;
@Controller
@RequestMapping("/order")
public class OrderController {
    @Autowired
    private OrderService orderService;
    @Autowired
    private GoodsService goodsService;
    @Autowired
    private UserService userService;
    @Autowired
    private MessageService messageService;
    // 创建订单页面
    @GetMapping("/create/{goodsId}")
    public String createOrderPage(@PathVariable Integer goodsId,
                                  HttpSession session,
                                  Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login?redirect=/order/create/" + goodsId;
        }
        Goods goods = goodsService.getGoodsById(goodsId);
        if (goods == null || goods.getStatus() != 1) {
            return "redirect:/error/404";
        }
        model.addAttribute("goods", goods);
        model.addAttribute("order", new Order());
        return "order/create";
    }

    // 处理订单创建
    @PostMapping("/create")
    public String createOrder(Order order,
                              @RequestParam Integer goodsId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User buyer = (User) session.getAttribute("user");
        if (buyer == null) {
            return "redirect:/user/login";
        }
        Goods goods = goodsService.getGoodsById(goodsId);
        if (goods == null || goods.getStatus() != 1) {
            redirectAttributes.addFlashAttribute("error", "商品不存在或已下架");
            return "redirect:/goods/list";
        }
        try {
            String orderId = generateOrderId();
            order.setOrderId(orderId);
            order.setBuyerId(buyer.getUserId());
            order.setProductId(goodsId);
            order.setSellerId(goods.getSeller().getUserId());
            order.setStatus(0);
            order.setPrice(goods.getPrice());
            order.setCreateTime(new Date());
            order.setUpdateTime(new Date());
            orderService.createOrder(order);
            // 发送卖家通知
            Message sellerMsg = new Message();
            sellerMsg.setUserId(goods.getSeller().getUserId());
            sellerMsg.setSenderId(buyer.getUserId());
            sellerMsg.setTitle("新订单提醒");
            sellerMsg.setContent("买家 " + buyer.getUsername() + " 购买了您的商品：" + goods.getName());
            sellerMsg.setStatus(0);
            sellerMsg.setCreateTime(new Date());
            messageService.sendMessage(sellerMsg);
            redirectAttributes.addFlashAttribute("success", "订单创建成功，等待卖家确认");
            return "redirect:/order/detail/" + orderId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "订单创建失败: " + e.getMessage());
            return "redirect:/order/create/" + goodsId;
        }
    }

    // 订单详情
    @GetMapping("/detail/{orderId}")
    public String orderDetail(@PathVariable String orderId,
                              HttpSession session,
                              Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) return "redirect:/user/login";

        // 获取订单及关联数据
        Order order = orderService.getOrderById(orderId);
        if (order == null ||
                (!order.getBuyerId().equals(user.getUserId()) &&
                        !order.getSellerId().equals(user.getUserId()))) {
            return "redirect:/error/404";
        }

        // 加载关联数据
        Goods product = goodsService.getGoodsById(order.getProductId());
        User seller = userService.getUserById(order.getSellerId());
        User buyer = userService.getUserById(order.getBuyerId());

        // 设置到订单对象中
        order.setProduct(product);
        order.setSeller(seller);
        order.setBuyer(buyer);

        // 关键：将订单添加到模型
        model.addAttribute("order", order);
        return "order/detail";
    }

    // 确认订单
    @PostMapping("/confirm/{orderId}")
    public String confirmOrder(@PathVariable String orderId,
                               HttpSession session,
                               RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        try {
            Order order = orderService.getOrderById(orderId);
            if (order == null || !order.getSellerId().equals(user.getUserId())) {
                return "redirect:/error/404";
            }
            orderService.updateOrderStatus(orderId, 1);

            // 发送买家通知
            Message buyerMsg = new Message();
            buyerMsg.setUserId(order.getBuyerId());
            buyerMsg.setSenderId(user.getUserId());
            buyerMsg.setTitle("订单已确认");
            buyerMsg.setContent("您的订单 " + orderId + " 已被卖家确认");
            buyerMsg.setStatus(0);
            buyerMsg.setCreateTime(new Date());
            messageService.sendMessage(buyerMsg);

            redirectAttributes.addFlashAttribute("success", "订单确认成功");
            return "redirect:/order/detail/" + orderId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "订单确认失败: " + e.getMessage());
            return "redirect:/order/detail/" + orderId;
        }
    }

    // 取消订单
    @PostMapping("/cancel/{orderId}")
    public String cancelOrder(@PathVariable String orderId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }
        try {
            Order order = orderService.getOrderById(orderId);
            if (order == null ||
                    (!order.getBuyerId().equals(user.getUserId()) &&
                            !order.getSellerId().equals(user.getUserId()))) {
                return "redirect:/error/404";
            }
            orderService.updateOrderStatus(orderId, 2);

            // 发送对方通知
            Integer recipientId = order.getBuyerId().equals(user.getUserId())
                    ? order.getSellerId() : order.getBuyerId();
            Message cancelMsg = new Message();
            cancelMsg.setUserId(recipientId);
            cancelMsg.setSenderId(user.getUserId());
            cancelMsg.setTitle("订单已取消");
            cancelMsg.setContent("订单 " + orderId + " 已被" +
                    (order.getBuyerId().equals(user.getUserId()) ? "买家" : "卖家") + "取消");
            cancelMsg.setStatus(0);
            cancelMsg.setCreateTime(new Date());
            messageService.sendMessage(cancelMsg);

            redirectAttributes.addFlashAttribute("success", "订单取消成功");
            return "redirect:/order/detail/" + orderId;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "订单取消失败: " + e.getMessage());
            return "redirect:/order/detail/" + orderId;
        }
    }
    // 订单删除
    @PostMapping("/delete/{orderId}")
    public String deleteOrder(@PathVariable String orderId,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        try {
            Order order = orderService.getOrderById(orderId);
            if (order == null ||
                    !order.getBuyerId().equals(user.getUserId()) &&
                            !order.getSellerId().equals(user.getUserId())) {
                return "redirect:/error/404";
            }

            // 只有待确认或已取消的订单可删除
            if (order.getStatus() != 1 && order.getStatus() != 2) {
                redirectAttributes.addFlashAttribute("error", "仅允许删除已完成或已取消的订单");
                return "redirect:/order/detail/" + orderId;
            }
// 删除订单前，先删除或标记关联的消息
            messageService.markOrderMessagesAsDeleted(orderId);
            orderService.deleteOrder(orderId); // 调用删除服务

            // 发送消息通知对方
            Integer recipientId = order.getBuyerId().equals(user.getUserId())
                    ? order.getSellerId() : order.getBuyerId();
            Message message = new Message();
            message.setUserId(recipientId);
            message.setSenderId(user.getUserId());
            message.setTitle("订单已删除");
            message.setContent("订单 " + orderId + " 已被删除");
            message.setCreateTime(new Date());
            messageService.sendMessage(message);

            redirectAttributes.addFlashAttribute("success", "订单删除成功");
            return "redirect:/user/center#myOrders";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "订单删除失败: " + e.getMessage());
            return "redirect:/order/detail/" + orderId;
        }
    }
    // 生成订单ID
    private String generateOrderId() {
        return UUID.randomUUID().toString().replace("-", "").substring(0, 16);
    }
}