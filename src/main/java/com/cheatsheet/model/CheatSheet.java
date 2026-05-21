package com.cheatsheet.model;

import java.sql.Timestamp;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class CheatSheet {
    private int cheatSheetId;
    private String title;
    private String content;
    private int categoryId;
    private Timestamp createdAt;
    private Timestamp updatedAt;
    private String imageUrl;      // Cheat sheet image
    private String referenceLink; // External reference link
    
    // 🚀 🎯 [ထပ်ပေါင်းထည့်သည့်နေရာ] - Status နှင့် CreatedBy Variables များ
    private String status;        // PENDING, APPROVED, etc.
    private String createdBy;     // တင်သည့်လူအမည် (Username)

    // ✅ မူလ Getter/Setter များ (မပြောင်းလဲပါ)
    public int getCheatSheetId() {
        return cheatSheetId;
    }
    public void setCheatSheetId(int cheatSheetId) {
        this.cheatSheetId = cheatSheetId;
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getCategoryId() { return categoryId; }
    public void setCategoryId(int categoryId) { this.categoryId = categoryId; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }

    public Timestamp getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
    
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public String getReferenceLink() { return referenceLink; }
    public void setReferenceLink(String referenceLink) { this.referenceLink = referenceLink; }
    
    // 🚀 🎯 [ထပ်ပေါင်းထည့်သည့်နေရာ] - Status နှင့် CreatedBy အတွက် Getter/Setter များ
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getCreatedBy() { return createdBy; }
    public void setCreatedBy(String createdBy) { this.createdBy = createdBy; }
	
}