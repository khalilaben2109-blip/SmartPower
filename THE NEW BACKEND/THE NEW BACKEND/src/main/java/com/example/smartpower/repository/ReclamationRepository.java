package com.example.smartpower.repository;

import com.example.smartpower.domain.Reclamation;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "reclamations")
public interface ReclamationRepository extends JpaRepository<Reclamation, Long> {}
