# Connexion Frontend-Backend

Ce document explique comment la connexion entre le frontend React et le backend Spring Boot a été établie.

## Configuration

### Backend (Spring Boot)
- **Port** : 8081
- **URL de base** : `http://localhost:8081`
- **CORS** : Configuré pour accepter les requêtes depuis le frontend
- **JWT** : Authentification par token

### Frontend (React + TypeScript)
- **Port** : 5173 (Vite)
- **Bibliothèque HTTP** : Axios
- **Gestion d'état** : Context API + Hooks personnalisés

## Structure des fichiers

```
src/
├── config/
│   └── api.ts              # Configuration de l'API
├── services/
│   └── api.ts              # Services API avec Axios
├── hooks/
│   └── useApi.ts           # Hook personnalisé pour les appels API
├── contexts/
│   └── AuthContext.tsx     # Contexte d'authentification
└── components/
    └── ApiTest.tsx         # Composant de test de connexion
```

## Services API

### Authentification
```typescript
import { authService } from '../services/api';

// Connexion
const response = await authService.login({ email, password });

// Inscription
const response = await authService.register({ email, password, name, role });

// Déconnexion
const response = await authService.logout();
```

### Services d'entités
```typescript
import { clientService, factureService } from '../services/api';

// Récupérer tous les clients
const response = await clientService.getAll();

// Récupérer un client par ID
const response = await clientService.getById('123');

// Créer un nouveau client
const response = await clientService.create(clientData);

// Mettre à jour un client
const response = await clientService.update('123', updatedData);

// Supprimer un client
const response = await clientService.delete('123');
```

## Hook useApi

Le hook `useApi` simplifie la gestion des appels API :

```typescript
import { useApi } from '../hooks/useApi';
import { clientService } from '../services/api';

function MyComponent() {
  const { data, loading, error, execute } = useApi(clientService.getAll);

  const handleFetch = () => {
    execute();
  };

  return (
    <div>
      {loading && <p>Chargement...</p>}
      {error && <p>Erreur: {error}</p>}
      {data && <p>Données: {data.length} éléments</p>}
      <button onClick={handleFetch}>Charger les données</button>
    </div>
  );
}
```

## Gestion des erreurs

### Intercepteurs Axios
- **Requêtes** : Ajout automatique du token JWT
- **Réponses** : Gestion automatique des erreurs 401 (déconnexion)

### Gestion des erreurs dans les composants
```typescript
const { data, loading, error, execute } = useApi(clientService.getAll);

if (error) {
  return <div className="error">Erreur: {error}</div>;
}
```

## Authentification

### Connexion
1. L'utilisateur saisit ses identifiants
2. Le frontend appelle `authService.login()`
3. Le backend valide et retourne un token JWT
4. Le token est stocké dans `localStorage`
5. Les requêtes suivantes incluent automatiquement le token

### Protection des routes
```typescript
import { useAuth } from '../contexts/AuthContext';

function ProtectedComponent() {
  const { user, loading } = useAuth();

  if (loading) return <div>Chargement...</div>;
  if (!user) return <Navigate to="/login" />;

  return <div>Contenu protégé</div>;
}
```

## Test de la connexion

Un composant de test est disponible dans le tableau de bord administrateur :

1. Connectez-vous en tant qu'administrateur
2. Allez dans le tableau de bord administrateur
3. Utilisez le composant "Test de connexion API"
4. Vérifiez que la connexion fonctionne

## Endpoints disponibles

- **Authentification** : `/api/auth/*`
- **Clients** : `/api/v1/clients`
- **Techniciens** : `/api/v1/techniciens`
- **Compteurs** : `/api/v1/compteurs`
- **Factures** : `/api/v1/factures`
- **Réclamations** : `/api/v1/reclamations`
- **Incidents** : `/api/v1/incidents`
- **Tâches** : `/api/v1/taches`
- **Admins** : `/api/v1/admins`
- **RH** : `/api/v1/rh`

## Démarrage

1. **Backend** : Démarrer l'application Spring Boot
   ```bash
   cd "THE NEW BACKEND/THE NEW BACKEND"
   ./mvnw spring-boot:run
   ```

2. **Frontend** : Démarrer l'application React
   ```bash
   cd "New FrontEnd/project"
   pnpm dev
   ```

3. **Accéder à l'application** : `http://localhost:5173`

## Dépannage

### Erreur CORS
- Vérifiez que le backend est démarré sur le port 8081
- Vérifiez la configuration CORS dans `SecurityConfig.java`

### Erreur de connexion
- Vérifiez que la base de données PostgreSQL est accessible
- Vérifiez les logs du backend dans `run.log`

### Token expiré
- Le système déconnecte automatiquement l'utilisateur
- L'utilisateur doit se reconnecter

## Sécurité

- **JWT** : Tokens d'authentification sécurisés
- **CORS** : Configuration restrictive pour la production
- **Validation** : Validation côté serveur et client
- **HTTPS** : Recommandé pour la production
