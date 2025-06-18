package com.itheima.interceptor;

import com.itheima.domain.User;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * 登录拦截器
 */
public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 获取请求的URI
        String uri = request.getRequestURI();

        // 放行登录、注册、静态资源等请求
        if (uri.contains("/user/login") || uri.contains("/user/register")
                || uri.contains("/static/") || uri.contains("/error")) {
            return true;
        }

        // 检查session中是否有用户信息
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            // 未登录，跳转到登录页面（注意路径变化）
            response.sendRedirect(request.getContextPath() + "/user/login");
            return false;
        }

        return true;
    }
}