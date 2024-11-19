import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class UsersListPage extends StatefulWidget {
  @override
  _UsersListPageState createState() => _UsersListPageState();
}

class _UsersListPageState extends State<UsersListPage> {
  final UtilisateurService utilisateurService = UtilisateurService();
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  List<Utilisateur> utilisateurs = [];
  bool isLoading = true;
  String? userName;

  @override
  void initState() {
    super.initState();
    _fetchUserName(); // Fetch the user name when the page initializes
    _fetchUtilisateurs();
  }

  Future<void> _fetchUserName() async {
    try {
      // Récupération du token stocké
      String? token = await _storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token non disponible, veuillez vous connecter.');
      }

      // Appelle la méthode pour récupérer l'utilisateur connecté
      Utilisateur utilisateur = await utilisateurService.fetchUtilisateurById(1); // Remplace 1 par l'ID de l'utilisateur connecté si applicable
      setState(() {
        userName = utilisateur.nom;
      });
    } catch (e) {
      print('Erreur lors de la récupération du nom de l\'utilisateur : $e');
      setState(() {
        userName = 'Utilisateur';
      });
    }
  }

  void _fetchUtilisateurs() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Récupération du token depuis le stockage sécurisé
      String? token = await _storage.read(key: 'token');
      if (token == null) {
        throw Exception('Token non disponible, veuillez vous connecter.');
      }

      // Appel du service pour récupérer les utilisateurs
      List<Utilisateur> fetchedUtilisateurs = await utilisateurService.fetchUtilisateurs();
      setState(() {
        utilisateurs = fetchedUtilisateurs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur : $e');
      // Afficher un message d'erreur dans l'interface utilisateur
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des utilisateurs : $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userName != null) Text('Bonjour, $userName', style: TextStyle(fontSize: 16)),
            Text('Liste des Utilisateurs'),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
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
                    ).then((_) {
                      _fetchUtilisateurs(); // Actualise la liste des utilisateurs
                    });
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, '/addUser').then((_) {
                  _fetchUtilisateurs(); // Actualise la liste après l'ajout
                });
              },
              icon: Icon(Icons.add),
              label: Text('Ajouter'),
            ),
          ),
        ],
      ),
    );
  }
}
