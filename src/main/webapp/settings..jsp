<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.cheatsheet.model.User" %>
<%
    User adminUser = (User) session.getAttribute("admin");
%>

<style>
    .settings-card { background: var(--card-bg); padding: 20px; border-radius: 12px; margin-bottom: 20px; box-shadow: 0 4px 10px rgba(0,0,0,0.05); color: var(--text-color); border: 1px solid var(--border-color); }
    .form-group { margin-bottom: 15px; }
    .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
    .form-group input { width: 100%; padding: 10px; border: 1px solid var(--border-color); border-radius: 6px; box-sizing: border-box; background: var(--input-bg); color: var(--text-color); }
    .btn-update { background: #005bea; color: #fff; border: none; padding: 10px 20px; border-radius: 6px; cursor: pointer; font-weight: bold; }
    .theme-row { display: flex; justify-content: space-between; align-items: center; }
    .switch { position: relative; display: inline-block; width: 44px; height: 22px; }
    .switch input { opacity: 0; width: 0; height: 0; }
    .slider { position: absolute; cursor: pointer; top: 0; left: 0; right: 0; bottom: 0; background: #ccc; border-radius: 34px; transition: .4s; }
    .slider:before { position: absolute; content: ""; height: 16px; width: 16px; left: 3px; bottom: 3px; background: #fff; border-radius: 50%; transition: .4s; }
    input:checked + .slider { background: #005bea; }
    input:checked + .slider:before { transform: translateX(22px); }
</style>

<div class="settings-wrapper">
    <h1 class="big-title">⚙ Admin Settings</h1>

    <div class="settings-card">
        <div class="theme-row">
            <span><b>Dark Mode Appearance</b></span>
            <label class="switch">
                <input type="checkbox" id="darkToggle" onchange="applyTheme(this.checked)">
                <span class="slider"></span>
            </label>
        </div>
    </div>

    <div class="settings-card">
        <h3><i class="fas fa-lock"></i> Security</h3>
        <p style="font-size: 14px; color: var(--text-sub);">Password အား အနည်းဆုံး စာလုံး တစ်လုံး၊ ဂဏန်း တစ်လုံးနှင့် Special Character တစ်ခု ပါဝင်အောင် သတ်မှတ်ပါ။</p>
        <form action="AdminSettingsServlet" method="POST">
            <input type="hidden" name="action" value="changePassword">
            <div class="form-group">
                <label>Current Password</label>
                <input type="password" name="oldPassword" required>
            </div>
            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="newPassword" required>
            </div>
            <button type="submit" class="btn-update" style="background:#a90033;">Change Password</button>
        </form>
    </div>

    <div class="settings-card">
        <h3><i class="fas fa-info-circle"></i> System Details</h3>
        <p><b>Server Status:</b> Online</p>
        <p><b>Last Login:</b> <%= session.getAttribute("lastLogin") %></p>
    </div>
</div>

<script>
    // မူလ Theme logic အတိုင်း ထားရှိခြင်း
    function applyTheme(isDark) {
        if (isDark) {
            document.body.classList.add('dark-mode');
            localStorage.setItem('theme', 'dark');
        } else {
            document.body.classList.remove('dark-mode');
            localStorage.setItem('theme', 'light');
        }
    }
    
    // Switch အခြေအနေကို ပြန်စစ်ဆေးခြင်း
    if (localStorage.getItem('theme') === 'dark') {
        document.getElementById('darkToggle').checked = true;
    }
</script>