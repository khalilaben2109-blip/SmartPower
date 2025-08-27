-- Ajouter les nouvelles colonnes à la table reclamations
-- Vérifier d'abord si les colonnes existent déjà

-- Ajouter la colonne technicien_expediteur_id si elle n'existe pas
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'reclamations' AND column_name = 'technicien_expediteur_id') THEN
        ALTER TABLE reclamations ADD COLUMN technicien_expediteur_id BIGINT;
    END IF;
END $$;

-- Ajouter la colonne destinataire_id si elle n'existe pas
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'reclamations' AND column_name = 'destinataire_id') THEN
        ALTER TABLE reclamations ADD COLUMN destinataire_id BIGINT;
    END IF;
END $$;

-- Ajouter la colonne titre si elle n'existe pas
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'reclamations' AND column_name = 'titre') THEN
        ALTER TABLE reclamations ADD COLUMN titre VARCHAR(255);
    END IF;
END $$;

-- Ajouter la colonne categorie si elle n'existe pas
DO $$ 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns 
                   WHERE table_name = 'reclamations' AND column_name = 'categorie') THEN
        ALTER TABLE reclamations ADD COLUMN categorie VARCHAR(50);
    END IF;
END $$;

-- Ajouter les contraintes de clé étrangère si elles n'existent pas
DO $$ 
BEGIN
    -- Contrainte pour technicien_expediteur_id
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE table_name = 'reclamations' 
                   AND constraint_name = 'fk_reclamations_technicien_expediteur') THEN
        ALTER TABLE reclamations 
        ADD CONSTRAINT fk_reclamations_technicien_expediteur 
        FOREIGN KEY (technicien_expediteur_id) REFERENCES techniciens(id);
    END IF;
    
    -- Contrainte pour destinataire_id
    IF NOT EXISTS (SELECT 1 FROM information_schema.table_constraints 
                   WHERE table_name = 'reclamations' 
                   AND constraint_name = 'fk_reclamations_destinataire') THEN
        ALTER TABLE reclamations 
        ADD CONSTRAINT fk_reclamations_destinataire 
        FOREIGN KEY (destinataire_id) REFERENCES utilisateurs(id);
    END IF;
END $$;

-- Vérifier la structure finale
SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns 
WHERE table_name = 'reclamations'
ORDER BY ordinal_position;
