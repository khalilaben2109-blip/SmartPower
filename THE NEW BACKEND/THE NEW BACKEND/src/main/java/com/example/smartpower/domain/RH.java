package com.example.smartpower.domain;

import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "rhs")
public class RH extends Utilisateur {
    private String departement;
}


