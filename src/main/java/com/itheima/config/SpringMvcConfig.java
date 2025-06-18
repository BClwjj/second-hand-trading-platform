package com.itheima.config;

import com.itheima.interceptor.LoginInterceptor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

/**
 * Spring MVC配置类
 */
@Configuration
public class SpringMvcConfig implements WebMvcConfigurer {

    /**
     * 添加拦截器
     */
    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginInterceptor())
                .addPathPatterns("/**")
                .excludePathPatterns("/user/login", "/user/register", "/static/**", "/error", "/uploads/**");
    }
    /**
     * 添加静态资源映射
     */
//    @Override
//    public void addResourceHandlers(ResourceHandlerRegistry registry) {
//        // 将 /uploads/** 映射到 D:/tomcat/uploads/
//        registry.addResourceHandler("/uploads/**")
//                .addResourceLocations("file:///D:/tomcat/uploads/");
//        // 打印调试信息
//        System.out.println("静态资源映射已注册：/uploads/** → file:///D:/tomcat/uploads/");
//    }
//    @Override
//    public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
//        configurer.enable();
//    }
}