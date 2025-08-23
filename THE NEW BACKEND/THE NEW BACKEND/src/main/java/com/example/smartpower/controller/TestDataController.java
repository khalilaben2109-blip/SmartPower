package com.example.smartpower.controller;

import com.example.smartpower.domain.*;
import com.example.smartpower.repository.*;
import com.example.smartpower.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/test")
@CrossOrigin(origins = "*")
public class TestDataController {

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

    @PostMapping("/init-data")
    public ResponseEntity<?> initializeTestData() {
        try {
            Map<String, Object> result = new HashMap<>();
            result.put("message", "Données de test initialisées avec succès");
            result.put("accounts", new HashMap<>());

            // Mot de passe encodé pour "password"
            String encodedPassword = passwordEncoder.encode("password");
            LocalDate currentDate = LocalDate.now();

            // Créer un Admin
            if (adminRepository.findByEmail("admin@example.com").isEmpty()) {
                Admin admin = new Admin();
                admin.setNom("Administrateur");
                admin.setPrenom("Principal");
                admin.setEmail("admin@example.com");
                admin.setTelephone("+33123456789");
                admin.setMotDePasse(encodedPassword);
                admin.setDateCreation(currentDate);
                admin.setStatutCompte("ACTIF");
                adminRepository.save(admin);
                result.put("admin_created", true);
            } else {
                result.put("admin_exists", true);
            }

            // Créer un Client
            if (clientRepository.findByEmail("client@example.com").isEmpty()) {
                Client client = new Client();
                client.setNom("Dupont");
                client.setPrenom("Jean");
                client.setEmail("client@example.com");
                client.setTelephone("+33987654321");
                client.setMotDePasse(encodedPassword);
                client.setDateCreation(currentDate);
                client.setStatutCompte("ACTIF");
                clientRepository.save(client);
                result.put("client_created", true);
            } else {
                result.put("client_exists", true);
            }

            // Créer un Technicien
            if (technicienRepository.findByEmail("technical@example.com").isEmpty()) {
                Technicien technicien = new Technicien();
                technicien.setNom("Durand");
                technicien.setPrenom("Pierre");
                technicien.setEmail("technical@example.com");
                technicien.setTelephone("+33555555555");
                technicien.setMotDePasse(encodedPassword);
                technicien.setDateCreation(currentDate);
                technicien.setStatutCompte("ACTIF");
                technicienRepository.save(technicien);
                result.put("technicien_created", true);
            } else {
                result.put("technicien_exists", true);
            }

            // Créer un RH
            if (rhRepository.findByEmail("hr@example.com").isEmpty()) {
                RH rh = new RH();
                rh.setNom("Bernard");
                rh.setPrenom("Sophie");
                rh.setEmail("hr@example.com");
                rh.setTelephone("+33444444444");
                rh.setMotDePasse(encodedPassword);
                rh.setDateCreation(currentDate);
                rh.setStatutCompte("ACTIF");
                rhRepository.save(rh);
                result.put("rh_created", true);
            } else {
                result.put("rh_exists", true);
            }

            return ResponseEntity.ok(result);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur lors de l'initialisation: " + e.getMessage());
        }
    }

    @GetMapping("/ping")
    public ResponseEntity<?> ping() {
        Map<String, Object> response = new HashMap<>();
        response.put("message", "Backend Spring Boot is running!");
        response.put("timestamp", System.currentTimeMillis());
        response.put("status", "success");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/users")
    public ResponseEntity<?> getAllUsers() {
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
}
