package com.example.smartpower.repository;

import com.example.smartpower.domain.Compteur;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "compteurs")
public interface CompteurRepository extends JpaRepository<Compteur, Long> {}
