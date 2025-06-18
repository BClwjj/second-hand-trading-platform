package com.itheima.service;
import com.itheima.domain.Category;
import java.util.List;
import java.util.Map;

public interface CategoryService {
    List<Category> getAllCategories();
    /**
     * 根据ID获取分类信息
     * @param id 分类ID
     * @return 分类对象
     */
    Category getCategoryById(Integer id);
    void addCategory(Category category);
    void updateCategory(Category category);
    void updateCategoryStatus(Integer id, Integer status);
    /**
     * 删除分类
     * @param id 分类ID
     */
    void deleteCategory(Integer id);
    List<Map<String, Object>> findCategoryWithGoodsCount();
}
