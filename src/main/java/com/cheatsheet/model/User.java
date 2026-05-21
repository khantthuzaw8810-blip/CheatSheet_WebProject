package com.cheatsheet.model;

public class User {
    private int userId;
    private String username;
    private String passwordHash;
    private String role;

    // ၁။ No-arg Constructor (ဒါရှိမှ UserRepository ထဲက new User() အလုပ်လုပ်မှာပါ)
    public User() {}

    // ၂။ Parameterized Constructor (လိုရမယ်ရ ထားထားလို့ရပါတယ်)
    public User(int userId, String username, String passwordHash, String role) {
        this.userId = userId;
        this.username = username;
        this.passwordHash = passwordHash;
        this.role = role;
    }

    // Getters
    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getPasswordHash() { return passwordHash; }
    public String getRole() { return role; }

    // Setters (ဒါတွေအားလုံးရှိမှ Repo ထဲမှာ Error မတက်မှာပါ)
    public void setUserId(int userId) { this.userId = userId; }
    public void setUsername(String username) { this.username = username; }
    public void setPasswordHash(String passwordHash) { this.passwordHash = passwordHash; }
    public void setRole(String role) { this.role = role; }

	public Object getStatus() {
		// TODO Auto-generated method stub
		return null;
	}
}