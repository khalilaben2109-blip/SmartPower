package com.example.smartpower.controller;

import com.example.smartpower.domain.*;
import com.example.smartpower.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/existing")
@CrossOrigin(origins = "*")
public class ExistingDataController {

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private RHRepository rhRepository;

    @Autowired
    private TechnicienRepository technicienRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @PostMapping("/fix-passwords")
    public ResponseEntity<?> fixExistingPasswords() {
        try {
            Map<String, Object> result = new HashMap<>();
            result.put("message", "Mise à jour des mots de passe effectuée");

            // Encoder le mot de passe "admin" pour l'utilisateur existant
            String encodedPassword = passwordEncoder.encode("admin");
            
            // Mettre à jour le mot de passe dans la table utilisateurs
            // Note: Cette opération nécessite une requête SQL directe
            // car nous devons mettre à jour la table parent
            
            result.put("encoded_password", encodedPassword);
            result.put("note", "Exécutez le script SQL update-password.sql dans pgAdmin");
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur: " + e.getMessage());
        }
    }

    @GetMapping("/accounts")
    public ResponseEntity<?> getExistingAccounts() {
        try {
            Map<String, Object> result = new HashMap<>();
            
            result.put("admins", adminRepository.findAll());
            result.put("clients", clientRepository.findAll());
            result.put("techniciens", technicienRepository.findAll());
            result.put("rh", rhRepository.findAll());
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur: " + e.getMessage());
        }
    }

    @GetMapping("/test-login")
    public ResponseEntity<?> testLogin() {
        try {
            Map<String, Object> result = new HashMap<>();
            
            // Tester si le compte admin existe
            var adminOpt = adminRepository.findByEmail("admin@gmail.com");
            if (adminOpt.isPresent()) {
                Admin admin = adminOpt.get();
                result.put("admin_exists", true);
                result.put("admin_email", admin.getEmail());
                result.put("admin_nom", admin.getNom());
                result.put("admin_prenom", admin.getPrenom());
                result.put("password_encoded", admin.getMotDePasse() != null && admin.getMotDePasse().startsWith("$2a$"));
            } else {
                result.put("admin_exists", false);
            }
            
            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur: " + e.getMessage());
        }
    }
}
