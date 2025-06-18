package com.itheima.dao;

import com.itheima.domain.Announcement;

import java.util.List;

public interface AnnouncementMapper {
    /**
     * 获取最新的公告列表
     * @param limit 获取数量
     * @return 公告列表
     */
    List<Announcement> selectLatestAnnouncements(int limit);
    // 查询所有公告
    List<Announcement> selectAll();

    // 根据ID查询公告
    Announcement selectById(Integer id);

    // 添加公告
    void insert(Announcement announcement);

    // 更新公告
    void update(Announcement announcement);

    // 删除公告
    void delete(Integer id);
}
