import React from 'react';
import { CreditCard, Zap, AlertCircle, TrendingUp, FileText } from 'lucide-react';
import { useAuth } from '../contexts/AuthContext';
import StatsCard from '../components/StatsCard';
import ConsumptionChart from '../components/ConsumptionChart';

export default function ClientDashboard() {
  const { user } = useAuth();

  const stats = [
    {
      title: 'Consommation Actuelle',
      value: '245 kWh',
      change: '+12%',
      changeType: 'increase' as const,
      icon: Zap,
      color: 'blue'
    },
    {
      title: 'Facture en Cours',
      value: '€89.50',
      change: 'À payer',
      changeType: 'neutral' as const,
      icon: CreditCard,
      color: 'green'
    },
    {
      title: 'Réclamations',
      value: '1',
      change: 'En cours',
      changeType: 'neutral' as const,
      icon: AlertCircle,
      color: 'yellow'
    },
    {
      title: 'Économies ce Mois',
      value: '€12.30',
      change: '+8%',
      changeType: 'decrease' as const,
      icon: TrendingUp,
      color: 'purple'
    }
  ];

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Bonjour, {user?.name}
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Voici un aperçu de votre consommation électrique
          </p>
        </div>
        <div className="bg-white dark:bg-gray-800 p-4 rounded-lg shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-2">
            <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
            <span className="text-sm font-medium text-gray-700 dark:text-gray-300">
              Compteur: {user?.meterId}
            </span>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => (
          <StatsCard key={index} {...stat} />
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Consommation Mensuelle
          </h3>
          <ConsumptionChart />
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Actions Rapides
          </h3>
          <div className="space-y-3">
            <button className="w-full bg-blue-600 hover:bg-blue-700 text-white p-3 rounded-lg transition-colors flex items-center justify-center space-x-2">
              <CreditCard className="h-4 w-4" />
              <span>Payer ma facture</span>
            </button>
            <button className="w-full bg-green-600 hover:bg-green-700 text-white p-3 rounded-lg transition-colors flex items-center justify-center space-x-2">
              <FileText className="h-4 w-4" />
              <span>Télécharger facture PDF</span>
            </button>
            <button className="w-full bg-orange-600 hover:bg-orange-700 text-white p-3 rounded-lg transition-colors flex items-center justify-center space-x-2">
              <AlertCircle className="h-4 w-4" />
              <span>Faire une réclamation</span>
            </button>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Dernières Factures
        </h3>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-gray-200 dark:border-gray-700">
                <th className="text-left py-3 text-gray-600 dark:text-gray-400">Période</th>
                <th className="text-left py-3 text-gray-600 dark:text-gray-400">Consommation</th>
                <th className="text-left py-3 text-gray-600 dark:text-gray-400">Montant</th>
                <th className="text-left py-3 text-gray-600 dark:text-gray-400">Statut</th>
              </tr>
            </thead>
            <tbody>
              <tr className="border-b border-gray-100 dark:border-gray-700">
                <td className="py-3 text-gray-900 dark:text-white">Novembre 2024</td>
                <td className="py-3 text-gray-900 dark:text-white">245 kWh</td>
                <td className="py-3 text-gray-900 dark:text-white">€89.50</td>
                <td className="py-3">
                  <span className="px-2 py-1 bg-orange-100 dark:bg-orange-900/20 text-orange-800 dark:text-orange-300 text-xs rounded-full">
                    À payer
                  </span>
                </td>
              </tr>
              <tr className="border-b border-gray-100 dark:border-gray-700">
                <td className="py-3 text-gray-900 dark:text-white">Octobre 2024</td>
                <td className="py-3 text-gray-900 dark:text-white">198 kWh</td>
                <td className="py-3 text-gray-900 dark:text-white">€72.30</td>
                <td className="py-3">
                  <span className="px-2 py-1 bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300 text-xs rounded-full">
                    Payée
                  </span>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}