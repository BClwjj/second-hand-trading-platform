package com.itheima.controller;

import com.itheima.domain.User;
import com.itheima.service.FavoriteService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/favorite")
public class FavoriteController {
    @Autowired
    private FavoriteService favoriteService;

    @PostMapping("/toggle")
    public Map<String, Object> toggleFavorite(@RequestParam Integer goodsId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        try {
            // 先执行切换操作
            favoriteService.toggleFavorite(user.getUserId(), goodsId);
            // 再查询最新状态（关键！）
            boolean isFavorite = favoriteService.isFavorite(user.getUserId(), goodsId);

            result.put("success", true);
            result.put("message", isFavorite ? "已收藏商品" : "已取消收藏");
            result.put("isFavorite", isFavorite); // 返回最新状态
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    @PostMapping("/remove")
    public Map<String, Object> removeFavorite(@RequestParam Integer goodsId, HttpSession session) {
        Map<String, Object> result = new HashMap<>();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            result.put("success", false);
            result.put("message", "请先登录");
            return result;
        }

        try {
            favoriteService.removeFavorite(user.getUserId(), goodsId);
            result.put("success", true);
            result.put("message", "已取消收藏");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "操作失败：" + e.getMessage());
            e.printStackTrace();
        }
        return result;
    }

    @GetMapping("/check")
    public ResponseEntity<Map<String, Object>> checkFavorite(@RequestParam Integer goodsId, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            Map<String, Object> result = new HashMap<>();
            result.put("success", false);
            result.put("message", "请先登录");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(result);
        }

        boolean isFavorite = favoriteService.isFavorite(user.getUserId(), goodsId);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("data", isFavorite);
        return ResponseEntity.ok(result);
    }
}