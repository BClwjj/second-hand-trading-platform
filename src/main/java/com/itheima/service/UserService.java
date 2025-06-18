package com.itheima.service;

import com.itheima.domain.User;

import java.util.List;

public interface UserService {

    /**
     * 用户注册
     * @param user 用户信息
     * @return 注册成功返回true，失败返回false
     * @throws RuntimeException 注册失败时抛出异常
     */
    boolean register(User user) throws RuntimeException;

    /**
     * 用户登录
     * @param username 用户名
     * @param password 密码
     * @return 登录成功的用户信息
     * @throws RuntimeException 登录失败时抛出异常
     */
    User login(String username, String password) throws RuntimeException;

    /**
     * 检查用户名是否存在
     * @param username 用户名
     * @return 存在返回true，不存在返回false
     */
    boolean isUsernameExist(String username);

    /**
     * 检查邮箱是否存在
     * @param email 邮箱
     * @return 存在返回true，不存在返回false
     */
    boolean isEmailExist(String email);

    /**
     * 根据用户ID获取用户信息
     * @param userId 用户ID
     * @return 用户信息
     */
    User getUserById(Integer userId);
    /**
     * 根据用户名获取用户信息
     * @param username 用户名
     * @return 用户信息
     */
    User findByUsername(String username);
    /**
     * 更新用户信息
     * @param user 用户信息
     */
    void updateUser(User user);

    /**
     * 修改密码
     * @param userId 用户ID
     * @param oldPassword 旧密码
     * @param newPassword 新密码
     * @throws RuntimeException 修改失败时抛出异常
     */
    void changePassword(Integer userId, String oldPassword, String newPassword) throws RuntimeException;

    /**
     * 获取所有用户列表（管理员用）
     * @return 用户列表
     */
    List<User> getAllUsers();

    /**
     * 更新用户状态（管理员用）
     * @param userId 用户ID
     * @param status 状态(1-正常,0-禁用)
     */
    void updateUserStatus(Integer userId, Integer status);

    /**
     * 根据条件搜索用户（管理员用）
     * @param keyword 关键词
     * @return 用户列表
     */
    List<User> searchUsers(String keyword);

    int getUserCount();
    void deleteUser(Integer userId) throws RuntimeException;
}