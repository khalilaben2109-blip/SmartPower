# 🚀 SmartPower - Gestion Intelligente des Compteurs Électriques

## 📋 Description

SmartPower est une application web moderne pour la gestion intelligente des compteurs électriques. Elle permet aux administrateurs, techniciens, RH et clients de gérer efficacement les compteurs, factures, réclamations et incidents.

## 🏗️ Architecture

- **Frontend** : React.js + TypeScript + Vite + Tailwind CSS
- **Backend** : Spring Boot + Java + Maven
- **Base de données** : PostgreSQL 17
- **Authentification** : JWT (JSON Web Tokens)
- **Sécurité** : Spring Security + BCrypt

## 🚀 Installation et Démarrage

### Prérequis

- **Node.js** (version 18 ou supérieure)
- **Java** (version 17 ou supérieure)
- **Maven** (version 3.6 ou supérieure)
- **PostgreSQL** (version 17)
- **pnpm** (gestionnaire de paquets)

### 1. Configuration de la Base de Données

```sql
-- Créer la base de données
CREATE DATABASE SmartCompteur;

-- Exécuter le script de correction du mot de passe admin
UPDATE public.utilisateurs 
SET mot_de_passe = '$2a$10$RA6xurVkMcS1hkT3y2Y4kOqpECjT0m4amsI9kDWWrehP5HgcvoX.S'
WHERE email = 'admin@gmail.com';
```

### 2. Configuration Backend

1. **Naviguer vers le dossier backend :**
   ```bash
   cd "THE NEW BACKEND/THE NEW BACKEND"
   ```

2. **Configurer la base de données** dans `src/main/resources/application.properties` :
   ```properties
   spring.datasource.url=jdbc:postgresql://localhost:5432/SmartCompteur
   spring.datasource.username=postgres
   spring.datasource.password=admin
   ```

3. **Démarrer le backend :**
   ```bash
   mvn spring-boot:run
   ```

### 3. Configuration Frontend

1. **Naviguer vers le dossier frontend :**
   ```bash
   cd "New FrontEnd/project"
   ```

2. **Installer les dépendances :**
   ```bash
   pnpm install
   ```

3. **Démarrer le frontend :**
   ```bash
   pnpm dev
   ```

## 🔐 Comptes de Test

### Administrateur
- **Email** : `admin@gmail.com`
- **Mot de passe** : `admin`
- **Rôle** : `ROLE_ADMIN`

## 📱 Accès à l'Application

- **Frontend** : http://localhost:5173
- **Backend API** : http://localhost:8081
- **Base de données** : localhost:5432

## 🛠️ Scripts Utiles

### Scripts PowerShell (Windows)

```powershell
# Test d'authentification
.\test-auth-simple.ps1

# Test complet du frontend
.\test-frontend-auth.ps1

# Lancement du projet
.\launch-project.ps1
```

### Scripts Batch (Windows)

```batch
# Lancement simple
start-simple.bat

# Lancement complet
start-complete.bat
```

## 📁 Structure du Projet

```
SmartPower/
├── New FrontEnd/
│   └── project/                 # Frontend React
│       ├── src/
│       │   ├── components/      # Composants React
│       │   ├── pages/          # Pages de l'application
│       │   ├── contexts/       # Contextes React (Auth)
│       │   ├── services/       # Services API
│       │   ├── config/         # Configuration
│       │   └── hooks/          # Hooks personnalisés
│       └── package.json
├── THE NEW BACKEND/
│   └── THE NEW BACKEND/        # Backend Spring Boot
│       ├── src/main/java/
│       │   └── com/example/smartpower/
│       │       ├── controller/ # Contrôleurs REST
│       │       ├── domain/     # Entités JPA
│       │       ├── repository/ # Repositories
│       │       ├── security/   # Configuration sécurité
│       │       └── dto/        # Objets de transfert
│       └── pom.xml
└── README.md
```

## 🔧 API Endpoints

### Authentification
- `POST /api/auth/login` - Connexion
- `POST /api/auth/register` - Inscription
- `POST /api/auth/logout` - Déconnexion

### Gestion des Utilisateurs
- `GET /api/v1/clients` - Liste des clients
- `GET /api/v1/techniciens` - Liste des techniciens
- `GET /api/v1/admins` - Liste des administrateurs
- `GET /api/v1/rh` - Liste des RH

### Tests
- `GET /api/test/ping` - Test de connexion
- `GET /api/existing/test-login` - Test des comptes existants

## 🎨 Fonctionnalités

### ✅ Implémentées
- [x] Authentification JWT
- [x] Dashboard administrateur
- [x] Gestion des utilisateurs
- [x] Interface responsive
- [x] API REST sécurisée
- [x] Base de données PostgreSQL

### 🚧 En développement
- [ ] Gestion des compteurs
- [ ] Gestion des factures
- [ ] Gestion des réclamations
- [ ] Gestion des incidents
- [ ] Notifications en temps réel

## 🛡️ Sécurité

- **Authentification** : JWT avec expiration
- **Mots de passe** : Encodage BCrypt
- **CORS** : Configuration sécurisée
- **Validation** : Validation des entrées
- **Autorisation** : Rôles et permissions

## 🐛 Dépannage

### Problème d'authentification
1. Vérifier que la base de données est connectée
2. Exécuter le script SQL de correction du mot de passe
3. Redémarrer le backend

### Problème de connexion frontend-backend
1. Vérifier que le backend tourne sur le port 8081
2. Vérifier la configuration CORS
3. Vérifier les logs du navigateur (F12)

### Problème de base de données
1. Vérifier que PostgreSQL est démarré
2. Vérifier les paramètres de connexion
3. Vérifier que la base `SmartCompteur` existe

## 📞 Support

Pour toute question ou problème :
1. Vérifier les logs du backend
2. Vérifier la console du navigateur (F12)
3. Consulter ce README
4. Vérifier la configuration de la base de données

## 📄 Licence

Ce projet est développé dans le cadre d'un stage de formation.

---

**Développé avec ❤️ par l'équipe SmartPower**
