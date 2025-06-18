package com.itheima.controller;

import com.itheima.domain.Message;
import com.itheima.domain.Result;
import com.itheima.domain.User;
import com.itheima.service.MessageService;
import com.itheima.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;

@Controller
@RequestMapping("/message")
public class MessageController {

    @Autowired
    private MessageService messageService;

    @Autowired
    private UserService userService; // 用户服务，用于查找接收者

    // 显示发送消息页面
    @GetMapping("/send")
    public String showSendMessageForm() {
        return "message/send";
    }

    // 处理发送消息请求
    @PostMapping("/send")
    public String sendMessage(@RequestParam String recipientUsername,
                              @RequestParam String title,
                              @RequestParam String content,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User sender = (User) session.getAttribute("user");
        if (sender == null) {
            return "redirect:/user/login";
        }

        // 查找接收者
        User recipient = userService.findByUsername(recipientUsername);
        if (recipient == null) {
            redirectAttributes.addFlashAttribute("error", "接收者不存在");
            return "redirect:/message/send";
        }

        // 创建消息对象
        Message message = new Message();
        message.setUserId(recipient.getUserId());
        message.setSenderId(sender.getUserId());
        message.setTitle(title);
        message.setContent(content);
        message.setStatus(0); // 0表示未读

        // 发送消息
        messageService.sendMessage(message);

        redirectAttributes.addFlashAttribute("success", "消息发送成功");
        return "redirect:/user/center#myMessages";
    }

    // 显示消息详情
    @GetMapping("/detail/{messageId}")
    public String showMessageDetail(@PathVariable Integer messageId,
                                    HttpSession session,
                                    Model model) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        // 查询消息详情（包含发送者信息）
        Message message = messageService.getMessageById(messageId, user.getUserId());
        if (message == null) {
            return "redirect:/user/center#myMessages";
        }

        // 安全获取发送者用户名
        String senderUsername = "未知用户";
        if (message.getSenderId() != null) {
            User sender = userService.getUserById(message.getSenderId());
            if (sender != null) {
                senderUsername = sender.getUsername();
            }
        }
        message.setSenderUsername(senderUsername);

        // 标记消息为已读
        if (message.getStatus() != null && message.getStatus() == 0) {
            messageService.markAsRead(messageId);
            message.setStatus(1); // 更新内存中的状态，避免刷新页面
        }

        model.addAttribute("message", message);
        return "message/detail";
    }
    // 标记所有消息为已读（AJAX接口）
    @PostMapping("/markAllAsRead")
    @ResponseBody
    public Result markAllAsRead(HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        try {
            messageService.markAllAsRead(user.getUserId());
            return Result.success("所有消息已标记为已读");
        } catch (Exception e) {
            return Result.error("操作失败: " + e.getMessage());
        }
    }

    // 删除消息（AJAX接口）
    @PostMapping("/delete/{messageId}")
    @ResponseBody
    public Result deleteMessage(@PathVariable Integer messageId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return Result.error("请先登录");
        }

        try {
            messageService.deleteMessage(messageId, user.getUserId());
            return Result.success("消息已删除");
        } catch (Exception e) {
            return Result.error("删除失败: " + e.getMessage());
        }
    }
}