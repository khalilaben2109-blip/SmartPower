import React, { useState, useEffect } from 'react';
import { X, Save, Zap, User } from 'lucide-react';
import { Compteur, Client, CreateCompteurRequest } from '../services/technicienService';

interface CompteurModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSave: (compteurData: CreateCompteurRequest) => Promise<void>;
  compteur?: Compteur | null;
  clients: Client[];
  mode: 'create' | 'edit';
}

export default function CompteurModal({ isOpen, onClose, onSave, compteur, clients, mode }: CompteurModalProps) {
  const [formData, setFormData] = useState({
    numeroSerie: '',
    typeCompteur: 'MONOPHASE',
    typeAbonnement: 'RESIDENTIEL',
    puissanceSouscrite: 6,
    tension: 230,
    phase: 1,
    typeCompteurIntelligent: false,
    clientId: undefined as number | undefined
  });
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (compteur && mode === 'edit') {
      setFormData({
        numeroSerie: compteur.numeroSerie || '',
        typeCompteur: compteur.typeCompteur || 'MONOPHASE',
        typeAbonnement: compteur.typeAbonnement || 'RESIDENTIEL',
        puissanceSouscrite: compteur.puissanceSouscrite || 6,
        tension: compteur.tension || 230,
        phase: compteur.phase || 1,
        typeCompteurIntelligent: compteur.typeCompteurIntelligent || false,
        clientId: compteur.client?.id
      });
    } else {
      setFormData({
        numeroSerie: '',
        typeCompteur: 'MONOPHASE',
        typeAbonnement: 'RESIDENTIEL',
        puissanceSouscrite: 6,
        tension: 230,
        phase: 1,
        typeCompteurIntelligent: false,
        clientId: undefined
      });
    }
    setErrors({});
  }, [compteur, mode, isOpen]);

  const validateForm = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.numeroSerie.trim()) newErrors.numeroSerie = 'Le numéro de série est requis';
    if (!formData.typeCompteur.trim()) newErrors.typeCompteur = 'Le type de compteur est requis';
    if (!formData.typeAbonnement.trim()) newErrors.typeAbonnement = 'Le type d\'abonnement est requis';
    if (formData.puissanceSouscrite <= 0) newErrors.puissanceSouscrite = 'La puissance doit être positive';
    if (formData.tension <= 0) newErrors.tension = 'La tension doit être positive';
    if (formData.phase <= 0) newErrors.phase = 'Le nombre de phases doit être positif';
    if (!formData.clientId) newErrors.clientId = 'Un client doit être sélectionné';

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) return;

    setLoading(true);
    try {
      await onSave(formData);
      onClose();
    } catch (error) {
      console.error('Erreur lors de la sauvegarde:', error);
    } finally {
      setLoading(false);
    }
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white dark:bg-gray-800 rounded-lg p-6 max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
            {mode === 'create' ? 'Nouveau Compteur' : 'Modifier Compteur'}
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
          >
            <X className="h-6 w-6" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Numéro de série *
              </label>
              <input
                type="text"
                value={formData.numeroSerie}
                onChange={(e) => setFormData({ ...formData, numeroSerie: e.target.value })}
                className={`w-full px-3 py-2 border rounded-lg ${
                  errors.numeroSerie 
                    ? 'border-red-500 focus:border-red-500' 
                    : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
                } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
                placeholder="Ex: COMP001"
              />
              {errors.numeroSerie && <p className="text-red-500 text-xs mt-1">{errors.numeroSerie}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Type de compteur *
              </label>
              <select
                value={formData.typeCompteur}
                onChange={(e) => setFormData({ ...formData, typeCompteur: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
              >
                <option value="MONOPHASE">Monophasé</option>
                <option value="TRIPHASE">Triphasé</option>
                <option value="INTELLIGENT">Intelligent</option>
              </select>
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Type d'abonnement *
              </label>
              <select
                value={formData.typeAbonnement}
                onChange={(e) => setFormData({ ...formData, typeAbonnement: e.target.value })}
                className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white"
              >
                <option value="RESIDENTIEL">Résidentiel</option>
                <option value="COMMERCIAL">Commercial</option>
                <option value="INDUSTRIEL">Industriel</option>
              </select>
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Puissance souscrite (kVA) *
              </label>
              <input
                type="number"
                step="0.1"
                value={formData.puissanceSouscrite}
                onChange={(e) => setFormData({ ...formData, puissanceSouscrite: parseFloat(e.target.value) || 0 })}
                className={`w-full px-3 py-2 border rounded-lg ${
                  errors.puissanceSouscrite 
                    ? 'border-red-500 focus:border-red-500' 
                    : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
                } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
                placeholder="6"
              />
              {errors.puissanceSouscrite && <p className="text-red-500 text-xs mt-1">{errors.puissanceSouscrite}</p>}
            </div>
          </div>

          <div className="grid grid-cols-2 gap-4">
            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Tension (V) *
              </label>
              <input
                type="number"
                value={formData.tension}
                onChange={(e) => setFormData({ ...formData, tension: parseInt(e.target.value) || 0 })}
                className={`w-full px-3 py-2 border rounded-lg ${
                  errors.tension 
                    ? 'border-red-500 focus:border-red-500' 
                    : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
                } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
                placeholder="230"
              />
              {errors.tension && <p className="text-red-500 text-xs mt-1">{errors.tension}</p>}
            </div>

            <div>
              <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
                Nombre de phases *
              </label>
              <input
                type="number"
                min="1"
                max="3"
                value={formData.phase}
                onChange={(e) => setFormData({ ...formData, phase: parseInt(e.target.value) || 1 })}
                className={`w-full px-3 py-2 border rounded-lg ${
                  errors.phase 
                    ? 'border-red-500 focus:border-red-500' 
                    : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
                } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
                placeholder="1"
              />
              {errors.phase && <p className="text-red-500 text-xs mt-1">{errors.phase}</p>}
            </div>
          </div>

          <div className="flex items-center space-x-2">
            <input
              type="checkbox"
              id="typeCompteurIntelligent"
              checked={formData.typeCompteurIntelligent}
              onChange={(e) => setFormData({ ...formData, typeCompteurIntelligent: e.target.checked })}
              className="rounded border-gray-300 dark:border-gray-600"
            />
            <label htmlFor="typeCompteurIntelligent" className="text-sm font-medium text-gray-700 dark:text-gray-300">
              Compteur intelligent
            </label>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Affecter à un client *
            </label>
            <select
              value={formData.clientId || ''}
              onChange={(e) => setFormData({ ...formData, clientId: e.target.value ? parseInt(e.target.value) : undefined })}
              className={`w-full px-3 py-2 border rounded-lg ${
                errors.clientId 
                  ? 'border-red-500 focus:border-red-500' 
                  : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
              } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
            >
              <option value="">Sélectionner un client</option>
              {clients.map((client) => (
                <option key={client.id} value={client.id}>
                  {client.nom} {client.prenom} - {client.email}
                </option>
              ))}
            </select>
            {errors.clientId && <p className="text-red-500 text-xs mt-1">{errors.clientId}</p>}
          </div>

          <div className="flex justify-end space-x-3 pt-4">
            <button
              type="button"
              onClick={onClose}
              className="px-4 py-2 text-gray-600 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200 transition-colors"
            >
              Annuler
            </button>
            <button
              type="submit"
              disabled={loading}
              className="px-4 py-2 bg-blue-600 hover:bg-blue-700 disabled:bg-blue-400 text-white rounded-lg font-medium transition-colors flex items-center space-x-2"
            >
              {loading ? (
                <>
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                  <span>Sauvegarde...</span>
                </>
              ) : (
                <>
                  {mode === 'create' ? <Zap className="h-4 w-4" /> : <Save className="h-4 w-4" />}
                  <span>{mode === 'create' ? 'Créer' : 'Sauvegarder'}</span>
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
