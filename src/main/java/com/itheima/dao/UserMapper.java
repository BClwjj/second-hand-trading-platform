package com.itheima.dao;

import com.itheima.domain.User;
import org.apache.ibatis.annotations.Param;

import java.util.List;

public interface UserMapper {

    /**
     * 根据ID查询用户
     * @param userId 用户ID
     * @return 用户信息
     */
    User findById(Integer userId);

    /**
     * 根据用户名查询用户
     * @param username 用户名
     * @return 用户信息
     */
    User findByUsername(String username);

    /**
     * 根据邮箱查询用户
     * @param email 邮箱
     * @return 用户信息
     */
    User findByEmail(String email);

    /**
     * 根据用户名和密码查询用户
     * @param username 用户名
     * @param password 密码
     * @return 用户信息
     */
    User findByUsernameAndPassword(@Param("username") String username, @Param("password") String password);

    /**
     * 插入用户
     * @param user 用户信息
     * @return 影响的行数
     */
    int insert(User user);

    /**
     * 更新用户
     * @param user 用户信息
     * @return 影响的行数
     */
    int update(User user);

    /**
     * 查询所有用户
     * @return 用户列表
     */
    List<User> findAll();

    /**
     * 根据关键词搜索用户
     * @param keyword 关键词
     * @return 用户列表
     */
    List<User> findByKeyword(String keyword);
    /**
     * 根据ID删除用户
     * @param userId 用户ID
     * @return 影响的行数
     */
    int deleteById(Integer userId);
    int countAll();
    int updateStatus(@Param("userId") Integer userId,@Param("status") Integer status);
}