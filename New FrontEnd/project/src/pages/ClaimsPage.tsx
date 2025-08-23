import React, { useState } from 'react';
import { Plus, Clock, CheckCircle, AlertCircle } from 'lucide-react';

export default function ClaimsPage() {
  const [showNewClaimForm, setShowNewClaimForm] = useState(false);
  
  const claims = [
    {
      id: 'R001',
      type: 'Facture',
      subject: 'Montant facture incorrect',
      description: 'La facture de novembre semble trop élevée par rapport à ma consommation habituelle.',
      status: 'in_progress',
      date: '2024-11-15',
      response: 'Votre réclamation est en cours d\'analyse par notre équipe.'
    },
    {
      id: 'R002',
      type: 'Compteur',
      subject: 'Compteur ne fonctionne plus',
      description: 'Mon compteur électrique ne s\'allume plus depuis hier soir.',
      status: 'resolved',
      date: '2024-11-10',
      response: 'Intervention réalisée le 12/11/2024. Problème résolu.'
    },
    {
      id: 'R003',
      type: 'Facture',
      subject: 'Demande de délai de paiement',
      description: 'Je souhaiterais obtenir un délai supplémentaire pour le paiement de ma facture.',
      status: 'pending',
      date: '2024-11-08',
      response: null
    }
  ];

  const getStatusInfo = (status: string) => {
    const statusMap = {
      pending: { 
        label: 'En attente', 
        color: 'bg-yellow-100 dark:bg-yellow-900/20 text-yellow-800 dark:text-yellow-300',
        icon: Clock
      },
      in_progress: { 
        label: 'En cours', 
        color: 'bg-blue-100 dark:bg-blue-900/20 text-blue-800 dark:text-blue-300',
        icon: AlertCircle
      },
      resolved: { 
        label: 'Résolu', 
        color: 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300',
        icon: CheckCircle
      }
    };
    return statusMap[status as keyof typeof statusMap] || statusMap.pending;
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Mes Réclamations
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Gérez vos réclamations et suivez leur traitement
          </p>
        </div>
        
        <button
          onClick={() => setShowNewClaimForm(true)}
          className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors flex items-center space-x-2"
        >
          <Plus className="h-4 w-4" />
          <span>Nouvelle Réclamation</span>
        </button>
      </div>

      {showNewClaimForm && (
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Nouvelle Réclamation
          </h3>
          <form className="space-y-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Type de réclamation
              </label>
              <select className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white">
                <option>Facture</option>
                <option>Compteur</option>
                <option>Service client</option>
                <option>Autre</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Sujet
              </label>
              <input
                type="text"
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                placeholder="Résumé de votre réclamation"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                Description
              </label>
              <textarea
                rows={4}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
                placeholder="Décrivez votre problème en détail..."
              ></textarea>
            </div>
            <div className="flex space-x-4">
              <button
                type="submit"
                className="bg-blue-600 hover:bg-blue-700 text-white px-4 py-2 rounded-lg font-medium transition-colors"
              >
                Soumettre
              </button>
              <button
                type="button"
                onClick={() => setShowNewClaimForm(false)}
                className="bg-gray-300 hover:bg-gray-400 dark:bg-gray-600 dark:hover:bg-gray-500 text-gray-700 dark:text-gray-300 px-4 py-2 rounded-lg font-medium transition-colors"
              >
                Annuler
              </button>
            </div>
          </form>
        </div>
      )}

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-yellow-100 dark:bg-yellow-900/20 rounded-lg">
              <Clock className="h-6 w-6 text-yellow-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">En attente</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {claims.filter(c => c.status === 'pending').length}
              </p>
            </div>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-blue-100 dark:bg-blue-900/20 rounded-lg">
              <AlertCircle className="h-6 w-6 text-blue-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">En cours</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {claims.filter(c => c.status === 'in_progress').length}
              </p>
            </div>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-green-100 dark:bg-green-900/20 rounded-lg">
              <CheckCircle className="h-6 w-6 text-green-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Résolues</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">
                {claims.filter(c => c.status === 'resolved').length}
              </p>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <div className="p-6 border-b border-gray-200 dark:border-gray-700">
          <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
            Mes Réclamations
          </h2>
        </div>
        
        <div className="divide-y divide-gray-200 dark:divide-gray-700">
          {claims.map((claim) => {
            const statusInfo = getStatusInfo(claim.status);
            const StatusIcon = statusInfo.icon;
            
            return (
              <div key={claim.id} className="p-6">
                <div className="flex items-start justify-between">
                  <div className="flex-1">
                    <div className="flex items-center space-x-3 mb-2">
                      <h3 className="text-lg font-medium text-gray-900 dark:text-white">
                        {claim.subject}
                      </h3>
                      <span className={`px-2 py-1 text-xs font-medium rounded-full ${statusInfo.color}`}>
                        {statusInfo.label}
                      </span>
                    </div>
                    <div className="flex items-center space-x-4 text-sm text-gray-600 dark:text-gray-400 mb-3">
                      <span>Réclamation #{claim.id}</span>
                      <span>Type: {claim.type}</span>
                      <span>{new Date(claim.date).toLocaleDateString('fr-FR')}</span>
                    </div>
                    <p className="text-gray-700 dark:text-gray-300 mb-4">
                      {claim.description}
                    </p>
                    {claim.response && (
                      <div className="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg">
                        <h4 className="font-medium text-gray-900 dark:text-white mb-2">Réponse:</h4>
                        <p className="text-gray-700 dark:text-gray-300">{claim.response}</p>
                      </div>
                    )}
                  </div>
                  <StatusIcon className="h-5 w-5 text-gray-400 ml-4" />
                </div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}