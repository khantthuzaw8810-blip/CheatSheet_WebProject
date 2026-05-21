package com.cheatsheet.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor  // ဒါက Default Constructor (Parameter မပါတာ) ကို ဆောက်ပေးပါတယ်
@AllArgsConstructor // ဒါက Parameter အားလုံးပါတဲ့ Constructor ကို ဆောက်ပေးပါတယ်
public class AdminUser {
    
    private int userId;
    private String username;
    private String role;
    private String status;
}