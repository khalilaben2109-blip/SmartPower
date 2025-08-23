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
    private AdminRepository adminRepository;

    @Autowired
    private ClientRepository clientRepository;

    @Autowired
    private RHRepository rhRepository;

    @Autowired
    private TechnicienRepository technicienRepository;

    @Override
    public UserDetails loadUserByUsername(String email) throws UsernameNotFoundException {
        // Chercher dans Admin
        Admin admin = adminRepository.findByEmail(email).orElse(null);
        if (admin != null) {
            return new User(admin.getEmail(), admin.getMotDePasse(), 
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_ADMIN")));
        }

        // Chercher dans Client
        Client client = clientRepository.findByEmail(email).orElse(null);
        if (client != null) {
            return new User(client.getEmail(), client.getMotDePasse(), 
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_CLIENT")));
        }

        // Chercher dans RH
        RH rh = rhRepository.findByEmail(email).orElse(null);
        if (rh != null) {
            return new User(rh.getEmail(), rh.getMotDePasse(), 
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_RH")));
        }

        // Chercher dans Technicien
        Technicien technicien = technicienRepository.findByEmail(email).orElse(null);
        if (technicien != null) {
            return new User(technicien.getEmail(), technicien.getMotDePasse(), 
                Collections.singletonList(new SimpleGrantedAuthority("ROLE_TECHNICIEN")));
        }

        throw new UsernameNotFoundException("Utilisateur non trouvé avec l'email: " + email);
    }
}
