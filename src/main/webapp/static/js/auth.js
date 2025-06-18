document.addEventListener('DOMContentLoaded', function() {
    // 获取上下文路径
    const contextPath = document.body.getAttribute('data-context-path') || '';

    // 登录表单验证
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            const username = document.getElementById('username').value.trim();
            const password = document.getElementById('password').value.trim();

            if (!username || !password) {
                e.preventDefault();
                alert('请输入用户名和密码');
            }
        });
    }

    // 注册表单验证
    // 密码长度提示
    document.getElementById('password')?.addEventListener('input', function() {
        const password = this.value;
        const hint = document.getElementById('lengthHint');

        if (password.length >= 6) {
            hint.querySelector('i').style.color = '#07C160';
        } else {
            hint.querySelector('i').style.color = '#ccc';
        }
    });

    // 初始化表单验证
    initFormValidation(contextPath);
});

// 初始化表单验证
function initFormValidation(contextPath) {
    // 用户名实时验证
    const usernameInput = document.getElementById('username');
    if (usernameInput) {
        usernameInput.addEventListener('input', function() {
            validateUsername(this.value.trim(), contextPath);
        });
    }

    // 邮箱实时验证
    const emailInput = document.getElementById('email');
    if (emailInput) {
        emailInput.addEventListener('input', function() {
            validateEmail(this.value.trim(), contextPath);
        });
    }

    // 密码一致性验证
    const passwordInput = document.getElementById('password');
    const confirmPasswordInput = document.getElementById('confirmPassword');
    if (confirmPasswordInput) {
        confirmPasswordInput.addEventListener('input', function() {
            validatePasswordMatch();
        });
    }

    // 表单提交验证
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const username = usernameInput?.value.trim();
            const email = emailInput?.value.trim();
            const password = passwordInput?.value;
            const confirmPassword = confirmPasswordInput?.value;

            // 验证所有字段
            const isUsernameValid = username ? await validateUsername(username, contextPath) : false;
            const isEmailValid = email ? await validateEmail(email, contextPath) : false;
            const isPasswordValid = password ? password.length >= 6 && password.length <= 20 : false;
            const isPasswordMatch = validatePasswordMatch();
            const isAgree = document.getElementById('agree')?.checked;

            if (!isUsernameValid || !isEmailValid || !isPasswordValid || !isPasswordMatch || !isAgree) {
                if (!isUsernameValid && usernameInput) {
                    usernameInput.classList.add('is-invalid');
                }
                if (!isEmailValid && emailInput) {
                    emailInput.classList.add('is-invalid');
                }
                if (!isPasswordValid && passwordInput) {
                    passwordInput.classList.add('is-invalid');
                }
                if (!isPasswordMatch && confirmPasswordInput) {
                    confirmPasswordInput.classList.add('is-invalid');
                }
                if (!isAgree) {
                    alert('请同意用户协议和隐私政策');
                }
                return;
            }

            // 所有验证通过，提交表单
            this.submit();
        });
    }
}

// 验证用户名
async function validateUsername(username, contextPath) {
    const feedback = document.getElementById('usernameFeedback');
    const input = document.getElementById('username');

    if (!input) return false;

    if (username.length < 4 || username.length > 20) {
        feedback.textContent = '用户名必须为4-20个字符';
        input.classList.add('is-invalid');
        return false;
    }

    try {
        const response = await fetch(`${contextPath}/user/checkUsername?username=${encodeURIComponent(username)}`);
        if (!response.ok) throw new Error('请求失败');

        const data = await response.json();
        if (!data.available) {
            feedback.textContent = '用户名已存在';
            input.classList.add('is-invalid');
            return false;
        } else {
            feedback.textContent = '';
            input.classList.remove('is-invalid');
            return true;
        }
    } catch (error) {
        console.error('检查用户名时出错:', error);
        feedback.textContent = '检查用户名时出错，请重试';
        input.classList.add('is-invalid');
        return false;
    }
}

// 验证邮箱
async function validateEmail(email, contextPath) {
    const feedback = document.getElementById('emailFeedback');
    const input = document.getElementById('email');
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!input) return false;

    if (!emailRegex.test(email)) {
        feedback.textContent = '请输入有效的邮箱地址';
        input.classList.add('is-invalid');
        return false;
    }

    try {
        const response = await fetch(`${contextPath}/user/checkEmail?email=${encodeURIComponent(email)}`);
        if (!response.ok) throw new Error('请求失败');

        const data = await response.json();
        if (!data.available) {
            feedback.textContent = '邮箱已注册';
            input.classList.add('is-invalid');
            return false;
        } else {
            feedback.textContent = '';
            input.classList.remove('is-invalid');
            return true;
        }
    } catch (error) {
        console.error('检查邮箱时出错:', error);
        feedback.textContent = '检查邮箱时出错，请重试';
        input.classList.add('is-invalid');
        return false;
    }
}

// 验证密码一致性
function validatePasswordMatch() {
    const password = document.getElementById('password')?.value;
    const confirmPassword = document.getElementById('confirmPassword')?.value;
    const feedback = document.getElementById('confirmPasswordFeedback');
    const input = document.getElementById('confirmPassword');

    if (!input) return false;

    if (password !== confirmPassword) {
        feedback.textContent = '两次输入的密码不一致';
        input.classList.add('is-invalid');
        return false;
    }
    feedback.textContent = '';
    input.classList.remove('is-invalid');
    return true;
}