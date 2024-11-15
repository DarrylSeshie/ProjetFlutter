import 'package:flutter/material.dart';
import '../models/user.dart';

class UserDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Utilisateur utilisateur = ModalRoute.of(context)!.settings.arguments as Utilisateur;

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
                // Logique de modification
              },
              child: Text('Modifier'),
            ),
            ElevatedButton(
              onPressed: () {
                // Logique de suppression
              },
              child: Text('Supprimer'),
            ),
          ],
        ),
      ),
    );
  }
}
