package com.example.smartpower.security;

import com.example.smartpower.domain.*;
import com.example.smartpower.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.Collections;

@Service
public class CustomUserDetailsService implements UserDetailsService {

    @Autowired
    private UtilisateurRepository utilisateurRepository;

    @Autowired
    private AdminRepository adminRepository;

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private RHRepository rhRepository;

    @Autowired
    private TechnicienRepository technicienRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        System.out.println("DEBUG: Recherche de l'utilisateur avec l'email: " + email);
        
        // Chercher dans la table utilisateurs
        Utilisateur utilisateur = utilisateurRepository.findByEmail(email).orElse(null);
        if (utilisateur != null) {
            System.out.println("DEBUG: Utilisateur trouvé dans utilisateurs - ID: " + utilisateur.getId());
            String role = determineRole(utilisateur.getId());
            System.out.println("DEBUG: Rôle déterminé: " + role);
            return new User(utilisateur.getEmail(), utilisateur.getMotDePasse(), 
                Collections.singletonList(new SimpleGrantedAuthority(role)));
        } else {
            System.out.println("DEBUG: Utilisateur NON trouvé dans utilisateurs");
        }

        throw new UsernameNotFoundException("Utilisateur non trouvé avec l'email: " + email);
    }

    private String determineRole(Long userId) {
        System.out.println("DEBUG: Détermination du rôle pour l'ID: " + userId);
        
        if (adminRepository.findById(userId).isPresent()) {
            System.out.println("DEBUG: Utilisateur trouvé dans admins");
            return "ROLE_ADMIN";
        } else if (clientRepository.findById(userId).isPresent()) {
            System.out.println("DEBUG: Utilisateur trouvé dans clients");
            return "ROLE_CLIENT";
        } else if (rhRepository.findById(userId).isPresent()) {
            System.out.println("DEBUG: Utilisateur trouvé dans rhs");
            return "ROLE_RH";
        } else if (technicienRepository.findById(userId).isPresent()) {
            System.out.println("DEBUG: Utilisateur trouvé dans techniciens");
            return "ROLE_TECHNICIEN";
        } else {
            System.out.println("DEBUG: Utilisateur NON trouvé dans aucune table de rôle");
            return "ROLE_USER";
        }
    }
}
