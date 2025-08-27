package com.example.smartpower.repository;

import com.example.smartpower.domain.Compteur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

import java.util.List;
import java.util.Optional;

@RepositoryRestResource(path = "compteurs")
public interface CompteurRepository extends JpaRepository<Compteur, Long> {
    
    Optional<Compteur> findByNumeroSerie(String numeroSerie);
    
    List<Compteur> findByNumeroSerieContainingIgnoreCase(String numeroSerie);
}
