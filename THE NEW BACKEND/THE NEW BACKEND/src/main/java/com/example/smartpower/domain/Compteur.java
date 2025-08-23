package com.example.smartpower.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.util.HashSet;
import java.util.Set;

@Getter
@Setter
@Entity
@Table(name = "compteurs")
public class Compteur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(unique = true)
    private String numeroSerie;
    private String typeCompteur;
    private String typeAbonnement;
    private float puissanceSouscrite;
    private java.time.LocalDate dateInstallation;
    private String statutCompteur;
    private float tension;
    private int phase;
    private float consommationMensuelle;
    private boolean typeCompteurIntelligent;

    @ManyToOne(optional = false)
    private Client client;

    @OneToMany(mappedBy = "compteur", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Releve> releves = new HashSet<>();

    @OneToMany(mappedBy = "compteur", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<Incident> incidents = new HashSet<>();
}


