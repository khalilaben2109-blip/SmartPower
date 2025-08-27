package com.example.smartpower.domain;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDate;

@Getter
@Setter
@Entity
@Table(name = "reclamations")
public class Reclamation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private LocalDate dateCreation;
    private String description;
    private String statut;
    private String typeReclamation;
    private Integer priorite;

    @ManyToOne(optional = false)
    private Utilisateur utilisateur;

    @ManyToOne
    private Technicien technicienTraiteur;
    
    // Nouveaux champs pour les réclamations des techniciens
    @ManyToOne
    private Technicien technicienExpediteur;
    
    @ManyToOne
    private Utilisateur destinataire; // Peut être RH ou Admin
    
    private String titre;
    private String categorie; // "TECHNIQUE", "MATERIEL", "FORMATION", "AUTRE"
}


