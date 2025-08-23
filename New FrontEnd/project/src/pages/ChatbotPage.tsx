import React, { useState } from 'react';
import { Send, Bot, User, HelpCircle } from 'lucide-react';

interface Message {
  id: string;
  text: string;
  isBot: boolean;
  timestamp: Date;
}

export default function ChatbotPage() {
  const [messages, setMessages] = useState<Message[]>([
    {
      id: '1',
      text: 'Bonjour ! Je suis votre assistant Smart Meter. Comment puis-je vous aider aujourd\'hui ?',
      isBot: true,
      timestamp: new Date()
    }
  ]);
  const [inputText, setInputText] = useState('');

  const quickActions = [
    'Consulter ma dernière facture',
    'Signaler un problème de compteur',
    'Demander un délai de paiement',
    'Comprendre ma consommation',
    'Contacter le service client'
  ];

  const handleSendMessage = () => {
    if (!inputText.trim()) return;

    const userMessage: Message = {
      id: Date.now().toString(),
      text: inputText,
      isBot: false,
      timestamp: new Date()
    };

    setMessages(prev => [...prev, userMessage]);
    setInputText('');

    // Simulate bot response
    setTimeout(() => {
      const botResponse: Message = {
        id: (Date.now() + 1).toString(),
        text: getBotResponse(inputText),
        isBot: true,
        timestamp: new Date()
      };
      setMessages(prev => [...prev, botResponse]);
    }, 1000);
  };

  const getBotResponse = (userInput: string): string => {
    const input = userInput.toLowerCase();
    
    if (input.includes('facture')) {
      return 'Votre dernière facture de novembre 2024 est de 89,50€ pour une consommation de 245 kWh. Elle est actuellement en attente de paiement avec une échéance au 15 décembre 2024. Souhaitez-vous la télécharger ou procéder au paiement ?';
    } else if (input.includes('compteur') || input.includes('problème')) {
      return 'Je peux vous aider avec les problèmes de compteur. Votre compteur MTR001 est actuellement connecté. Quel type de problème rencontrez-vous ? (affichage, lecture, connexion, etc.)';
    } else if (input.includes('paiement') || input.includes('délai')) {
      return 'Pour demander un délai de paiement, je peux créer une réclamation pour vous. Vous pouvez généralement obtenir un délai de 30 jours. Souhaitez-vous que je lance cette demande ?';
    } else if (input.includes('consommation')) {
      return 'Votre consommation actuelle est de 245 kWh ce mois-ci, soit +12% par rapport au mois dernier. Votre moyenne annuelle est de 188 kWh/mois. Voulez-vous des conseils pour réduire votre consommation ?';
    } else {
      return 'Je comprends votre demande. Pour une assistance personnalisée, je peux vous mettre en relation avec un conseiller. En attendant, consultez nos questions fréquentes ou précisez votre demande.';
    }
  };

  const handleQuickAction = (action: string) => {
    setInputText(action);
    handleSendMessage();
  };

  return (
    <div className="h-full flex flex-col space-y-6">
      <div className="flex items-center justify-between">
        <div>
          <h1 className="text-3xl font-bold text-gray-900 dark:text-white">
            Assistant Smart Meter
          </h1>
          <p className="text-gray-600 dark:text-gray-400">
            Obtenez de l'aide instantanée pour toutes vos questions
          </p>
        </div>
        <div className="flex items-center space-x-2">
          <div className="w-3 h-3 bg-green-500 rounded-full animate-pulse"></div>
          <span className="text-sm text-gray-600 dark:text-gray-400">Assistant en ligne</span>
        </div>
      </div>

      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6 flex-1">
        <div className="lg:col-span-1 space-y-4">
          <div className="bg-white dark:bg-gray-800 p-4 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-3 flex items-center">
              <HelpCircle className="h-5 w-5 mr-2" />
              Actions Rapides
            </h3>
            <div className="space-y-2">
              {quickActions.map((action, index) => (
                <button
                  key={index}
                  onClick={() => handleQuickAction(action)}
                  className="w-full text-left p-2 text-sm bg-gray-50 dark:bg-gray-700 hover:bg-gray-100 dark:hover:bg-gray-600 rounded-lg transition-colors text-gray-700 dark:text-gray-300"
                >
                  {action}
                </button>
              ))}
            </div>
          </div>

          <div className="bg-white dark:bg-gray-800 p-4 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white mb-3">
              Informations Utiles
            </h3>
            <div className="space-y-3 text-sm">
              <div>
                <p className="text-gray-600 dark:text-gray-400">Votre compteur:</p>
                <p className="font-medium text-gray-900 dark:text-white">MTR001</p>
              </div>
              <div>
                <p className="text-gray-600 dark:text-gray-400">Statut:</p>
                <p className="font-medium text-green-600">Connecté</p>
              </div>
              <div>
                <p className="text-gray-600 dark:text-gray-400">Dernière facture:</p>
                <p className="font-medium text-gray-900 dark:text-white">€89.50</p>
              </div>
            </div>
          </div>
        </div>

        <div className="lg:col-span-3 bg-white dark:bg-gray-800 rounded-xl shadow-sm border border-gray-200 dark:border-gray-700 flex flex-col">
          <div className="p-4 border-b border-gray-200 dark:border-gray-700">
            <h3 className="text-lg font-semibold text-gray-900 dark:text-white">
              Chat avec l'Assistant
            </h3>
          </div>

          <div className="flex-1 p-4 overflow-y-auto max-h-96 space-y-4">
            {messages.map((message) => (
              <div
                key={message.id}
                className={`flex ${message.isBot ? 'justify-start' : 'justify-end'}`}
              >
                <div className={`max-w-xs lg:max-w-md ${message.isBot ? 'order-2' : 'order-1'}`}>
                  <div
                    className={`p-3 rounded-lg ${
                      message.isBot
                        ? 'bg-gray-100 dark:bg-gray-700 text-gray-900 dark:text-white'
                        : 'bg-blue-600 text-white'
                    }`}
                  >
                    <p className="text-sm">{message.text}</p>
                    <p className={`text-xs mt-1 ${
                      message.isBot ? 'text-gray-500 dark:text-gray-400' : 'text-blue-100'
                    }`}>
                      {message.timestamp.toLocaleTimeString('fr-FR', {
                        hour: '2-digit',
                        minute: '2-digit'
                      })}
                    </p>
                  </div>
                </div>
                <div className={`w-8 h-8 rounded-full flex items-center justify-center ml-2 mr-2 ${
                  message.isBot ? 'order-1 bg-blue-600' : 'order-2 bg-gray-600'
                }`}>
                  {message.isBot ? (
                    <Bot className="h-4 w-4 text-white" />
                  ) : (
                    <User className="h-4 w-4 text-white" />
                  )}
                </div>
              </div>
            ))}
          </div>

          <div className="p-4 border-t border-gray-200 dark:border-gray-700">
            <div className="flex space-x-2">
              <input
                type="text"
                value={inputText}
                onChange={(e) => setInputText(e.target.value)}
                onKeyPress={(e) => e.key === 'Enter' && handleSendMessage()}
                placeholder="Tapez votre message..."
                className="flex-1 px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white placeholder-gray-500 dark:placeholder-gray-400"
              />
              <button
                onClick={handleSendMessage}
                disabled={!inputText.trim()}
                className="bg-blue-600 hover:bg-blue-700 disabled:opacity-50 text-white p-2 rounded-lg transition-colors"
              >
                <Send className="h-4 w-4" />
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}