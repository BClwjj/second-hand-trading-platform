package com.itheima.service.impl;

import com.itheima.dao.AnnouncementMapper;
import com.itheima.domain.Announcement;
import com.itheima.service.AnnouncementService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Date;
import java.util.List;

@Service
public class AnnouncementServiceImpl implements AnnouncementService {

    @Autowired
    private AnnouncementMapper announcementMapper;

    @Override
    public List<Announcement> getAllAnnouncements() {
        return announcementMapper.selectAll();
    }

    @Override
    public Announcement getAnnouncementById(Integer id) {
        return announcementMapper.selectById(id);
    }

    @Override
    public void addAnnouncement(Announcement announcement) {
        // 设置创建时间
        announcement.setCreateTime(new Date());
        announcementMapper.insert(announcement);
    }

    @Override
    public void updateAnnouncement(Announcement announcement) {
        announcementMapper.update(announcement);
    }

    @Override
    public void deleteAnnouncement(Integer id) {
        announcementMapper.delete(id);
    }
}