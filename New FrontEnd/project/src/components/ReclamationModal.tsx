import React, { useState, useEffect } from 'react';
import { X, Send, AlertTriangle, User, FileText } from 'lucide-react';
import { CreateReclamationRequest, Destinataire } from '../services/technicienService';

interface ReclamationModalProps {
  isOpen: boolean;
  onClose: () => void;
  onSend: (reclamationData: CreateReclamationRequest) => Promise<void>;
  destinataires: { rh: Destinataire[], admin: Destinataire[] };
}

export default function ReclamationModal({ isOpen, onClose, onSend, destinataires }: ReclamationModalProps) {
  const [formData, setFormData] = useState({
    titre: '',
    description: '',
    categorie: '',
    destinataireId: '',
    typeDestinataire: '',
    priorite: 2
  });
  const [loading, setLoading] = useState(false);
  const [errors, setErrors] = useState<Record<string, string>>({});

  useEffect(() => {
    if (isOpen) {
      setFormData({
        titre: '',
        description: '',
        categorie: '',
        destinataireId: '',
        typeDestinataire: '',
        priorite: 2
      });
      setErrors({});
    }
  }, [isOpen]);

  const validateForm = () => {
    const newErrors: Record<string, string> = {};

    if (!formData.titre.trim()) newErrors.titre = 'Le titre est requis';
    if (!formData.description.trim()) newErrors.description = 'La description est requise';
    if (!formData.categorie.trim()) newErrors.categorie = 'La catégorie est requise';
    if (!formData.destinataireId) newErrors.destinataireId = 'Le destinataire est requis';
    if (!formData.typeDestinataire) newErrors.typeDestinataire = 'Le type de destinataire est requis';

    setErrors(newErrors);
    return Object.keys(newErrors).length === 0;
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!validateForm()) return;

    setLoading(true);
    try {
      await onSend({
        titre: formData.titre,
        description: formData.description,
        categorie: formData.categorie,
        destinataireId: parseInt(formData.destinataireId),
        typeDestinataire: formData.typeDestinataire as 'RH' | 'ADMIN',
        priorite: formData.priorite
      });
      onClose();
    } catch (error) {
      console.error('Erreur lors de l\'envoi:', error);
    } finally {
      setLoading(false);
    }
  };

  const handleDestinataireChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const [type, id] = e.target.value.split('-');
    setFormData({
      ...formData,
      typeDestinataire: type,
      destinataireId: id
    });
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white dark:bg-gray-800 rounded-lg p-6 max-w-2xl w-full mx-4 max-h-[90vh] overflow-y-auto">
        <div className="flex items-center justify-between mb-6">
          <h2 className="text-xl font-semibold text-gray-900 dark:text-white">
            Envoyer une Réclamation
          </h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 dark:hover:text-gray-300"
          >
            <X className="h-6 w-6" />
          </button>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Titre *
            </label>
            <input
              type="text"
              value={formData.titre}
              onChange={(e) => setFormData({ ...formData, titre: e.target.value })}
              className={`w-full px-3 py-2 border rounded-lg ${
                errors.titre 
                  ? 'border-red-500 focus:border-red-500' 
                  : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
              } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
              placeholder="Titre de la réclamation"
            />
            {errors.titre && <p className="text-red-500 text-xs mt-1">{errors.titre}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Catégorie *
            </label>
            <select
              value={formData.categorie}
              onChange={(e) => setFormData({ ...formData, categorie: e.target.value })}
              className={`w-full px-3 py-2 border rounded-lg ${
                errors.categorie 
                  ? 'border-red-500 focus:border-red-500' 
                  : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
              } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
            >
              <option value="">Sélectionner une catégorie</option>
              <option value="TECHNIQUE">Technique</option>
              <option value="MATERIEL">Matériel</option>
              <option value="FORMATION">Formation</option>
              <option value="AUTRE">Autre</option>
            </select>
            {errors.categorie && <p className="text-red-500 text-xs mt-1">{errors.categorie}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Destinataire *
            </label>
            <select
              value={`${formData.typeDestinataire}-${formData.destinataireId}`}
              onChange={handleDestinataireChange}
              className={`w-full px-3 py-2 border rounded-lg ${
                errors.destinataireId 
                  ? 'border-red-500 focus:border-red-500' 
                  : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
              } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
            >
              <option value="">Sélectionner un destinataire</option>
              
              {destinataires.rh.length > 0 && (
                <optgroup label="Ressources Humaines">
                  {destinataires.rh.map((rh) => (
                    <option key={`RH-${rh.id}`} value={`RH-${rh.id}`}>
                      {rh.nom} {rh.prenom} - {rh.departement || 'RH'}
                    </option>
                  ))}
                </optgroup>
              )}
              
              {destinataires.admin.length > 0 && (
                <optgroup label="Administrateurs">
                  {destinataires.admin.map((admin) => (
                    <option key={`ADMIN-${admin.id}`} value={`ADMIN-${admin.id}`}>
                      {admin.nom} {admin.prenom} - Admin
                    </option>
                  ))}
                </optgroup>
              )}
            </select>
            {errors.destinataireId && <p className="text-red-500 text-xs mt-1">{errors.destinataireId}</p>}
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Priorité
            </label>
            <select
              value={formData.priorite}
              onChange={(e) => setFormData({ ...formData, priorite: parseInt(e.target.value) })}
              className="w-full px-3 py-2 border border-gray-300 dark:border-gray-600 rounded-lg bg-white dark:bg-gray-700 text-gray-900 dark:text-white focus:border-blue-500"
            >
              <option value={1}>Basse</option>
              <option value={2}>Normale</option>
              <option value={3}>Haute</option>
              <option value={4}>Urgente</option>
            </select>
          </div>

          <div>
            <label className="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">
              Description *
            </label>
            <textarea
              value={formData.description}
              onChange={(e) => setFormData({ ...formData, description: e.target.value })}
              rows={4}
              className={`w-full px-3 py-2 border rounded-lg ${
                errors.description 
                  ? 'border-red-500 focus:border-red-500' 
                  : 'border-gray-300 dark:border-gray-600 focus:border-blue-500'
              } bg-white dark:bg-gray-700 text-gray-900 dark:text-white`}
              placeholder="Décrivez votre réclamation en détail..."
            />
            {errors.description && <p className="text-red-500 text-xs mt-1">{errors.description}</p>}
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
              className="px-4 py-2 bg-orange-600 hover:bg-orange-700 disabled:bg-orange-400 text-white rounded-lg font-medium transition-colors flex items-center space-x-2"
            >
              {loading ? (
                <>
                  <div className="animate-spin rounded-full h-4 w-4 border-b-2 border-white"></div>
                  <span>Envoi...</span>
                </>
              ) : (
                <>
                  <Send className="h-4 w-4" />
                  <span>Envoyer</span>
                </>
              )}
            </button>
          </div>
        </form>
      </div>
    </div>
  );
}
