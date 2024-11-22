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
  List<Utilisateur> filteredUtilisateurs = [];
  bool isLoading = true;
  String? userName;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _fetchUserName();
    _fetchUtilisateurs();
  }

  Future<void> _fetchUserName() async {
    try {
      Utilisateur utilisateur = await utilisateurService.fetchCurrentUser();
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
      String? token = await _storage.read(key: 'token');
      if (token == null) throw Exception('Token non disponible, veuillez vous connecter.');

      List<Utilisateur> fetchedUtilisateurs = await utilisateurService.fetchUtilisateurs();
      setState(() {
        utilisateurs = fetchedUtilisateurs;
        filteredUtilisateurs = fetchedUtilisateurs;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des utilisateurs : $e')),
      );
    }
  }

  void _filterUsers(String query) async {
    setState(() {
      searchQuery = query;
      isLoading = true;
    });

    try {
      if (query.isEmpty) {
        // Si le champ de recherche est vide, on recharge tous les utilisateurs
        filteredUtilisateurs = utilisateurs;
      } else {
        // Recherche des utilisateurs via le backend
        filteredUtilisateurs = await utilisateurService.searchUtilisateursByName(query);
      }
    } catch (e) {
      print('Erreur lors de la recherche des utilisateurs : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la recherche : $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
 // deconnexion
  Future<void> _logout() async {
    await _storage.delete(key: 'token'); // Supprime le token stocké
    Navigator.pushReplacementNamed(context, '/login'); // Redirige vers la page de connexion
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (userName != null) Text('Bonjour, $userName', style: TextStyle(fontSize: 25)),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'Se déconnecter',
            onPressed: _logout,
          ),
        ],
        centerTitle: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Rechercher un utilisateur',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
              ),
              onChanged: _filterUsers,
            ),
          ),
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredUtilisateurs.isEmpty
                ? Center(child: Text('Aucun utilisateur trouvé'))
                : ListView.builder(
              itemCount: filteredUtilisateurs.length,
              itemBuilder: (context, index) {
                final utilisateur = filteredUtilisateurs[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: utilisateur.photo != null
                          ? NetworkImage(utilisateur.photo!)
                          : AssetImage('assets/images/default_avatar.png') as ImageProvider,
                    ),
                    title: Text(utilisateur.nom ?? 'Sans nom'),
                    subtitle: Text(utilisateur.email),
                    trailing: Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/userDetail',
                        arguments: utilisateur,
                      ).then((_) => _fetchUtilisateurs());
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addUser').then((_) => _fetchUtilisateurs());
        },
        child: Icon(Icons.add),
        tooltip: 'Ajouter un utilisateur',
        backgroundColor: Colors.greenAccent,
      ),
    );
  }
}
