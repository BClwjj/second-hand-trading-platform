package com.itheima.controller;

import com.itheima.domain.*;
import com.itheima.service.IndexService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import java.util.List;

@Controller
public class IndexController {

    @Autowired
    private IndexService indexService;

    @GetMapping({"/", "/index"})
    public String index(Model model) {
        // 轮播图
        model.addAttribute("banners", indexService.getActiveBanners());

        // 商品分类
        model.addAttribute("categories", indexService.getAllCategories());

        // 热门商品
        model.addAttribute("hotGoods", indexService.getHotGoods(5));

        // 最新商品
        model.addAttribute("newGoods", indexService.getNewGoods(5));

        // 推荐商品
        model.addAttribute("recommendGoods", indexService.getRecommendGoods(5));
        // 获取最新3条公告
        List<Announcement> announcements = indexService.getLatestAnnouncements(3);
        model.addAttribute("announcements", announcements);
        return "index";
    }
}