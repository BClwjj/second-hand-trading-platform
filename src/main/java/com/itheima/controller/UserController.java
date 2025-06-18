package com.itheima.controller;
import com.itheima.domain.User;
import com.itheima.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
@Controller
@RequestMapping("/user")
public class UserController {
    @Autowired
    private UserService userService;
    // 跳转到登录页面
    @GetMapping("/login")
    public String loginPage(HttpSession session) {
        if (session.getAttribute("user") != null) {
            return "redirect:/";
        }
        return "user/login";
    }
    // 处理登录请求
    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        @RequestParam(required = false) String remember,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {
        try {
            User user = userService.login(username, password);
            session.setAttribute("user", user);

            // 如果是管理员，跳转到后台
            if (user.getRole() == 1) {
                return "redirect:/admin/dashboard";
            }

            // 检查是否有重定向URL
            String redirectUrl = (String) session.getAttribute("redirectUrl");
            if (redirectUrl != null) {
                session.removeAttribute("redirectUrl");
                return "redirect:" + redirectUrl;
            }

            return "redirect:/";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            redirectAttributes.addFlashAttribute("username", username);
            return "redirect:/user/login";
        }
    }
    // 跳转到注册页面
    @GetMapping("/register")
    public String registerPage(Model model, HttpSession session) {
        // 如果已登录，直接跳转到首页
        if (session.getAttribute("user") != null) {
            return "redirect:/";
        }
        return "user/register";
    }

    // 处理注册请求
    @PostMapping("/register")
    public String register(User user,
                           @RequestParam String confirmPassword,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        if (!user.getPassword().equals(confirmPassword)) {
            // 使用RedirectAttributes传递错误信息
            redirectAttributes.addAttribute("error", "两次输入的密码不一致");
            return "redirect:/user/register";
        }

        try {
            userService.register(user);
            session.setAttribute("user", user);
            return "redirect:/";
        } catch (Exception e) {
            redirectAttributes.addAttribute("error", e.getMessage());
            return "redirect:/user/register";
        }
    }

    // 注销登录
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.invalidate();
        return "redirect:/";
    }

    // 检查用户名是否可用
    @GetMapping("/checkUsername")
    public Map<String, Boolean> checkUsername(@RequestParam String username) {
        boolean available = !userService.isUsernameExist(username);
        return Collections.singletonMap("available", available);
    }

    // 检查邮箱是否可用
    @GetMapping("/checkEmail")
    public Map<String, Boolean> checkEmail(@RequestParam String email) {
        boolean available = !userService.isEmailExist(email);
        return Collections.singletonMap("available", available);
    }
}