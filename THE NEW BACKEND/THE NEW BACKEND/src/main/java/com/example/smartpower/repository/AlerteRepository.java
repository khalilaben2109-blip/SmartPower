package com.example.smartpower.repository;

import com.example.smartpower.domain.Alerte;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "alertes")
public interface AlerteRepository extends JpaRepository<Alerte, Long> {}
