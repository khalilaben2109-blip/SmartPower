import React, { useState, useEffect } from 'react';
import { Plus, Search, AlertTriangle, Clock, CheckCircle, XCircle, RefreshCw, Send } from 'lucide-react';
import { technicienService, Reclamation, Destinataire, CreateReclamationRequest } from '../services/technicienService';
import ReclamationModal from '../components/ReclamationModal';

export default function TechnicienReclamationsPage() {
  const [reclamations, setReclamations] = useState<Reclamation[]>([]);
  const [destinataires, setDestinataires] = useState<{ rh: Destinataire[], admin: Destinataire[] }>({ rh: [], admin: [] });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [modalOpen, setModalOpen] = useState(false);
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');

  useEffect(() => {
    loadData();
  }, []);

  const loadData = async () => {
    try {
      setLoading(true);
      setError(null);
      
      const [reclamationsData, destinatairesData] = await Promise.all([
        technicienService.getReclamationsEnvoyees(),
        technicienService.getDestinataires()
      ]);
      
      setReclamations(reclamationsData);
      setDestinataires(destinatairesData);
    } catch (error) {
      console.error('Erreur lors du chargement des données:', error);
      setError('Erreur lors du chargement des données');
    } finally {
      setLoading(false);
    }
  };

  const handleSendReclamation = async (reclamationData: CreateReclamationRequest) => {
    try {
      await technicienService.envoyerReclamation(reclamationData);
      await loadData(); // Recharger les données
    } catch (error) {
      console.error('Erreur lors de l\'envoi de la réclamation:', error);
      throw error;
    }
  };

  const openCreateModal = () => {
    setModalOpen(true);
  };

  const getStatusIcon = (statut: string) => {
    switch (statut) {
      case 'EN_ATTENTE':
        return <Clock className="h-4 w-4 text-yellow-500" />;
      case 'EN_COURS':
        return <AlertTriangle className="h-4 w-4 text-blue-500" />;
      case 'RESOLU':
        return <CheckCircle className="h-4 w-4 text-green-500" />;
      case 'REJETE':
        return <XCircle className="h-4 w-4 text-red-500" />;
      default:
        return <Clock className="h-4 w-4 text-gray-500" />;
    }
  };

  const getStatusColor = (statut: string) => {
    switch (statut) {
      case 'EN_ATTENTE':
        return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-200';
      case 'EN_COURS':
        return 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200';
      case 'RESOLU':
        return 'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-200';
      case 'REJETE':
        return 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200';
      default:
        return 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200';
    }
  };

  const getPriorityColor = (priorite: number) => {
    switch (priorite) {
      case 1:
        return 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200';
      case 2:
        return 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-200';
      case 3:
        return 'bg-orange-100 text-orange-800 dark:bg-orange-900 dark:text-orange-200';
      case 4:
        return 'bg-red-100 text-red-800 dark:bg-red-900 dark:text-red-200';
      default:
        return 'bg-gray-100 text-gray-800 dark:bg-gray-900 dark:text-gray-200';
    }
  };

  const filteredReclamations = reclamations.filter(reclamation => {
    const matchesSearch = reclamation.titre.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         reclamation.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         reclamation.destinataire.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesStatus = statusFilter === 'all' || reclamation.statut === statusFilter;
    return matchesSearch && matchesStatus;
  });

  const stats = {
    total: reclamations.length,
    enAttente: reclamations.filter(r => r.statut === 'EN_ATTENTE').length,
    enCours: reclamations.filter(r => r.statut === 'EN_COURS').length,
    resolues: reclamations.filter(r => r.statut === 'RESOLU').length
  };

  if (loading) {
    return (
      <div className="flex items-center justify-center h-64">
        <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-blue-600"></div>
      </div>
    );
  }

  return (
    <div className="p-6">
      <div className="mb-6">
        <h1 className="text-2xl font-bold text-gray-900 dark:text-white mb-2">
          Mes Réclamations
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Gérez vos réclamations envoyées aux RH et Administrateurs
        </p>
      </div>

      {/* Statistiques */}
      <div className="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
        <div className="bg-white dark:bg-gray-800 p-4 rounded-lg shadow">
          <div className="flex items-center">
            <AlertTriangle className="h-8 w-8 text-blue-600" />
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Total</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">{stats.total}</p>
            </div>
          </div>
        </div>
        
        <div className="bg-white dark:bg-gray-800 p-4 rounded-lg shadow">
          <div className="flex items-center">
            <Clock className="h-8 w-8 text-yellow-600" />
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-600 dark:text-gray-400">En Attente</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">{stats.enAttente}</p>
            </div>
          </div>
        </div>
        
        <div className="bg-white dark:bg-gray-800 p-4 rounded-lg shadow">
          <div className="flex items-center">
            <AlertTriangle className="h-8 w-8 text-blue-600" />
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-600 dark:text-gray-400">En Cours</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">{stats.enCours}</p>
            </div>
          </div>
        </div>
        
        <div className="bg-white dark:bg-gray-800 p-4 rounded-lg shadow">
          <div className="flex items-center">
            <CheckCircle className="h-8 w-8 text-green-600" />
            <div className="ml-3">
              <p className="text-sm font-medium text-gray-600 dark:text-gray-400">Résolues</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">{stats.resolues}</p>
            </div>
          </div>
        </div>
      </div>

      {/* Actions et filtres */}
      <div className="bg-white dark:bg-gray-800 p-4 rounded-lg shadow mb-6">
        <div className="flex flex-col sm:flex-row gap-4 items-center justify-between">
          <div className="flex flex-col sm:flex-row gap-4 flex-1">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-4 w-4" />
              <input
                type="text"
                placeholder="Rechercher une réclamation..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="w-full pl-10 pr-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:border-blue-500"
              />
            </div>
            
            <select
              value={statusFilter}
              onChange={(e) => setStatusFilter(e.target.value)}
              className="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:border-blue-500"
            >
              <option value="all">Tous les statuts</option>
              <option value="EN_ATTENTE">En attente</option>
              <option value="EN_COURS">En cours</option>
              <option value="RESOLU">Résolu</option>
              <option value="REJETE">Rejeté</option>
            </select>
          </div>
          
          <div className="flex gap-2">
            <button
              onClick={loadData}
              className="p-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors"
            >
              <RefreshCw className={`h-5 w-5 ${loading ? 'animate-spin' : ''}`} />
            </button>
            
            <button
              onClick={openCreateModal}
              className="bg-orange-600 hover:bg-orange-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center space-x-2"
            >
              <Send className="h-4 w-4" />
              <span>Nouvelle Réclamation</span>
            </button>
          </div>
        </div>
      </div>

      {/* Liste des réclamations */}
      {error && (
        <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded mb-4">
          {error}
        </div>
      )}

      <div className="bg-white dark:bg-gray-800 rounded-lg shadow overflow-hidden">
        {filteredReclamations.length === 0 ? (
          <div className="p-8 text-center">
            <AlertTriangle className="h-12 w-12 text-gray-400 mx-auto mb-4" />
            <p className="text-gray-600 dark:text-gray-400">
              {reclamations.length === 0 ? 'Aucune réclamation envoyée' : 'Aucune réclamation trouvée'}
            </p>
          </div>
        ) : (
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
              <thead className="bg-gray-50 dark:bg-gray-700">
                <tr>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                    Réclamation
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                    Destinataire
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                    Statut
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                    Priorité
                  </th>
                  <th className="px-6 py-3 text-left text-xs font-medium text-gray-500 dark:text-gray-300 uppercase tracking-wider">
                    Date
                  </th>
                </tr>
              </thead>
              <tbody className="bg-white dark:bg-gray-800 divide-y divide-gray-200 dark:divide-gray-700">
                {filteredReclamations.map((reclamation) => (
                  <tr key={reclamation.id} className="hover:bg-gray-50 dark:hover:bg-gray-700">
                    <td className="px-6 py-4">
                      <div>
                        <div className="text-sm font-medium text-gray-900 dark:text-white">
                          {reclamation.titre}
                        </div>
                        <div className="text-sm text-gray-500 dark:text-gray-400 truncate max-w-xs">
                          {reclamation.description}
                        </div>
                        <div className="text-xs text-gray-400 dark:text-gray-500 mt-1">
                          {reclamation.categorie}
                        </div>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="text-sm text-gray-900 dark:text-white">
                        {reclamation.destinataire}
                      </div>
                      <div className="text-xs text-gray-500 dark:text-gray-400">
                        {reclamation.typeDestinataire}
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <div className="flex items-center">
                        {getStatusIcon(reclamation.statut)}
                        <span className={`ml-2 px-2 py-1 text-xs font-medium rounded-full ${getStatusColor(reclamation.statut)}`}>
                          {reclamation.statut.replace('_', ' ')}
                        </span>
                      </div>
                    </td>
                    <td className="px-6 py-4">
                      <span className={`px-2 py-1 text-xs font-medium rounded-full ${getPriorityColor(reclamation.priorite)}`}>
                        {reclamation.priorite === 1 ? 'Basse' : 
                         reclamation.priorite === 2 ? 'Normale' : 
                         reclamation.priorite === 3 ? 'Haute' : 'Urgente'}
                      </span>
                    </td>
                    <td className="px-6 py-4 text-sm text-gray-500 dark:text-gray-400">
                      {new Date(reclamation.dateCreation).toLocaleDateString('fr-FR')}
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        )}
      </div>

      {/* Modal pour créer une réclamation */}
      <ReclamationModal
        isOpen={modalOpen}
        onClose={() => setModalOpen(false)}
        onSend={handleSendReclamation}
        destinataires={destinataires}
      />
    </div>
  );
}
