package com.itheima.controller;

import com.itheima.domain.*;
import com.itheima.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Objects;

@Controller
@RequestMapping("/user/center")
public class UserCenterController {
    private static final Logger log = LoggerFactory.getLogger(UserCenterController.class);
    @Autowired
    private UserService userService;
    @Autowired
    private GoodsService goodsService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private FavoriteService favoriteService;
    @Autowired
    private MessageService messageService;
    // 个人中心首页
    @GetMapping
    public String index(HttpSession session, Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        User currentUser = userService.getUserById(user.getUserId());
        List<Goods> myGoods = goodsService.findGoodsByUserId(user.getUserId());
        List<Order> myOrders = orderService.findOrdersByUserId(user.getUserId());

        // 为订单添加商品名称和对方用户名
        if (myOrders != null) {
            myOrders.forEach(order -> {
                // 关键修复：检查订单和商品ID是否为null
                if (order == null) {
                    log.warn("订单列表中存在null元素");
                    return;
                }

                // 处理商品信息
                Integer productId = order.getProductId();
                if (productId == null) {
                    log.error("订单ID:{} 的商品ID为null", order.getOrderId());
                    order.setProductName("商品ID缺失");
                    return;
                }

                Goods product = goodsService.getGoodsById(productId);
                if (product != null) {
                    order.setProductName(product.getName());
                } else {
                    log.error("订单ID:{} 关联的商品ID:{} 不存在", order.getOrderId(), productId);
                    order.setProductName("商品已删除");
                }

                // 处理卖家/买家信息（保持原有修改）
                Integer currentUserId = user.getUserId();
                Integer buyerId = order.getBuyerId();
                Integer sellerId = order.getSellerId();

                if (Objects.equals(currentUserId, buyerId)) {
                    // 当前用户是买家，获取卖家信息
                    if (sellerId != null) {
                        User seller = userService.getUserById(sellerId);
                        if (seller != null) {
                            order.setSellerName(seller.getUsername());
                        } else {
                            log.error("订单ID:{} 卖家ID:{} 不存在", order.getOrderId(), sellerId);
                            order.setSellerName("未知用户");
                        }
                    } else {
                        log.warn("订单ID:{} 卖家ID为null", order.getOrderId());
                        order.setSellerName("未知用户");
                    }
                } else {
                    // 当前用户是卖家，获取买家信息
                    if (buyerId != null) {
                        User buyer = userService.getUserById(buyerId);
                        if (buyer != null) {
                            order.setBuyerName(buyer.getUsername());
                        } else {
                            log.error("订单ID:{} 买家ID:{} 不存在", order.getOrderId(), buyerId);
                            order.setBuyerName("未知用户");
                        }
                    } else {
                        log.warn("订单ID:{} 买家ID为null", order.getOrderId());
                        order.setBuyerName("未知用户");
                    }
                }
            });
        }

        List<Favorite> myFavorites = favoriteService.findFavoritesByUserId(user.getUserId());
        // 获取消息列表时，过滤掉已删除的消息
        List<Message> myMessages = messageService.findValidMessagesByUserId(user.getUserId());
        int unreadCount = 0;
        if (myMessages != null) {
            unreadCount = (int) myMessages.stream()
                    .filter(Objects::nonNull) // 过滤null元素
                    .filter(m -> Objects.equals(m.getStatus(), 0)) // 使用安全比较
                    .count();
        }

        model.addAttribute("user", currentUser);
        model.addAttribute("myGoods", myGoods);
        model.addAttribute("myOrders", myOrders);
        model.addAttribute("myFavorites", myFavorites);
        model.addAttribute("myMessages", myMessages);
        model.addAttribute("unreadCount", unreadCount);

        return "user/center";
    }

    // 更新个人信息
    @PostMapping("/update")
    public String update(User user, HttpSession session,
                         @RequestParam(value = "avatarFile", required = false) MultipartFile avatarFile,
                         RedirectAttributes redirectAttributes) {
        User currentUser = (User) session.getAttribute("user");
        if (currentUser == null) {
            return "redirect:/user/login";
        }

        currentUser.setUsername(user.getUsername());
        currentUser.setEmail(user.getEmail());
        currentUser.setPhone(user.getPhone());
        currentUser.setAddress(user.getAddress());

        if (avatarFile != null && !avatarFile.isEmpty()) {
            try {
                String uploadDir = session.getServletContext().getRealPath("/static/uploads/");
                File dir = new File(uploadDir);
                if (!dir.exists()) {
                    dir.mkdirs();
                }

                String fileName = "avatar_" + currentUser.getUserId() + "_" + System.currentTimeMillis() +
                        avatarFile.getOriginalFilename().substring(avatarFile.getOriginalFilename().lastIndexOf("."));
                String savePath = uploadDir + fileName;

                avatarFile.transferTo(new File(savePath));
                currentUser.setAvatar("/static/uploads/" + fileName);
            } catch (IOException e) {
                e.printStackTrace();
                redirectAttributes.addFlashAttribute("error", "头像上传失败");
                return "redirect:/user/center";
            }
        }

        userService.updateUser(currentUser);
        session.setAttribute("user", currentUser);
        redirectAttributes.addFlashAttribute("success", "个人信息更新成功");

        return "redirect:/user/center";
    }

    // 修改密码
    @PostMapping("/change-password")
    public String changePassword(@RequestParam String oldPassword,
                                 @RequestParam String newPassword,
                                 @RequestParam String confirmNewPassword,
                                 HttpSession session,
                                 RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        if (!newPassword.equals(confirmNewPassword)) {
            redirectAttributes.addFlashAttribute("error", "两次输入的新密码不一致");
            return "redirect:/user/center#password";
        }

        try {
            userService.changePassword(user.getUserId(), oldPassword, newPassword);
            redirectAttributes.addFlashAttribute("success", "密码修改成功，请使用新密码登录");
            return "redirect:/user/logout";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/user/center#password";
        }
    }

    // 移除收藏
    @PostMapping("/favorite/remove")
    @ResponseBody
    public Result removeFavorite(@RequestParam Integer goodsId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        try {
            favoriteService.removeFavorite(user.getUserId(), goodsId);
            return Result.success("已取消收藏");
        } catch (Exception e) {
            return Result.error("取消收藏失败: " + e.getMessage());
        }
    }
}
