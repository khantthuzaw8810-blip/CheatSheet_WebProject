<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>User Profile Settings</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
</head>
<body class="bg-slate-900 text-slate-100 font-sans m-0 p-0">

    <div class="flex min-h-screen">
        <jsp:include page="admin_sidebar.jsp" />
        
        <main class="flex-1 pl-[280px] pr-8 py-12 bg-[#0f172a]">
            <div class="max-w-xl mx-auto bg-[#1e293b] rounded-2xl shadow-xl border border-slate-800 p-8">
                
                <div class="flex items-center space-x-5 mb-6">
                    <div class="w-16 h-16 bg-gradient-to-tr from-indigo-600 to-indigo-500 rounded-2xl flex items-center justify-center text-white text-2xl font-black shadow-lg">
                        ${sessionScope.username != null ? sessionScope.username.substring(0,1).toUpperCase() : "U"}
                    </div>
                    <div>
                        <h2 class="text-2xl font-bold text-white">${sessionScope.username != null ? sessionScope.username : "User"}</h2>
                        <p class="text-xs text-emerald-400 flex items-center gap-1.5 mt-0.5">
                            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span> Profile Security Hub
                        </p>
                    </div>
                </div>

                <hr class="border-slate-800 my-6">

                <% if(request.getAttribute("error") != null) { %>
                    <div class="mb-5 p-4 bg-rose-500/10 border-l-4 border-rose-500 text-rose-200 text-sm rounded-r-xl">
                        <i class="fa-solid fa-triangle-exclamation mr-2"></i> <%= request.getAttribute("error") %>
                    </div>
                <% } %>
                <% if(request.getAttribute("success") != null) { %>
                    <div class="mb-5 p-4 bg-emerald-500/10 border-l-4 border-emerald-500 text-emerald-200 text-sm rounded-r-xl">
                        <i class="fa-solid fa-circle-check mr-2"></i> <%= request.getAttribute("success") %>
                    </div>
                <% } %>

                <h3 class="text-lg font-bold text-slate-200 mb-5 flex items-center gap-2">
                    <i class="fa-solid fa-key text-indigo-400"></i> Change Password
                </h3>
                
                <form action="ProfileServlet" method="POST" class="space-y-5">
                    <div>
                        <label class="block text-sm font-semibold text-slate-400 mb-1.5">Current Password</label>
                        <div class="relative">
                            <input type="password" id="currentPassword" name="currentPassword" required 
                                   class="w-full px-4 py-2.5 pr-12 bg-[#0f172a] rounded-xl border border-slate-700 text-white focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition">
                            <button type="button" onclick="togglePassword('currentPassword', 'eyeCurrent')" 
                                    class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300 transition focus:outline-none">
                                <i id="eyeCurrent" class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-400 mb-1.5">New Password</label>
                        <div class="relative">
                            <input type="password" id="newPassword" name="newPassword" required 
                                   class="w-full px-4 py-2.5 pr-12 bg-[#0f172a] rounded-xl border border-slate-700 text-white focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition">
                            <button type="button" onclick="togglePassword('newPassword', 'eyeNew')" 
                                    class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300 transition focus:outline-none">
                                <i id="eyeNew" class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-slate-400 mb-1.5">Confirm New Password</label>
                        <div class="relative">
                            <input type="password" id="confirmPassword" name="confirmPassword" required 
                                   class="w-full px-4 py-2.5 pr-12 bg-[#0f172a] rounded-xl border border-slate-700 text-white focus:outline-none focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 transition">
                            <button type="button" onclick="togglePassword('confirmPassword', 'eyeConfirm')" 
                                    class="absolute right-4 top-1/2 -translate-y-1/2 text-slate-500 hover:text-slate-300 transition focus:outline-none">
                                <i id="eyeConfirm" class="fa-solid fa-eye"></i>
                            </button>
                        </div>
                    </div>

                    <button type="submit" class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-3 rounded-xl transition shadow-lg shadow-indigo-600/10 mt-3 transform hover:-translate-y-0.5 duration-150">
                        Update Password Security
                    </button>
                </form>
                
            </div>
        </main>
    </div>

    <script>
        function togglePassword(inputId, eyeIconId) {
            const passwordInput = document.getElementById(inputId);
            const eyeIcon = document.getElementById(eyeIconId);
            
            if (passwordInput.type === "password") {
                passwordInput.type = "text";
                // မျက်လုံးပုံစံကို အဖွင့်မှ မျဉ်းစောင်းပိတ်ပုံစံပြောင်းရန် (fa-eye-slash)
                eyeIcon.classList.remove("fa-eye");
                eyeIcon.classList.add("fa-eye-slash");
            } else {
                passwordInput.type = "password";
                // မူလမျက်လုံးပုံစံပြန်ပြောင်းရန်
                eyeIcon.classList.remove("fa-eye-slash");
                eyeIcon.classList.add("fa-eye");
            }
        }
    </script>

</body>
</html>