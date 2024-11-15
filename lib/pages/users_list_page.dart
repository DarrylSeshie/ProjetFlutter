import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final UtilisateurService utilisateurService = UtilisateurService();
  List<Utilisateur> utilisateurs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUtilisateurs();
  }

  void _fetchUtilisateurs() async {
    // Remplace par ton token réel si nécessaire
    String token = 'your_token_here';

    try {
      List<Utilisateur> fetchedUtilisateurs = await utilisateurService.fetchUtilisateurs(token);
      setState(() {
        utilisateurs = fetchedUtilisateurs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur : $e');
      // Optionnel : afficher un message d'erreur dans l'interface utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des utilisateurs')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Utilisateurs'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              // Naviguer vers une page d'ajout d'utilisateur (ajuste cette ligne selon ta navigation)
              Navigator.pushNamed(context, '/addUser');
            },
          )
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : utilisateurs.isEmpty
          ? Center(child: Text('Aucun utilisateur trouvé'))
          : ListView.builder(
        itemCount: utilisateurs.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(utilisateurs[index].nom ?? 'Sans nom'),
            subtitle: Text(utilisateurs[index].email),
            onTap: () {
              Navigator.pushNamed(
                context,
                '/userDetail',
                arguments: utilisateurs[index],
              );
            },
          );
        },
      ),
    );
  }
}
