package com.itheima.controller;

import com.itheima.domain.*;
import com.itheima.service.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private UserService userService;
    @Autowired
    private GoodsService goodsService;
    @Autowired
    private OrderService orderService;
    @Autowired
    private CategoryService categoryService;
    @Autowired
    private AnnouncementService announcementService;

    @GetMapping("/login")
    public String loginPage() {
        return "admin/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String username,
                        @RequestParam String password,
                        HttpSession session,
                        RedirectAttributes redirectAttributes) {
        try {
            User admin = userService.login(username, password);

            if (admin.getRole() != 1) {
                throw new RuntimeException("您不是管理员，无法登录后台");
            }

            session.setAttribute("admin", admin);
            return "redirect:/admin/dashboard";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", e.getMessage());
            return "redirect:/admin/login";
        }
    }

    // 退出登录
    @GetMapping("/logout")
    public String logout(HttpSession session) {
        session.removeAttribute("admin");
        return "redirect:/admin/login";
    }

    // 仪表盘
    @GetMapping("/dashboard")
    public String dashboard(Model model) {
        int userCount = userService.getUserCount();
        model.addAttribute("userCount", userCount);
        model.addAttribute("pendingGoodsCount", goodsService.getPendingGoodsCount());
        model.addAttribute("goodsCount", goodsService.getGoodsCount());
        // 新增：获取分类商品数量数据
        List<Map<String, Object>> categoryGoodsData = categoryService.findCategoryWithGoodsCount();
        model.addAttribute("categoryGoodsData", categoryGoodsData);
        // 传递内容页和激活项参数到模型
        model.addAttribute("contentPage", "dashboard");
        model.addAttribute("active", "dashboard");

        return "admin/wrapper"; // 仅返回视图名，不拼接参数
    }

    // 用户管理页面
    @GetMapping("/users")
    public String userManagement(Model model, @RequestParam(required = false) String keyword) {
        List<User> users;
        if (keyword != null && !keyword.isEmpty()) {
            users = userService.searchUsers(keyword);
        } else {
            users = userService.getAllUsers();
        }
        model.addAttribute("users", users);

        // 传递内容页和激活项参数到模型
        model.addAttribute("contentPage", "user_management");
        model.addAttribute("active", "users");

        return "admin/wrapper"; // 仅返回视图名，不拼接参数
    }

    // 更新用户状态
    @PostMapping("/users/update-status")
    public String updateUserStatus(@RequestParam Integer userId,
                                   @RequestParam Integer status,
                                   RedirectAttributes redirectAttributes) {
        try {
            userService.updateUserStatus(userId, status);
            redirectAttributes.addFlashAttribute("success", "用户状态更新成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "用户状态更新失败: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    // 设置/取消管理员
    @PostMapping("/users/update-role")
    public String updateUserRole(@RequestParam Integer userId,
                                 @RequestParam Integer role,
                                 RedirectAttributes redirectAttributes) {
        try {
            User user = userService.getUserById(userId);
            if (user != null) {
                user.setRole(role);
                userService.updateUser(user);
                redirectAttributes.addFlashAttribute("success", "用户权限更新成功");
            } else {
                redirectAttributes.addFlashAttribute("error", "用户不存在");
            }
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "用户权限更新失败: " + e.getMessage());
        }
        return "redirect:/admin/users";
    }

    //删除用户
    @PostMapping("/users/delete")
    @ResponseBody
    public ResponseEntity<?> deleteUser(
            @RequestParam Integer userId,
            HttpSession session) {

        try {
            userService.deleteUser(userId);
            session.setAttribute("success", "用户删除成功");
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("删除失败: " + e.getMessage());
        }
    }

    // 分类管理页面
    @GetMapping("/categories")
    public String categoryManagement(Model model) {
        List<Category> categories = categoryService.getAllCategories();
        model.addAttribute("categories", categories);
        model.addAttribute("contentPage", "category_management");
        model.addAttribute("active", "categories");
        return "admin/layout";
    }

    // 添加分类
    @PostMapping("/categories/add")
    public String addCategory(@RequestParam String name,
                              @RequestParam(required = false, defaultValue = "0") Integer sort,
                              RedirectAttributes redirectAttributes) {
        try {
            Category category = new Category();
            category.setName(name);
            category.setSort(sort);
            category.setStatus(1); // 默认启用

            categoryService.addCategory(category);
            redirectAttributes.addFlashAttribute("success", "分类添加成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "分类添加失败: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

    // 更新分类
    @PostMapping("/categories/update")
    public String updateCategory(@RequestParam Integer id,
                                 @RequestParam String name,
                                 @RequestParam Integer sort,
                                 RedirectAttributes redirectAttributes) {
        try {
            Category category = new Category();
            category.setId(id);
            category.setName(name);
            category.setSort(sort);

            categoryService.updateCategory(category);
            redirectAttributes.addFlashAttribute("success", "分类更新成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "分类更新失败: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

    // 更新分类状态
    @PostMapping("/categories/update-status")
    public String updateCategoryStatus(@RequestParam Integer id,
                                       @RequestParam Integer status,
                                       RedirectAttributes redirectAttributes) {
        try {
            categoryService.updateCategoryStatus(id, status);
            redirectAttributes.addFlashAttribute("success", "分类状态更新成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "分类状态更新失败: " + e.getMessage());
        }
        return "redirect:/admin/categories";
    }

    // 删除分类
    @PostMapping("/categories/delete")
    public String deleteCategory(
            @RequestParam Integer id,
            RedirectAttributes redirectAttributes) {
        try {
            categoryService.deleteCategory(id);
            redirectAttributes.addFlashAttribute("success", "分类删除成功");
            return "redirect:/admin/categories"; // 重定向到分类列表页
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "删除失败: " + e.getMessage());
            return "redirect:/admin/categories";
        }
    }
    // 商品管理页面
    @GetMapping("/goods")
    public String goodsManagement(
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) Integer status,
            @RequestParam(defaultValue = "1") Integer page,
            @RequestParam(defaultValue = "10") Integer size,
            Model model) {

        List<Goods> goodsList = goodsService.searchGoodsForAdmin(keyword, status, page, size);
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("keyword", keyword);
        model.addAttribute("status", status);
        model.addAttribute("page", page);
        model.addAttribute("size", size);

        // 传递内容页和激活项参数到模型
        model.addAttribute("contentPage", "goods_management");
        model.addAttribute("active", "goods");

        return "admin/wrapper";
    }

    // 审核通过商品
    @PostMapping("/goods/approve/{id}")
    public String approveGoods(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            goodsService.changeGoodsStatus(id, 1); // 1表示上架状态
            redirectAttributes.addFlashAttribute("success", "商品审核通过成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "商品审核通过失败: " + e.getMessage());
        }
        return "redirect:/admin/goods";
    }

    // 拒绝商品
    @PostMapping("/goods/reject/{id}")
    public String rejectGoods(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            goodsService.changeGoodsStatus(id, 3); // 3表示审核不通过
            redirectAttributes.addFlashAttribute("success", "商品拒绝成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "商品拒绝失败: " + e.getMessage());
        }
        return "redirect:/admin/goods";
    }

    // 下架商品
    @PostMapping("/goods/take-down/{id}")
    public String takeDownGoods(@PathVariable Integer id, RedirectAttributes redirectAttributes) {
        try {
            goodsService.changeGoodsStatus(id, 0); // 0表示下架状态
            redirectAttributes.addFlashAttribute("success", "商品下架成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "商品下架失败: " + e.getMessage());
        }
        return "redirect:/admin/goods";
    }

    // 删除商品
    @PostMapping("/goods/delete/{id}")
    public String deleteGoods(@PathVariable Integer id,
                              HttpSession session,
                              RedirectAttributes redirectAttributes) {
        try {
            User admin = (User) session.getAttribute("admin");
            if (admin == null) {
                return "redirect:/admin/login";
            }

            Goods goods = goodsService.getGoodsById(id);
            if (goods == null) {
                redirectAttributes.addFlashAttribute("error", "商品不存在");
                return "redirect:/admin/goods";
            }

            // 检查商品状态是否为下架(0)
            if (goods.getStatus() != 0) {
                redirectAttributes.addFlashAttribute("error", "只有下架状态的商品可以删除");
                return "redirect:/admin/goods";
            }

            goodsService.deleteGoods(id);
            redirectAttributes.addFlashAttribute("success", "商品删除成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "商品删除失败: " + e.getMessage());
        }
        return "redirect:/admin/goods";
    }

    // 公告管理页面
    @GetMapping("/announcements")
    public String announcementManagement(Model model) {
        model.addAttribute("announcements", announcementService.getAllAnnouncements());
        model.addAttribute("contentPage", "announcement_management");
        model.addAttribute("active", "announcements");
        return "admin/wrapper";
    }

    // 添加公告处理
    @PostMapping("/announcements/add")
    public String addAnnouncement(@RequestParam String title,
                                  @RequestParam String content,
                                  RedirectAttributes redirectAttributes) {
        try {
            Announcement announcement = new Announcement();
            announcement.setTitle(title);
            announcement.setContent(content);
            announcementService.addAnnouncement(announcement);
            redirectAttributes.addFlashAttribute("success", "公告添加成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "公告添加失败: " + e.getMessage());
        }
        return "redirect:/admin/announcements";
    }

    // 编辑公告处理
    @PostMapping("/announcements/edit")
    public String editAnnouncement(@RequestParam Integer id,
                                   @RequestParam String title,
                                   @RequestParam String content,
                                   RedirectAttributes redirectAttributes) {
        try {
            Announcement announcement = announcementService.getAnnouncementById(id);
            announcement.setTitle(title);
            announcement.setContent(content);
            announcementService.updateAnnouncement(announcement);
            redirectAttributes.addFlashAttribute("success", "公告更新成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "公告更新失败: " + e.getMessage());
        }
        return "redirect:/admin/announcements";
    }

    // 删除公告
    @PostMapping("/announcements/delete")
    public String deleteAnnouncement(@RequestParam Integer id,
                                     RedirectAttributes redirectAttributes) {
        try {
            announcementService.deleteAnnouncement(id);
            redirectAttributes.addFlashAttribute("success", "公告删除成功");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "公告删除失败: " + e.getMessage());
        }
        return "redirect:/admin/announcements";
    }
}