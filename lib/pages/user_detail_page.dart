import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import pour formater la date
import '../models/user.dart';
import 'update_page.dart';
import '../services/user_service.dart';

class UserDetailPage extends StatelessWidget {
  final UtilisateurService utilisateurService = UtilisateurService();

  @override
  Widget build(BuildContext context) {
    final Utilisateur utilisateur = ModalRoute.of(context)!.settings.arguments as Utilisateur;

    Future<void> _deleteUtilisateur() async {
      try {
        await utilisateurService.deleteUtilisateur(utilisateur.id);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Utilisateur supprimé avec succès')),
        );
        Navigator.pop(context); // Retourne à la page précédente après suppression
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la suppression : $e')),
        );
      }
    }

    // Formater la date de naissance
    String? formatDate(DateTime? date) {
      if (date == null) return 'Non spécifié';
      return DateFormat('dd/MM/yyyy').format(date);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de ${utilisateur.nom ?? 'Utilisateur'}'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Section photo de profil
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: (utilisateur.photo != null && utilisateur.photo != 'no-Image')
                    ? NetworkImage(utilisateur.photo!)
                    : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                onBackgroundImageError: (exception, stackTrace) {

                },
              ),
            ),
            SizedBox(height: 20),

            // Section informations
            Expanded(
              child: ListView(
                children: [
                  _buildDetailRow('Nom', utilisateur.nom),
                  _buildDetailRow('Prénom', utilisateur.prenom),
                  _buildDetailRow('Email', utilisateur.email),
                  _buildDetailRow('Date de naissance', formatDate(utilisateur.dateDeNaissance)),
                  _buildDetailRow('Pays', utilisateur.pays),
                  _buildDetailRow('Role', utilisateur.role),
                  _buildDetailRow('Points', utilisateur.point?.toString()),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Boutons Modifier et Supprimer
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdatePage(utilisateur: utilisateur),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit),
                  label: Text('Modifier'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _deleteUtilisateur,
                  icon: Icon(Icons.delete),
                  label: Text('Supprimer'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Widget pour une ligne d'information
  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value ?? 'Non spécifié',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
