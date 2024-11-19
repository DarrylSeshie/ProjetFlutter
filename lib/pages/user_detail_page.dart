import 'package:flutter/material.dart';
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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur supprimé avec succès')));
        Navigator.pop(context); // Retourne à la page précédente après suppression
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la suppression : $e')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Détails de ${utilisateur.nom ?? 'Utilisateur'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Nom : ${utilisateur.nom}'),
            Text('Email : ${utilisateur.email}'),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpdatePage(utilisateur: utilisateur),
                  ),
                );
              },
              child: Text('Modifier'),
            ),
            ElevatedButton(
              onPressed: _deleteUtilisateur,
              child: Text('Supprimer'),
            ),
          ],
        ),
      ),
    );
  }
}
