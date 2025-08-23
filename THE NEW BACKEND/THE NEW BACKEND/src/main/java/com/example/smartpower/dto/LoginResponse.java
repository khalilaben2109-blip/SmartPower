package com.example.smartpower.dto;

public class LoginResponse {
    private String token;
    private String type = "Bearer";
    private String email;
    private String role;
    private Long userId;
    private String nom;
    private String prenom;

    // Constructeurs
    public LoginResponse() {}

    public LoginResponse(String token, String type, String email, String role, Long userId, String nom, String prenom) {
        this.token = token;
        this.type = type;
        this.email = email;
        this.role = role;
        this.userId = userId;
        this.nom = nom;
        this.prenom = prenom;
    }

    // Getters et Setters
    public String getToken() {
        return token;
    }

    public void setToken(String token) {
        this.token = token;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public Long getUserId() {
        return userId;
    }

    public void setUserId(Long userId) {
        this.userId = userId;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }
}
