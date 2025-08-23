import React from 'react';

export default function ConsumptionChart() {
  const data = [
    { month: 'Jan', consumption: 180 },
    { month: 'Fév', consumption: 165 },
    { month: 'Mar', consumption: 145 },
    { month: 'Avr', consumption: 120 },
    { month: 'Mai', consumption: 110 },
    { month: 'Jun', consumption: 125 },
    { month: 'Jul', consumption: 140 },
    { month: 'Aoû', consumption: 155 },
    { month: 'Sep', consumption: 135 },
    { month: 'Oct', consumption: 198 },
    { month: 'Nov', consumption: 245 },
    { month: 'Déc', consumption: 220 }
  ];

  const maxConsumption = Math.max(...data.map(d => d.consumption));

  return (
    <div className="space-y-4">
      <div className="flex items-center justify-between text-sm text-gray-600 dark:text-gray-400">
        <span>kWh</span>
        <span>{maxConsumption}</span>
      </div>
      
      <div className="relative h-48">
        <div className="absolute inset-0 flex items-end justify-between space-x-1">
          {data.map((item, index) => (
            <div key={item.month} className="flex flex-col items-center flex-1">
              <div 
                className="w-full bg-blue-600 hover:bg-blue-700 transition-colors rounded-t cursor-pointer relative group"
                style={{ 
                  height: `${(item.consumption / maxConsumption) * 100}%`,
                  minHeight: '4px'
                }}
              >
                <div className="absolute -top-8 left-1/2 transform -translate-x-1/2 bg-gray-900 dark:bg-gray-700 text-white text-xs px-2 py-1 rounded opacity-0 group-hover:opacity-100 transition-opacity">
                  {item.consumption} kWh
                </div>
              </div>
              <span className="text-xs text-gray-600 dark:text-gray-400 mt-2">
                {item.month}
              </span>
            </div>
          ))}
        </div>
      </div>
      
      <div className="text-center">
        <p className="text-sm text-gray-600 dark:text-gray-400">
          Consommation mensuelle 2024
        </p>
      </div>
    </div>
  );
}