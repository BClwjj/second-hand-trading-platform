package com.itheima.dao;

import com.itheima.domain.Banner;
import java.util.List;
import java.util.Map;

public interface BannerMapper {
    List<Banner> findActiveBanners();
}
