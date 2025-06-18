package com.itheima.service.impl;

import com.itheima.dao.UserMapper;
import com.itheima.domain.User;
import com.itheima.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.DigestUtils;

import java.util.Date;
import java.util.List;

@Service
@Transactional
public class UserServiceImpl implements UserService {
    @Autowired
    private UserMapper userMapper;
    @Override
    public boolean register(User user) {
        // 检查用户名和邮箱是否已存在
        if (isUsernameExist(user.getUsername())) {
            throw new RuntimeException("用户名已存在");
        }
        if (isEmailExist(user.getEmail())) {
            throw new RuntimeException("邮箱已注册");
        }
        // 设置默认属性
        user.setCreateTime(new Date());
        user.setUpdateTime(new Date());
        user.setStatus(1); // 默认激活状态
        user.setRole(0);   // 默认普通用户
        // 密码加密
        user.setPassword(DigestUtils.md5DigestAsHex(user.getPassword().getBytes()));
        // 插入数据库
        return userMapper.insert(user) > 0;
    }

    @Override
    public User login(String username, String password) {
        // 密码加密 (与注册时一致)
        String encryptedPassword = DigestUtils.md5DigestAsHex(password.getBytes());

        // 查询用户
        User user = userMapper.findByUsernameAndPassword(username, encryptedPassword);

        if (user == null) {
            throw new RuntimeException("用户名或密码错误");
        }

        if (user.getStatus() == 0) {
            throw new RuntimeException("账号已被禁用，请联系管理员");
        }

        return user;
    }

    @Override
    public boolean isUsernameExist(String username) {
        return userMapper.findByUsername(username) != null;
    }

    @Override
    public boolean isEmailExist(String email) {
        return userMapper.findByEmail(email) != null;
    }

    @Override
    public User getUserById(Integer userId) {
        return userMapper.findById(userId);
    }
    @Override
    public User findByUsername(String username) {
        return userMapper.findByUsername(username);
    }
    @Override
    public void updateUser(User user) {
        user.setUpdateTime(new Date());
        userMapper.update(user);
    }
    @Override
    public int getUserCount() {
        return userMapper.countAll();
    }

    @Override
    public void changePassword(Integer userId, String oldPassword, String newPassword) {
        User user = userMapper.findById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }

        // 验证旧密码
        String encryptedOldPassword = DigestUtils.md5DigestAsHex(oldPassword.getBytes());
        if (!user.getPassword().equals(encryptedOldPassword)) {
            throw new RuntimeException("原密码不正确");
        }

        // 更新密码
        String encryptedNewPassword = DigestUtils.md5DigestAsHex(newPassword.getBytes());
        user.setPassword(encryptedNewPassword);
        user.setUpdateTime(new Date());

        userMapper.update(user);
    }

    @Override
    public List<User> getAllUsers() {
        return userMapper.findAll();
    }

    @Override
    public void updateUserStatus(Integer userId, Integer status) {
        User user = userMapper.findById(userId);
        if (user != null) {
            user.setStatus(status);
            user.setUpdateTime(new Date());
            userMapper.update(user);
        }
    }

    @Override
    public List<User> searchUsers(String keyword) {
        return userMapper.findByKeyword("%" + keyword + "%");
    }
    @Override
    public void deleteUser(Integer userId) {
        int result = userMapper.deleteById(userId);
        if (result == 0) {
            throw new RuntimeException("用户不存在或已被删除");
        }
    }
}