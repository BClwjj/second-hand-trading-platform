package com.itheima.service.impl;

import com.itheima.dao.CategoryMapper;
import com.itheima.domain.Category;
import com.itheima.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Map;

@Service
public class CategoryServiceImpl implements CategoryService {

    @Autowired
    private CategoryMapper categoryMapper;

    @Override
    public List<Category> getAllCategories() {
        return categoryMapper.findAll();
    }
    @Override
    public Category getCategoryById(Integer id) {
        return categoryMapper.findById(id);
    }
    @Override
    @Transactional
    public void addCategory(Category category) {
        category.setStatus(1); // 默认启用
        categoryMapper.insert(category);
    }

    @Override
    @Transactional
    public void updateCategory(Category category) {
        categoryMapper.update(category);
    }

    @Override
    @Transactional
    public void updateCategoryStatus(Integer id, Integer status) {
        categoryMapper.updateStatus(id, status);
    }
    @Override
    @Transactional
    public void deleteCategory(Integer id) {
        categoryMapper.deleteById(id);
    }
    @Override
    public List<Map<String, Object>> findCategoryWithGoodsCount() {
        return categoryMapper.findCategoryWithGoodsCount();
    }
}