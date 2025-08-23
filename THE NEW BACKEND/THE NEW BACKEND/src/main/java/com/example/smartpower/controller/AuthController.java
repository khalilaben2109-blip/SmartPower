package com.example.smartpower.controller;

import com.example.smartpower.domain.*;
import com.example.smartpower.dto.LoginRequest;
import com.example.smartpower.dto.LoginResponse;
import com.example.smartpower.dto.RegisterRequest;
import com.example.smartpower.repository.*;
import com.example.smartpower.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth")
@CrossOrigin(origins = "*")
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager;

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

    @Autowired
    private JwtTokenProvider tokenProvider;

    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@RequestBody LoginRequest loginRequest) {
        try {
            // Validation des champs
            if (loginRequest.getEmail() == null || loginRequest.getEmail().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("L'email est requis");
            }
            if (loginRequest.getPassword() == null || loginRequest.getPassword().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le mot de passe est requis");
            }

            Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getEmail(), loginRequest.getPassword())
            );

            SecurityContextHolder.getContext().setAuthentication(authentication);
            String jwt = tokenProvider.generateToken(authentication);

            // Trouver l'utilisateur et ses informations
            LoginResponse userInfo = findUserInfo(loginRequest.getEmail());
            userInfo.setToken(jwt);

            return ResponseEntity.ok(userInfo);
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Email ou mot de passe incorrect");
        }
    }

    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody RegisterRequest registerRequest) {
        try {
            // Validation des champs
            if (registerRequest.getEmail() == null || registerRequest.getEmail().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("L'email est requis");
            }
            if (registerRequest.getPassword() == null || registerRequest.getPassword().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le mot de passe est requis");
            }
            if (registerRequest.getNom() == null || registerRequest.getNom().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le nom est requis");
            }
            if (registerRequest.getPrenom() == null || registerRequest.getPrenom().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le prénom est requis");
            }
            if (registerRequest.getRole() == null || registerRequest.getRole().trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le rôle est requis");
            }

            // Vérifier si l'email existe déjà
            if (adminRepository.findByEmail(registerRequest.getEmail()).isPresent() ||
                clientRepository.findByEmail(registerRequest.getEmail()).isPresent() ||
                rhRepository.findByEmail(registerRequest.getEmail()).isPresent() ||
                technicienRepository.findByEmail(registerRequest.getEmail()).isPresent()) {
                return ResponseEntity.badRequest().body("Email déjà utilisé");
            }

            String encodedPassword = passwordEncoder.encode(registerRequest.getPassword());

            switch (registerRequest.getRole().toUpperCase()) {
                case "ADMIN":
                    Admin admin = new Admin();
                    admin.setEmail(registerRequest.getEmail());
                    admin.setMotDePasse(encodedPassword);
                    admin.setNom(registerRequest.getNom());
                    admin.setPrenom(registerRequest.getPrenom());
                    admin.setTelephone(registerRequest.getTelephone());
                    adminRepository.save(admin);
                    break;

                case "CLIENT":
                    Client client = new Client();
                    client.setEmail(registerRequest.getEmail());
                    client.setMotDePasse(encodedPassword);
                    client.setNom(registerRequest.getNom());
                    client.setPrenom(registerRequest.getPrenom());
                    client.setTelephone(registerRequest.getTelephone());
                    clientRepository.save(client);
                    break;

                case "RH":
                    RH rh = new RH();
                    rh.setEmail(registerRequest.getEmail());
                    rh.setMotDePasse(encodedPassword);
                    rh.setNom(registerRequest.getNom());
                    rh.setPrenom(registerRequest.getPrenom());
                    rh.setTelephone(registerRequest.getTelephone());
                    rhRepository.save(rh);
                    break;

                case "TECHNICIEN":
                    Technicien technicien = new Technicien();
                    technicien.setEmail(registerRequest.getEmail());
                    technicien.setMotDePasse(encodedPassword);
                    technicien.setNom(registerRequest.getNom());
                    technicien.setPrenom(registerRequest.getPrenom());
                    technicien.setTelephone(registerRequest.getTelephone());
                    technicienRepository.save(technicien);
                    break;

                default:
                    return ResponseEntity.badRequest().body("Rôle invalide. Rôles acceptés: ADMIN, CLIENT, RH, TECHNICIEN");
            }

            return ResponseEntity.ok("Utilisateur enregistré avec succès");
        } catch (Exception e) {
            return ResponseEntity.badRequest().body("Erreur lors de l'enregistrement: " + e.getMessage());
        }
    }

    @GetMapping("/me")
    public ResponseEntity<?> getCurrentUser() {
        try {
            Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
            String email = authentication.getName();
            
            if (email == null || email.equals("anonymousUser")) {
                return ResponseEntity.status(401).body("Utilisateur non authentifié");
            }

            LoginResponse userInfo = findUserInfo(email);
            return ResponseEntity.ok(userInfo);
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Erreur lors de la récupération des informations utilisateur");
        }
    }

    // Méthode utilitaire pour trouver les informations utilisateur
    private LoginResponse findUserInfo(String email) {
        String role = "";
        Long userId = null;
        String nom = "";
        String prenom = "";

        // Chercher dans Admin
        Admin admin = adminRepository.findByEmail(email).orElse(null);
        if (admin != null) {
            role = "ROLE_ADMIN";
            userId = admin.getId();
            nom = admin.getNom();
            prenom = admin.getPrenom();
        }

        // Chercher dans Client
        Client client = clientRepository.findByEmail(email).orElse(null);
        if (client != null) {
            role = "ROLE_CLIENT";
            userId = client.getId();
            nom = client.getNom();
            prenom = client.getPrenom();
        }

        // Chercher dans RH
        RH rh = rhRepository.findByEmail(email).orElse(null);
        if (rh != null) {
            role = "ROLE_RH";
            userId = rh.getId();
            nom = rh.getNom();
            prenom = rh.getPrenom();
        }

        // Chercher dans Technicien
        Technicien technicien = technicienRepository.findByEmail(email).orElse(null);
        if (technicien != null) {
            role = "ROLE_TECHNICIEN";
            userId = technicien.getId();
            nom = technicien.getNom();
            prenom = technicien.getPrenom();
        }

        return new LoginResponse("", "Bearer", email, role, userId, nom, prenom);
    }
}
