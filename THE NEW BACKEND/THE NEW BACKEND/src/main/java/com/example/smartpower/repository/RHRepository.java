package com.example.smartpower.repository;

import com.example.smartpower.domain.RH;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.rest.core.annotation.RepositoryRestResource;

@RepositoryRestResource(path = "rhs")
public interface RHRepository extends JpaRepository<RH, Long> {
    java.util.Optional<RH> findByEmail(String email);
}


