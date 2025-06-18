package com.itheima.domain;

public // 通用返回结果类
class Result {
    private boolean success;
    private String message;
    private Object data;
    // 成功静态方法（带数据）
    public static Result success(Object data) {
        Result result = new Result();
        result.setSuccess(true);
        result.setData(data);
        return result;
    }
    // 成功静态方法（带消息）
    public static Result success(String message) {
        Result result = new Result();
        result.setSuccess(true);
        result.setMessage(message);
        return result;
    }

    // 错误静态方法
    public static Result error(String message) {
        Result result = new Result();
        result.setSuccess(false);
        result.setMessage(message);
        return result;
    }

    // getters and setters
    public boolean isSuccess() {
        return success;
    }

    public void setSuccess(boolean success) {
        this.success = success;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Object getData() {
        return data;
    }

    public void setData(Object data) {
        this.data = data;
    }
}
