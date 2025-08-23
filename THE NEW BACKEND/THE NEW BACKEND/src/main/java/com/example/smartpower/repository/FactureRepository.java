package com.example.smartpower.repository;

import com.example.smartpower.domain.Facture;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "factures")
public interface FactureRepository extends JpaRepository<Facture, Long> {}
