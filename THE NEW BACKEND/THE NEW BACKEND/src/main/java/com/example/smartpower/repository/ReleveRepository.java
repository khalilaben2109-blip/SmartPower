package com.example.smartpower.repository;

import com.example.smartpower.domain.Releve;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "releves")
public interface ReleveRepository extends JpaRepository<Releve, Long> {}
