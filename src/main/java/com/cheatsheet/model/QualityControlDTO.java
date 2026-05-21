package com.cheatsheet.model;

public class QualityControlDTO {
    private int id;
    private String title;
    private String content;
    private String author;
    private String type;

    // Getter/Setter တွေကို Manual ထည့်ပေးလိုက်ပါ
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
}