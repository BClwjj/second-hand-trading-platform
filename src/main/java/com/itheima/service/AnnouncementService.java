package com.itheima.service;

import com.itheima.domain.Announcement;
import java.util.List;

public interface AnnouncementService {
    // 查询所有公告
    List<Announcement> getAllAnnouncements();

    // 根据ID查询公告
    Announcement getAnnouncementById(Integer id);

    // 添加公告
    void addAnnouncement(Announcement announcement);

    // 更新公告
    void updateAnnouncement(Announcement announcement);

    // 删除公告
    void deleteAnnouncement(Integer id);
}