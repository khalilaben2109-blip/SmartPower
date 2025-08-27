import React, { useState, useEffect } from 'react';
import { Plus, Search, Edit, Trash2, Zap, User, RefreshCw, AlertCircle, Link, Unlink } from 'lucide-react';
import { technicienService, Compteur, Client, CreateCompteurRequest } from '../services/technicienService';
import CompteurModal from '../components/CompteurModal';

export default function TechnicienCompteursPage() {
  const [compteurs, setCompteurs] = useState<Compteur[]>([]);
  const [clients, setClients] = useState<Client[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [searchTerm, setSearchTerm] = useState('');
  const [modalOpen, setModalOpen] = useState(false);
  const [modalMode, setModalMode] = useState<'create' | 'edit'>('create');
  const [selectedCompteur, setSelectedCompteur] = useState<Compteur | null>(null);
  const [actionLoading, setActionLoading] = useState<number | null>(null);

  // Charger les données
  const loadData = async () => {
    setLoading(true);
    setError(null);
    try {
      const [compteursData, clientsData] = await Promise.all([
        technicienService.getAllCompteurs(),
        technicienService.getAllClients()
      ]);
      setCompteurs(compteursData);
      setClients(clientsData);
    } catch (err) {
      console.error('Erreur loadData:', err);
      setError('Erreur lors du chargement des données');
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    loadData();
  }, []);

  // Créer un compteur
  const handleCreateCompteur = async (compteurData: CreateCompteurRequest) => {
    try {
      await technicienService.createCompteur(compteurData);
      await loadData(); // Recharger la liste
    } catch (err) {
      throw err;
    }
  };

  // Affecter un compteur à un client
  const handleAffecterCompteur = async (compteurId: number, clientId: number) => {
    setActionLoading(compteurId);
    try {
      await technicienService.affecterCompteurAClient(compteurId, clientId);
      await loadData(); // Recharger la liste
    } catch (err) {
      alert('Erreur lors de l\'affectation du compteur');
      console.error('Erreur affecterCompteur:', err);
    } finally {
      setActionLoading(null);
    }
  };

  // Désaffecter un compteur
  const handleDesaffecterCompteur = async (compteurId: number) => {
    if (!window.confirm('Êtes-vous sûr de vouloir désaffecter ce compteur ?')) {
      return;
    }

    setActionLoading(compteurId);
    try {
      await technicienService.desaffecterCompteur(compteurId);
      await loadData(); // Recharger la liste
    } catch (err) {
      alert('Erreur lors de la désaffectation du compteur');
      console.error('Erreur desaffecterCompteur:', err);
    } finally {
      setActionLoading(null);
    }
  };

  // Changer le statut d'un compteur
  const handleToggleStatus = async (compteurId: number, currentStatus: string) => {
    const newStatus = currentStatus === 'ACTIF' ? 'INACTIF' : 'ACTIF';
    
    setActionLoading(compteurId);
    try {
      await technicienService.updateCompteurStatus(compteurId, newStatus);
      await loadData(); // Recharger la liste
    } catch (err) {
      alert('Erreur lors du changement de statut');
      console.error('Erreur toggleStatus:', err);
    } finally {
      setActionLoading(null);
    }
  };

  // Ouvrir le modal de création
  const openCreateModal = () => {
    setModalMode('create');
    setSelectedCompteur(null);
    setModalOpen(true);
  };

  // Filtrer les compteurs
  const filteredCompteurs = compteurs.filter(compteur => {
    const matchesSearch = compteur.numeroSerie.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         compteur.typeCompteur.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         (compteur.client && `${compteur.client.nom} ${compteur.client.prenom}`.toLowerCase().includes(searchTerm.toLowerCase()));
    return matchesSearch;
  });

  // Obtenir le badge de statut
  const getStatusBadge = (status: string) => {
    switch (status) {
      case 'ACTIF':
        return <span className="px-2 py-1 text-xs font-medium bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200 rounded-full">Actif</span>;
      case 'INACTIF':
        return <span className="px-2 py-1 text-xs font-medium bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200 rounded-full">Inactif</span>;
      case 'MAINTENANCE':
        return <span className="px-2 py-1 text-xs font-medium bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200 rounded-full">Maintenance</span>;
      default:
        return <span className="px-2 py-1 text-xs font-medium bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200 rounded-full">{status}</span>;
    }
  };

  // Affichage de l'erreur
  if (error) {
    return (
      <div className="space-y-6">
        <div className="flex items-center justify-between">
          <div>
            <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
              Gestion des Compteurs
            </h1>
            <p className="text-gray-600 dark:text-gray-400">
              Créez et gérez les compteurs électriques
            </p>
          </div>
        </div>
        
        <div className="bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-lg p-4">
          <div className="flex items-center space-x-3">
            <AlertCircle className="h-5 w-5 text-red-500" />
            <div>
              <h3 className="text-sm font-medium text-red-800 dark:text-red-200">
                Erreur de chargement
              </h3>
              <p className="text-sm text-red-700 dark:text-red-300 mt-1">
                {error}
              </p>
            </div>
          </div>
          <button
            onClick={loadData}
            className="mt-3 bg-red-600 hover:bg-red-700 text-white px-3 py-1 rounded text-sm transition-colors"
          >
            Réessayer
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Gestion des Compteurs
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Créez et gérez les compteurs électriques
          </p>
        </div>
        
        <div className="flex items-center space-x-3">
          <button
            onClick={loadData}
            disabled={loading}
            className="p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-gray-700 rounded-lg transition-colors disabled:opacity-50"
            title="Actualiser"
          >
            <RefreshCw className={`h-5 w-5 ${loading ? 'animate-spin' : ''}`} />
          </button>
          
          <button
            onClick={openCreateModal}
            className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center space-x-2"
          >
            <Plus className="h-4 w-4" />
            <span>Nouveau Compteur</span>
          </button>
        </div>
      </div>

      {/* Barre de recherche */}
      <div className="flex items-center space-x-4">
        <div className="flex-1 max-w-md">
          <div className="relative">
            <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-4 w-4 text-gray-400" />
            <input
              type="text"
              placeholder="Rechercher par numéro de série, type ou client..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:ring-2 focus:ring-blue-500 focus:border-transparent"
            />
          </div>
        </div>
      </div>

      {/* Tableau des compteurs */}
      <div className="bg-white dark:bg-gray-800 shadow-sm rounded-lg overflow-hidden">
        <div className="overflow-x-auto">
          <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
            <thead className="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Compteur
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Type
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Client
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Statut
                </th>
                <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
              {loading ? (
                <tr>
                  <td colSpan={5} className="px-6 py-4 text-center text-gray-500 dark:text-gray-400">
                    <div className="flex items-center justify-center space-x-2">
                      <RefreshCw className="h-5 w-5 animate-spin" />
                      <span>Chargement...</span>
                    </div>
                  </td>
                </tr>
              ) : filteredCompteurs.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-6 py-4 text-center text-gray-500 dark:text-gray-400">
                    Aucun compteur trouvé
                  </td>
                </tr>
              ) : (
                filteredCompteurs.map((compteur) => (
                  <tr key={compteur.id} className="hover:bg-gray-50 dark:hover:bg-gray-700">
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div>
                        <div className="text-sm font-medium text-gray-900 dark:text-white">
                          {compteur.numeroSerie}
                        </div>
                        <div className="text-sm text-gray-500 dark:text-gray-400">
                          {compteur.puissanceSouscrite} kVA • {compteur.tension}V • {compteur.phase} phase{compteur.phase > 1 ? 's' : ''}
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      <div>
                        <div className="text-sm text-gray-900 dark:text-white">
                          {compteur.typeCompteur}
                        </div>
                        <div className="text-sm text-gray-500 dark:text-gray-400">
                          {compteur.typeAbonnement}
                        </div>
                        {compteur.typeCompteurIntelligent && (
                          <div className="text-xs text-blue-600 dark:text-blue-400">
                            Intelligent
                          </div>
                        )}
                      </div>
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      {compteur.client ? (
                        <div className="flex items-center space-x-2">
                          <User className="h-4 w-4 text-gray-400" />
                          <div>
                            <div className="text-sm font-medium text-gray-900 dark:text-white">
                              {compteur.client.nom} {compteur.client.prenom}
                            </div>
                            <div className="text-sm text-gray-500 dark:text-gray-400">
                              {compteur.client.email}
                            </div>
                          </div>
                        </div>
                      ) : (
                        <span className="text-sm text-gray-500 dark:text-gray-400">Non affecté</span>
                      )}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap">
                      {getStatusBadge(compteur.statutCompteur)}
                    </td>
                    <td className="px-6 py-4 whitespace-nowrap text-sm font-medium">
                      <div className="flex items-center space-x-2">
                        <button
                          onClick={() => handleToggleStatus(compteur.id, compteur.statutCompteur)}
                          disabled={actionLoading === compteur.id}
                          className="text-blue-600 hover:text-blue-900 dark:text-blue-400 dark:hover:text-blue-300 disabled:opacity-50"
                          title="Changer le statut"
                        >
                          <Zap className="h-4 w-4" />
                        </button>
                        
                        {compteur.client ? (
                          <button
                            onClick={() => handleDesaffecterCompteur(compteur.id)}
                            disabled={actionLoading === compteur.id}
                            className="text-orange-600 hover:text-orange-900 dark:text-orange-400 dark:hover:text-orange-300 disabled:opacity-50"
                            title="Désaffecter le client"
                          >
                            <Unlink className="h-4 w-4" />
                          </button>
                        ) : (
                          <select
                            onChange={(e) => {
                              const clientId = parseInt(e.target.value);
                              if (clientId) {
                                handleAffecterCompteur(compteur.id, clientId);
                              }
                            }}
                            disabled={actionLoading === compteur.id}
                            className="text-sm border border-gray-300 dark:border-gray-600 rounded px-2 py-1 bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                            defaultValue=""
                          >
                            <option value="" disabled>Affecter à...</option>
                            {clients.map((client) => (
                              <option key={client.id} value={client.id}>
                                {client.nom} {client.prenom}
                              </option>
                            ))}
                          </select>
                        )}
                      </div>
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>

      {/* Modal pour créer/éditer un compteur */}
      <CompteurModal
        isOpen={modalOpen}
        onClose={() => setModalOpen(false)}
        onSave={handleCreateCompteur}
        compteur={selectedCompteur}
        clients={clients}
        mode={modalMode}
      />
    </div>
  );
}
