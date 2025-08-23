import React, { useState } from 'react';
import { TrendingUp, TrendingDown, Zap, Calendar } from 'lucide-react';
import ConsumptionChart from '../components/ConsumptionChart';

export default function ConsumptionPage() {
  const [selectedPeriod, setSelectedPeriod] = useState('year');
  
  const stats = [
    {
      title: 'Consommation Actuelle',
      value: '245 kWh',
      change: '+12% vs mois dernier',
      changeType: 'increase',
      icon: Zap
    },
    {
      title: 'Moyenne Mensuelle',
      value: '188 kWh',
      change: 'Sur 12 mois',
      changeType: 'neutral',
      icon: Calendar
    },
    {
      title: 'Plus Forte Consommation',
      value: '298 kWh',
      change: 'Janvier 2024',
      changeType: 'neutral',
      icon: TrendingUp
    },
    {
      title: 'Plus Basse Consommation',
      value: '110 kWh',
      change: 'Mai 2024',
      changeType: 'neutral',
      icon: TrendingDown
    }
  ];

  const dailyData = Array.from({ length: 30 }, (_, i) => ({
    day: i + 1,
    consumption: Math.floor(Math.random() * 15) + 5
  }));

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Suivi de Consommation
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Analysez votre consommation électrique en détail
          </p>
        </div>
        
        <div className="flex items-center space-x-4">
          <select
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(e.target.value)}
            className="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
          >
            <option value="week">7 derniers jours</option>
            <option value="month">30 derniers jours</option>
            <option value="year">12 derniers mois</option>
          </select>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
        {stats.map((stat, index) => (
          <div key={index} className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <div className="flex items-center justify-between">
              <div>
                <p className="text-sm font-medium text-gray-600 dark:text-gray-400">
                  {stat.title}
                </p>
                <p className="text-2xl font-bold text-gray-900 dark:text-white mt-2">
                  {stat.value}
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-400 mt-2">
                  {stat.change}
                </p>
              </div>
              <div className="p-3 rounded-full bg-blue-500">
                <stat.icon className="h-6 w-6 text-white" />
              </div>
            </div>
          </div>
        ))}
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Consommation Mensuelle 2024
          </h3>
          <ConsumptionChart />
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
            Consommation Journalière (30 jours)
          </h3>
          <div className="space-y-4">
            <div className="relative h-48">
              <div className="absolute inset-0 flex items-end justify-between space-x-1">
                {dailyData.slice(-7).map((item, index) => (
                  <div key={index} className="flex flex-col items-center flex-1">
                    <div 
                      className="w-full bg-green-600 hover:bg-green-700 transition-colors rounded-t cursor-pointer relative group"
                      style={{ 
                        height: `${(item.consumption / 20) * 100}%`,
                        minHeight: '4px'
                      }}
                    >
                      <div className="absolute -top-8 left-1/2 transform -translate-x-1/2 bg-gray-900 dark:bg-gray-700 text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity">
                        {item.consumption} kWh
                      </div>
                    </div>
                    <span className="text-xs text-gray-600 dark:text-gray-400 mt-2">
                      J-{7-index}
                    </span>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
          Conseils d'Économie d'Énergie
        </h3>
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
          <div className="p-4 bg-blue-50 dark:bg-blue-900/20 rounded-lg">
            <h4 className="font-medium text-blue-800 dark:text-blue-300 mb-2">
              🌡️ Chauffage Intelligent
            </h4>
            <p className="text-sm text-blue-700 dark:text-blue-400">
              Réduisez de 1°C votre thermostat pour économiser jusqu'à 7% sur votre facture.
            </p>
          </div>
          <div className="p-4 bg-green-50 dark:bg-green-900/20 rounded-lg">
            <h4 className="font-medium text-green-800 dark:text-green-300 mb-2">
              💡 Éclairage LED
            </h4>
            <p className="text-sm text-green-700 dark:text-green-400">
              Remplacez vos ampoules par des LED pour réduire votre consommation de 80%.
            </p>
          </div>
          <div className="p-4 bg-purple-50 dark:bg-purple-900/20 rounded-lg">
            <h4 className="font-medium text-purple-800 dark:text-purple-300 mb-2">
              🔌 Appareils en Veille
            </h4>
            <p className="text-sm text-purple-700 dark:text-purple-400">
              Débranchez vos appareils en veille pour économiser jusqu'à 10% d'électricité.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
}