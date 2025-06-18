package com.itheima.controller;

import com.itheima.domain.*;
import com.itheima.service.CategoryService;
import com.itheima.service.GoodsService;
import org.springframework.util.StringUtils;
import org.springframework.beans.BeanUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/goods")
public class GoodsController {

    @Autowired
    private GoodsService goodsService;
    @Autowired
    private CategoryService categoryService;

    // 商品详情页
    @GetMapping("/detail/{id}")
    public String goodsDetail(@PathVariable("id") Integer id, Model model, HttpSession session,
                              @RequestParam(required = false) Boolean comment) {
        Goods goods = goodsService.getGoodsById(id);
        if (goods == null) {
            return "redirect:/error/404";
        }

        // 增加浏览量
        goodsService.increaseViewCount(id);

        // 获取商品所有图片
        List<String> imageList = Collections.emptyList();
        if (goods.getImages() != null && !goods.getImages().trim().isEmpty()) {
            imageList = Arrays.stream(goods.getImages().split(","))
                    .filter(StringUtils::hasText)
                    .collect(Collectors.toList());
        }

        model.addAttribute("imageList", imageList);
        model.addAttribute("goods", goods);
        return "goods/detail";
    }

    // 发布商品页面
    @GetMapping("/publish")
    public String publishPage(Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login?redirect=/goods/publish";
        }

        model.addAttribute("goods", new Goods());
        model.addAttribute("categories", categoryService.getAllCategories());
        return "goods/publish";
    }

    // 处理商品发布
    @PostMapping("/publish")
    public String publishGoods(
            @ModelAttribute GoodsDTO goodsDTO,
            @RequestParam("mainImage") MultipartFile mainImage,
            @RequestParam(value = "images", required = false) MultipartFile[] images,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        Goods goods = new Goods();
        BeanUtils.copyProperties(goodsDTO, goods);

        try {
            // 获取当前登录用户ID
            User user = (User) session.getAttribute("user");
            if (user == null) {
                throw new RuntimeException("请先登录");
            }
            goods.setUserId(user.getUserId()); // 设置用户ID

            // 处理图片上传
            List<String> imagePaths = new ArrayList<>();

            // 上传主图
            if (!mainImage.isEmpty()) {
                String mainImagePath = uploadImage(mainImage, session);
                imagePaths.add(mainImagePath);
            }

            // 上传其他图片
            if (images != null) {
                for (MultipartFile image : images) {
                    if (!image.isEmpty() && imagePaths.size() < 6) {
                        String path = uploadImage(image, session);
                        imagePaths.add(path);
                    }
                }
            }

            // 发布商品
            Goods savedGoods = goodsService.publishGoods(goods, imagePaths);

            redirectAttributes.addFlashAttribute("success", "商品发布成功，等待审核");
            return "redirect:/goods/detail/" + savedGoods.getId();
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "商品发布失败: " + e.getMessage());
            return "redirect:/goods/publish";
        }
    }

    // 商品列表页
    @GetMapping("/list")
    public String listGoods(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer categoryId,
            @RequestParam(required = false, defaultValue = "new") String sort,
            @RequestParam(required = false, defaultValue = "1") Integer page,
            @RequestParam(required = false, defaultValue = "9") Integer size,
            Model model) {

        // 获取商品列表
        List<Goods> goodsList = goodsService.searchGoods(keyword, categoryId, sort, page, size);

        // 获取所有分类
        List<Category> categories = categoryService.getAllCategories();

        // 获取当前分类信息
        Category currentCategory = null;
        if (categoryId != null) {
            currentCategory = categoryService.getCategoryById(categoryId);
        }

        // 加载商品图片
        goodsList = goodsService.loadGoodsWithImages(goodsList);

        model.addAttribute("goodsList", goodsList);
        model.addAttribute("categories", categories);
        model.addAttribute("currentCategory", currentCategory);
        model.addAttribute("keyword", keyword);
        model.addAttribute("categoryId", categoryId);
        model.addAttribute("sort", sort);
        model.addAttribute("page", page);
        model.addAttribute("size", size);

        return "goods/list";
    }

    // 编辑商品页面
    @GetMapping("/edit/{id}")
    public String editPage(@PathVariable("id") Integer id, Model model, HttpSession session) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Goods goods = goodsService.getGoodsById(id);
        if (goods == null || !goods.getUserId().equals(user.getUserId())) { // 修正：使用userId比较
            return "redirect:/error/403";
        }

        model.addAttribute("goods", goods);
        model.addAttribute("categories", categoryService.getAllCategories());

        // 获取商品所有图片
        List<String> imageList = Collections.emptyList();
        if (goods.getImages() != null && !goods.getImages().trim().isEmpty()) {
            imageList = Arrays.stream(goods.getImages().split(","))
                    .filter(StringUtils::hasText)
                    .collect(Collectors.toList());
        }

        model.addAttribute("imageList", imageList);
        return "goods/edit";
    }

    // 处理商品编辑
    @PostMapping("/edit/{id}")
    public String editGoods(
            @PathVariable("id") Integer id,
            @ModelAttribute GoodsDTO goodsDTO,
            @RequestParam(value = "mainImage", required = false) MultipartFile mainImage,
            @RequestParam(value = "images", required = false) MultipartFile[] images,
            HttpSession session,
            RedirectAttributes redirectAttributes) {

        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Goods existingGoods = goodsService.getGoodsById(id);
        if (existingGoods == null || !existingGoods.getUserId().equals(user.getUserId())) { // 修正：使用userId比较
            return "redirect:/error/403";
        }

        try {
            // 更新商品信息
            BeanUtils.copyProperties(goodsDTO, existingGoods);
            existingGoods.setUpdateTime(new Date());

            // 处理主图上传
            if (mainImage != null && !mainImage.isEmpty()) {
                String mainImagePath = uploadImage(mainImage, session);
                existingGoods.setMainImage(mainImagePath);
            }

            // 处理其他图片上传
            List<String> imagePaths = new ArrayList<>();
            if (images != null) {
                for (MultipartFile image : images) {
                    if (!image.isEmpty()) {
                        String path = uploadImage(image, session);
                        imagePaths.add(path);
                    }
                }
            }

            // 保存更新
            goodsService.updateGoods(existingGoods, imagePaths);

            redirectAttributes.addFlashAttribute("success", "商品更新成功");
            return "redirect:/goods/detail/" + id;
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "商品更新失败: " + e.getMessage());
            return "redirect:/goods/edit/" + id;
        }
    }

    // 下架商品
    @PostMapping("/off/{id}")
    public String offGoods(@PathVariable("id") Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Goods goods = goodsService.getGoodsById(id);
        if (goods == null || !goods.getUserId().equals(user.getUserId())) { // 修正：使用userId比较
            return "redirect:/error/403";
        }

        goodsService.changeGoodsStatus(id, 0); // 0表示下架
        redirectAttributes.addFlashAttribute("success", "商品已下架");
        return "redirect:/user/center#goods-tab";
    }

    // 上架商品
    @PostMapping("/on/{id}")
    public String onGoods(@PathVariable("id") Integer id, HttpSession session, RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Goods goods = goodsService.getGoodsById(id);
        if (goods == null || !goods.getUserId().equals(user.getUserId())) { // 修正：使用userId比较
            return "redirect:/error/403";
        }

        goodsService.changeGoodsStatus(id, 1); // 1表示上架
        redirectAttributes.addFlashAttribute("success", "商品已上架");
        return "redirect:/user/center#goods-tab";
    }

    // 删除商品
    // GoodsController.java 中修改删除方法

    // 删除商品
    @PostMapping("/delete/{id}")
    public String deleteGoods(@PathVariable("id") Integer id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        User user = (User) session.getAttribute("user");
        if (user == null) {
            return "redirect:/user/login";
        }

        Goods goods = goodsService.getGoodsById(id);
        if (goods == null) {
            redirectAttributes.addFlashAttribute("error", "商品不存在");
            return "redirect:/user/center#goods-tab";
        }

        // 检查商品状态是否为下架(0)
        if (goods.getStatus() != 0) {
            redirectAttributes.addFlashAttribute("error", "只有下架状态的商品可以删除");
            return "redirect:/user/center#goods-tab";
        }

        // 普通用户只能删除自己的商品，管理员可以删除任何商品
        if (!goods.getUserId().equals(user.getUserId()) && user.getRole() != 1) {
            return "redirect:/error/403";
        }

        try {
            goodsService.deleteGoods(id);
            redirectAttributes.addFlashAttribute("success", "商品删除成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "商品删除失败: " + e.getMessage());
        }

        return "redirect:/user/center#goods-tab";
    }
    // 统一的图片上传方法
    private String uploadImage(MultipartFile file, HttpSession session) throws IOException {
        if (file.isEmpty()) {
            throw new RuntimeException("上传文件不能为空");
        }

        // 生成文件名
        String originalFilename = file.getOriginalFilename();
        String fileExtension = originalFilename.substring(originalFilename.lastIndexOf("."));
        String fileName = "goods_" + System.currentTimeMillis() + fileExtension;

        // 设置保存路径
        String uploadDir = "/static/uploads/goods/";
        String realPath = session.getServletContext().getRealPath(uploadDir);

        // 创建目录
        File dir = new File(realPath);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // 保存文件
        String filePath = realPath + fileName;
        file.transferTo(new File(filePath));

        // 返回访问路径
        return uploadDir + fileName;
    }

}