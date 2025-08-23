import React, { useState } from 'react';
import { Download, CreditCard, Calendar, Filter } from 'lucide-react';

export default function BillsPage() {
  const [selectedPeriod, setSelectedPeriod] = useState('all');
  
  const bills = [
    {
      id: 'F001',
      period: 'Novembre 2024',
      consumption: 245,
      amount: 89.50,
      status: 'unpaid',
      dueDate: '2024-12-15',
      issueDate: '2024-11-30'
    },
    {
      id: 'F002',
      period: 'Octobre 2024',
      consumption: 198,
      amount: 72.30,
      status: 'paid',
      dueDate: '2024-11-15',
      issueDate: '2024-10-31'
    },
    {
      id: 'F003',
      period: 'Septembre 2024',
      consumption: 167,
      amount: 61.20,
      status: 'paid',
      dueDate: '2024-10-15',
      issueDate: '2024-09-30'
    },
    {
      id: 'F004',
      period: 'Août 2024',
      consumption: 189,
      amount: 69.85,
      status: 'paid',
      dueDate: '2024-09-15',
      issueDate: '2024-08-31'
    }
  ];

  const getStatusBadge = (status: string) => {
    const classes = {
      paid: 'bg-green-100 dark:bg-green-900/20 text-green-800 dark:text-green-300',
      unpaid: 'bg-orange-100 dark:bg-orange-900/20 text-orange-800 dark:text-orange-300',
      overdue: 'bg-red-100 dark:bg-red-900/20 text-red-800 dark:text-red-300'
    };
    
    const labels = {
      paid: 'Payée',
      unpaid: 'À payer',
      overdue: 'En retard'
    };

    return (
      <span className={`px-2 py-1 text-xs font-medium rounded-full ${classes[status as keyof typeof classes]}`}>
        {labels[status as keyof typeof labels]}
      </span>
    );
  };

  return (
    <div className="space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Mes Factures
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Consultez et gérez vos factures d'électricité
          </p>
        </div>
        
        <div className="flex items-center space-x-4">
          <select
            value={selectedPeriod}
            onChange={(e) => setSelectedPeriod(e.target.value)}
            className="px-4 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-800 text-gray-900 dark:text-white"
          >
            <option value="all">Toutes les périodes</option>
            <option value="2024">2024</option>
            <option value="2023">2023</option>
          </select>
        </div>
      </div>

      <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-orange-100 dark:bg-orange-900/20 rounded-lg">
              <CreditCard className="h-6 w-6 text-orange-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Factures en attente</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">€89.50</p>
            </div>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-green-100 dark:bg-green-900/20 rounded-lg">
              <Calendar className="h-6 w-6 text-green-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Payé cette année</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">€203.35</p>
            </div>
          </div>
        </div>

        <div className="bg-white dark:bg-gray-800 p-6 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
          <div className="flex items-center space-x-3">
            <div className="p-2 bg-blue-100 dark:bg-blue-900/20 rounded-lg">
              <Filter className="h-6 w-6 text-blue-600" />
            </div>
            <div>
              <p className="text-sm text-gray-600 dark:text-gray-400">Consommation moyenne</p>
              <p className="text-2xl font-bold text-gray-900 dark:text-white">199 kWh</p>
            </div>
          </div>
        </div>
      </div>

      <div className="bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
        <div className="p-6 border-b border-gray-200 dark:border-gray-700">
          <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
            Historique des Factures
          </h2>
        </div>
        
        <div className="overflow-x-auto">
          <table className="w-full">
            <thead className="bg-gray-50 dark:bg-gray-700">
              <tr>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Période
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Consommation
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Montant
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Échéance
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Statut
                </th>
                <th className="text-left px-6 py-4 text-sm font-medium text-gray-600 dark:text-gray-300">
                  Actions
                </th>
              </tr>
            </thead>
            <tbody className="divide-y divide-gray-200 dark:divide-gray-700">
              {bills.map((bill) => (
                <tr key={bill.id} className="hover:bg-gray-50 dark:hover:bg-gray-700">
                  <td className="px-6 py-4">
                    <div>
                      <p className="font-medium text-gray-900 dark:text-white">{bill.period}</p>
                      <p className="text-sm text-gray-600 dark:text-gray-400">
                        Facture {bill.id}
                      </p>
                    </div>
                  </td>
                  <td className="px-6 py-4 text-gray-900 dark:text-white">
                    {bill.consumption} kWh
                  </td>
                  <td className="px-6 py-4">
                    <span className="font-medium text-gray-900 dark:text-white">
                      €{bill.amount.toFixed(2)}
                    </span>
                  </td>
                  <td className="px-6 py-4 text-gray-900 dark:text-white">
                    {new Date(bill.dueDate).toLocaleDateString('fr-FR')}
                  </td>
                  <td className="px-6 py-4">
                    {getStatusBadge(bill.status)}
                  </td>
                  <td className="px-6 py-4">
                    <div className="flex items-center space-x-2">
                      <button className="p-2 text-blue-600 hover:bg-blue-50 dark:hover:bg-blue-900/20 rounded-lg transition-colors">
                        <Download className="h-4 w-4" />
                      </button>
                      {bill.status === 'unpaid' && (
                        <button className="px-3 py-1 bg-green-600 hover:bg-green-700 text-white text-sm rounded-lg transition-colors">
                          Payer
                        </button>
                      )}
                    </div>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </div>
    </div>
  );
}