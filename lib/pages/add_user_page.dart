import 'package:flutter/material.dart';
import '../services/user_service.dart';
import '../models/user.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();
  final UtilisateurService utilisateurService = UtilisateurService();

  // Contrôleurs pour les champs du formulaire
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _rueController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();
  final TextEditingController _communeController = TextEditingController();
  final TextEditingController _paysController = TextEditingController();

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      // Création d'une instance de l'utilisateur à partir des données du formulaire
      Utilisateur newUser = Utilisateur(
        id: 0, // Rempli par le serveur lors de la création
        email: _emailController.text,
        motDePasse: _motDePasseController.text,
        nom: _nomController.text,
        rue: _rueController.text,
        codePostal: _codePostalController.text,
        commune: _communeController.text,
        pays: _paysController.text,
      );

      try {
        await utilisateurService.createUtilisateur(newUser);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur ajouté avec succès')));
        Navigator.pop(context, true); // Retourne avec un résultat pour actualiser la liste des utilisateurs
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout de l\'utilisateur : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ajouter un utilisateur')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le nom est requis';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'L\'email est requis';
                  }
                  if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Veuillez entrer un email valide';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _motDePasseController,
                decoration: InputDecoration(labelText: 'Mot de passe'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Le mot de passe est requis';
                  }
                  if (value.length < 6) {
                    return 'Le mot de passe doit contenir au moins 6 caractères';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rueController,
                decoration: InputDecoration(labelText: 'Rue'),
              ),
              TextFormField(
                controller: _codePostalController,
                decoration: InputDecoration(labelText: 'Code Postal'),
              ),
              TextFormField(
                controller: _communeController,
                decoration: InputDecoration(labelText: 'Commune'),
              ),
              TextFormField(
                controller: _paysController,
                decoration: InputDecoration(labelText: 'Pays'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addUser,
                child: Text('Ajouter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
