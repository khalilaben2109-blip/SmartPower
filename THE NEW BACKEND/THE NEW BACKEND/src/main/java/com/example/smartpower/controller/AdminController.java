package com.example.smartpower.controller;

import com.example.smartpower.domain.*;
import com.example.smartpower.repository.*;
import com.example.smartpower.security.JwtTokenProvider;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequestMapping("/api/admin")
@CrossOrigin(origins = "*")
public class AdminController {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private RHRepository rhRepository;

    @Autowired
    private TechnicienRepository technicienRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private JwtTokenProvider tokenProvider;

    // Vérifier si l'utilisateur connecté est un admin
    private boolean isCurrentUserAdmin() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }

        String email = authentication.getName();
        Optional<Utilisateur> userOpt = utilisateurRepository.findByEmail(email);
        if (userOpt.isEmpty()) {
            return false;
        }

        Utilisateur user = userOpt.get();
        return adminRepository.existsById(user.getId());
    }

    // Récupérer tous les utilisateurs (RH et Techniciens)
    @GetMapping("/users")
    public ResponseEntity<?> getAllUsers() {
        if (!isCurrentUserAdmin()) {
            return ResponseEntity.status(403).body("Accès refusé: droits administrateur requis");
        }

        try {
            List<Map<String, Object>> users = new java.util.ArrayList<>();

            // Récupérer les RH
            List<RH> rhs = rhRepository.findAll();
            for (RH rh : rhs) {
                Optional<Utilisateur> userOpt = utilisateurRepository.findById(rh.getId());
                if (userOpt.isPresent()) {
                    Utilisateur user = userOpt.get();
                    Map<String, Object> userMap = new HashMap<>();
                    userMap.put("id", user.getId());
                    userMap.put("email", user.getEmail());
                    userMap.put("nom", user.getNom());
                    userMap.put("prenom", user.getPrenom());
                    userMap.put("role", "RH");
                    userMap.put("telephone", user.getTelephone());
                    userMap.put("statut_compte", user.getStatutCompte());
                    userMap.put("date_creation", user.getDateCreation());
                    users.add(userMap);
                }
            }

            // Récupérer les Techniciens
            List<Technicien> techniciens = technicienRepository.findAll();
            for (Technicien technicien : techniciens) {
                Optional<Utilisateur> userOpt = utilisateurRepository.findById(technicien.getId());
                if (userOpt.isPresent()) {
                    Utilisateur user = userOpt.get();
                    Map<String, Object> userMap = new HashMap<>();
                    userMap.put("id", user.getId());
                    userMap.put("email", user.getEmail());
                    userMap.put("nom", user.getNom());
                    userMap.put("prenom", user.getPrenom());
                    userMap.put("role", "TECHNICIEN");
                    userMap.put("telephone", user.getTelephone());
                    userMap.put("statut_compte", user.getStatutCompte());
                    userMap.put("date_creation", user.getDateCreation());
                    users.add(userMap);
                }
            }

            return ResponseEntity.ok(users);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la récupération des utilisateurs");
        }
    }

    // Créer un nouvel utilisateur (RH ou Technicien)
    @PostMapping("/users")
    public ResponseEntity<?> createUser(@RequestBody Map<String, Object> request) {
        if (!isCurrentUserAdmin()) {
            return ResponseEntity.status(403).body("Accès refusé: droits administrateur requis");
        }

        try {
            // Validation des champs
            String email = (String) request.get("email");
            String password = (String) request.get("password");
            String nom = (String) request.get("nom");
            String prenom = (String) request.get("prenom");
            String role = (String) request.get("role");
            String telephone = (String) request.get("telephone");

            if (email == null || email.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("L'email est requis");
            }
            if (password == null || password.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le mot de passe est requis");
            }
            if (nom == null || nom.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le nom est requis");
            }
            if (prenom == null || prenom.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le prénom est requis");
            }
            if (role == null || (!role.equals("RH") && !role.equals("TECHNICIEN"))) {
                return ResponseEntity.badRequest().body("Le rôle doit être RH ou TECHNICIEN");
            }
            if (telephone == null || telephone.trim().isEmpty()) {
                return ResponseEntity.badRequest().body("Le téléphone est requis");
            }

            // Vérifier si l'email existe déjà
            if (utilisateurRepository.findByEmail(email).isPresent()) {
                return ResponseEntity.badRequest().body("Un utilisateur avec cet email existe déjà");
            }

            // Créer l'utilisateur avec le bon rôle
            if (role.equals("RH")) {
                RH rh = new RH();
                rh.setEmail(email.trim());
                rh.setMotDePasse(passwordEncoder.encode(password));
                rh.setNom(nom.trim());
                rh.setPrenom(prenom.trim());
                rh.setTelephone(telephone.trim());
                rh.setDateCreation(LocalDate.now());
                rh.setStatutCompte("ACTIF");
                rh.setDepartement("Ressources Humaines"); // Valeur par défaut
                
                RH savedRH = rhRepository.save(rh);
                
                Map<String, Object> response = new HashMap<>();
                response.put("message", "Utilisateur RH créé avec succès");
                response.put("userId", savedRH.getId());
                response.put("email", savedRH.getEmail());
                response.put("role", "RH");
                
                return ResponseEntity.ok(response);
                
            } else if (role.equals("TECHNICIEN")) {
                Technicien technicien = new Technicien();
                technicien.setEmail(email.trim());
                technicien.setMotDePasse(passwordEncoder.encode(password));
                technicien.setNom(nom.trim());
                technicien.setPrenom(prenom.trim());
                technicien.setTelephone(telephone.trim());
                technicien.setDateCreation(LocalDate.now());
                technicien.setStatutCompte("ACTIF");
                technicien.setCodeAgent("TECH" + System.currentTimeMillis()); // Code unique
                technicien.setZoneGeographique("Zone par défaut");
                technicien.setSpecialite("Général");
                
                Technicien savedTechnicien = technicienRepository.save(technicien);
                
                Map<String, Object> response = new HashMap<>();
                response.put("message", "Utilisateur Technicien créé avec succès");
                response.put("userId", savedTechnicien.getId());
                response.put("email", savedTechnicien.getEmail());
                response.put("role", "TECHNICIEN");
                
                return ResponseEntity.ok(response);
            }

            // Cette partie est maintenant gérée dans les blocs if/else ci-dessus
            return ResponseEntity.badRequest().body("Rôle non reconnu");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la création de l'utilisateur");
        }
    }

    // Supprimer un utilisateur
    @DeleteMapping("/users/{userId}")
    public ResponseEntity<?> deleteUser(@PathVariable Long userId) {
        if (!isCurrentUserAdmin()) {
            return ResponseEntity.status(403).body("Accès refusé: droits administrateur requis");
        }

        try {
            Optional<Utilisateur> userOpt = utilisateurRepository.findById(userId);
            if (userOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Utilisateur user = userOpt.get();

            // Supprimer le rôle spécifique
            if (rhRepository.existsById(userId)) {
                rhRepository.deleteById(userId);
            } else if (technicienRepository.existsById(userId)) {
                technicienRepository.deleteById(userId);
            }

            // Supprimer l'utilisateur
            utilisateurRepository.deleteById(userId);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Utilisateur supprimé avec succès");
            response.put("userId", userId);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la suppression de l'utilisateur");
        }
    }

    // Modifier le statut d'un utilisateur
    @PutMapping("/users/{userId}/status")
    public ResponseEntity<?> updateUserStatus(@PathVariable Long userId, @RequestBody Map<String, String> request) {
        if (!isCurrentUserAdmin()) {
            return ResponseEntity.status(403).body("Accès refusé: droits administrateur requis");
        }

        try {
            String newStatus = request.get("status");
            if (newStatus == null || (!newStatus.equals("ACTIF") && !newStatus.equals("INACTIF"))) {
                return ResponseEntity.badRequest().body("Le statut doit être ACTIF ou INACTIF");
            }

            Optional<Utilisateur> userOpt = utilisateurRepository.findById(userId);
            if (userOpt.isEmpty()) {
                return ResponseEntity.notFound().build();
            }

            Utilisateur user = userOpt.get();
            user.setStatutCompte(newStatus);
            utilisateurRepository.save(user);

            Map<String, Object> response = new HashMap<>();
            response.put("message", "Statut utilisateur mis à jour avec succès");
            response.put("userId", userId);
            response.put("status", newStatus);

            return ResponseEntity.ok(response);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(500).body("Erreur lors de la mise à jour du statut");
        }
    }
}
