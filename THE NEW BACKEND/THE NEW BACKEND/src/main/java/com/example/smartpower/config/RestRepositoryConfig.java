package com.example.smartpower.config;

import com.example.smartpower.domain.*;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.rest.core.config.RepositoryRestConfiguration;
import org.springframework.data.rest.webmvc.config.RepositoryRestConfigurer;
import org.springframework.web.servlet.config.annotation.CorsRegistry;

@Configuration
public class RestRepositoryConfig implements RepositoryRestConfigurer {
    @Override
    public void configureRepositoryRestConfiguration(RepositoryRestConfiguration config, CorsRegistry cors) {
        config.setBasePath("/api");
        config.exposeIdsFor(
                Utilisateur.class,
                Admin.class,
                RH.class,
                Technicien.class,
                Client.class,
                Tache.class,
                Compteur.class,
                Releve.class,
                Facture.class,
                Reclamation.class,
                Alerte.class,
                Incident.class
        );
    }
}


