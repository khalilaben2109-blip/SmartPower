package com.example.smartpower.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
@Entity
@Table(name = "techniciens")
public class Technicien extends Utilisateur {
    private String codeAgent;
    private String zoneGeographique;
    private String specialite;
}


