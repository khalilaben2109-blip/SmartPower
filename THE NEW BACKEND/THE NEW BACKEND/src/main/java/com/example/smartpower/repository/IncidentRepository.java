package com.example.smartpower.repository;

import com.example.smartpower.domain.Incident;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "incidents")
public interface IncidentRepository extends JpaRepository<Incident, Long> {}
