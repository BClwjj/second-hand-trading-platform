package com.itheima.dao;

import com.itheima.domain.Category;
import org.apache.ibatis.annotations.Param;

import java.util.List;
import java.util.Map;

public interface CategoryMapper {
    List<Category> findAll();
    Category findById(Integer id);
    int insert(Category category);
    int update(Category category);
    int updateStatus(@Param("id")Integer id,@Param("status") Integer status);
    /**
     * 根据ID删除分类
     * @param id 分类ID
     * @return 影响的行数
     */
    int deleteById(Integer id);
    List<Map<String, Object>> findCategoryWithGoodsCount();
}