import React from 'react';
import { Users, Zap, AlertCircle, CreditCard, TrendingUp, Activity } from 'lucide-react';
import StatsCard from '../components/StatsCard';
import ApiTest from '../components/ApiTest';

export default function AdminDashboard() {
  const stats = [
    {
      title: 'Total Clients',
      value: '1,248',
      change: '+5.2%',
      changeType: 'increase' as const,
      icon: Users,
      color: 'blue'
    },
    {
      title: 'Compteurs Actifs',
      value: '1,195',
      change: '95.8%',
      changeType: 'neutral' as const,
      icon: Zap,
      color: 'green'
    },
    {
      title: 'Factures Impayées',
      value: '€25,430',
      change: '-8.3%',
      changeType: 'decrease' as const,
      icon: CreditCard,
      color: 'red'
    },
    {
      title: 'Réclamations',
      value: '23',
      change: '+12%',
      changeType: 'increase' as const,
      icon: AlertCircle,
      color: 'yellow'
    }
  ];

  const recentClaims = [
    { id: 'R001', client: 'Jean Dupont', type: 'Facture', status: 'En cours', date: '2024-11-15' },
    { id: 'R002', client: 'Marie Martin', type: 'Compteur', status: 'Résolu', date: '2024-11-14' },
    { id: 'R003', client: 'Pierre Durand', type: 'Facture', status: 'En cours', date: '2024-11-13' }
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
          Tableau de Bord Administrateur
        </h1>
        <p className="text-gray-600 dark:text-gray-400">
          Vue d'ensemble de la gestion des compteurs intelligents
        </p>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => (
          <StatsCard key={index} {...stat} />
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            État des Compteurs
          </h3>
          <div className="space-y-4">
            <div className="flex items-center justify-between p-4 bg-green-50 dark:bg-green-900/20 rounded-lg">
              <div className="flex items-center space-x-3">
                <div className="w-3 h-3 bg-green-500 rounded-full"></div>
                <span className="font-medium text-gray-900 dark:text-white">Connectés</span>
              </div>
              <span className="text-2xl font-bold text-green-600">1,195</span>
            </div>
            <div className="flex items-center justify-between p-4 bg-red-50 dark:bg-red-900/20 rounded-lg">
              <div className="flex items-center space-x-3">
                <div className="w-3 h-3 bg-red-500 rounded-full"></div>
                <span className="font-medium text-gray-900 dark:text-white">Déconnectés</span>
              </div>
              <span className="text-2xl font-bold text-red-600">53</span>
            </div>
            <div className="flex items-center justify-between p-4 bg-yellow-50 dark:bg-yellow-900/20 rounded-lg">
              <div className="flex items-center space-x-3">
                <div className="w-3 h-3 bg-yellow-500 rounded-full"></div>
                <span className="font-medium text-gray-900 dark:text-white">Maintenance</span>
              </div>
              <span className="text-2xl font-bold text-yellow-600">12</span>
            </div>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Réclamations Récentes
          </h3>
          <div className="space-y-3">
            {recentClaims.map((claim) => (
              <div key={claim.id} className="flex items-center justify-between p-3 bg-gray-50 dark:bg-gray-700 rounded-lg">
                <div>
                  <p className="font-medium text-gray-900 dark:text-white">{claim.client}</p>
                  <p className="text-sm text-gray-600 dark:text-gray-400">{claim.type} - {claim.date}</p>
                </div>
                <span className={`px-2 py-1 text-xs rounded-full ${
                  claim.status === 'Résolu' 
                    ? 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300'
                    : 'bg-orange-100 dark:bg-orange-900/20 text-orange-800 dark:text-orange-300'
                }`}>
                  {claim.status}
                </span>
              </div>
            ))}
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Actions Administratives
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
          <button className="p-4 bg-blue-600 hover:bg-blue-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <Users className="h-5 w-5" />
            <span>Gérer Utilisateurs</span>
          </button>
          <button className="p-4 bg-green-600 hover:bg-green-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <Zap className="h-5 w-5" />
            <span>Affecter Compteurs</span>
          </button>
          <button className="p-4 bg-orange-600 hover:bg-orange-700 text-white rounded-lg transition-colors flex items-center space-x-2">
            <AlertCircle className="h-5 w-5" />
            <span>Traiter Réclamations</span>
          </button>
        </div>
      </div>

      <ApiTest />
    </div>
  );
}