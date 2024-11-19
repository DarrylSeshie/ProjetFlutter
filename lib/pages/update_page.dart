import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class UpdatePage extends StatefulWidget {
  final Utilisateur utilisateur;

  UpdatePage({required this.utilisateur});

  @override
  _UpdatePageState createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _emailController;
  late TextEditingController _rueController;
  late TextEditingController _codePostalController;
  late TextEditingController _communeController;
  late TextEditingController _paysController;
  UtilisateurService utilisateurService = UtilisateurService();

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.utilisateur.nom ?? '');
    _emailController = TextEditingController(text: widget.utilisateur.email);
    _rueController = TextEditingController(text: widget.utilisateur.rue ?? '');
    _codePostalController = TextEditingController(text: widget.utilisateur.codePostal ?? '');
    _communeController = TextEditingController(text: widget.utilisateur.commune ?? '');
    _paysController = TextEditingController(text: widget.utilisateur.pays ?? '');
  }

  @override
  void dispose() {
    _nomController.dispose();
    _emailController.dispose();
    _rueController.dispose();
    _codePostalController.dispose();
    _communeController.dispose();
    _paysController.dispose();
    super.dispose();
  }

  Future<void> _updateUtilisateur() async {
    if (_formKey.currentState!.validate()) {
      widget.utilisateur.nom = _nomController.text;
      widget.utilisateur.email = _emailController.text;
      widget.utilisateur.rue = _rueController.text;
      widget.utilisateur.codePostal = _codePostalController.text;
      widget.utilisateur.commune = _communeController.text;
      widget.utilisateur.pays = _paysController.text;

      try {
        await utilisateurService.updateUtilisateur(widget.utilisateur.id, widget.utilisateur);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur mis à jour avec succès')));
        Navigator.pop(context); // Retourne à la page précédente après mise à jour
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour : $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Modifier Utilisateur')),
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
                onPressed: _updateUtilisateur,
                child: Text('Mettre à jour'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
