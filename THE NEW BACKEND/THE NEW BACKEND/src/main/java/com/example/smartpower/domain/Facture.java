package com.example.smartpower.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "factures")
public class Facture {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private double montant;
    private LocalDate dateEmission;
    private LocalDate dateEcheance;
    private String statutPaiement;
    private float consommationMois;
    private String moyenPaiement;

    @ManyToOne(optional = false)
    private Client client;
}


