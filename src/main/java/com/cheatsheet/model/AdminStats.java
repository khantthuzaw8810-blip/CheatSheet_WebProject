package com.cheatsheet.model;

import lombok.Getter;
import lombok.Setter;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class AdminStats {
    private int totalUsers;
    private int totalSheets;
    private int bannedUsers;
}