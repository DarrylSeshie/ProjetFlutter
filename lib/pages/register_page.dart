import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/user_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final UtilisateurService utilisateurService = UtilisateurService();

  // Contrôleurs pour les champs du formulaire
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _rueController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();
  final TextEditingController _communeController = TextEditingController();
  final TextEditingController _paysController = TextEditingController();
  final TextEditingController _dateNaissanceController = TextEditingController();

  DateTime? _selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateNaissanceController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      // Création d'une instance de l'utilisateur avec les valeurs par défaut pour rôle et points
      Utilisateur newUser = Utilisateur(
        id: 0, // L'ID sera généré par le serveur
        nom: _nomController.text,
        prenom: _prenomController.text,
        email: _emailController.text,
        motDePasse: _motDePasseController.text,
        rue: _rueController.text,
        codePostal: _codePostalController.text,
        commune: _communeController.text,
        pays: _paysController.text,
        dateDeNaissance: _selectedDate,
        role: 'User', // Valeur par défaut
        point: 0, // Valeur par défaut
        photo: 'no-Image'
      );

      try {
        await utilisateurService.postUtilisateur(newUser);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous êtes bien inscrit.')),
        );
        Navigator.pushReplacementNamed(context, '/login');
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de l\'inscription : $e')),
        );
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Créer un compte'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text(
                  "Inscription",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Veuillez remplir les champs ci-dessous pour créer un compte.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                SizedBox(height: 30),
                // Champs du formulaire
                _buildTextField(_nomController, "Nom", Icons.person, true),
                SizedBox(height: 15),
                _buildTextField(_prenomController, "Prénom", Icons.person_outline),
                SizedBox(height: 15),
                _buildTextField(_emailController, "Email", Icons.email, true, TextInputType.emailAddress),
                SizedBox(height: 15),
                _buildTextField(_motDePasseController, "Mot de passe", Icons.lock, true, TextInputType.text),

                SizedBox(height: 15),
                _buildTextField(_rueController, "Rue", Icons.home),
                SizedBox(height: 15),
                _buildTextField(_codePostalController, "Code Postal", Icons.pin_drop, false, TextInputType.number),
                SizedBox(height: 15),
                _buildTextField(_communeController, "Commune", Icons.location_city),
                SizedBox(height: 15),
                _buildTextField(_paysController, "Pays", Icons.flag),
                SizedBox(height: 15),
                _buildDateField(context),
                SizedBox(height: 30),
                // Bouton d'inscription
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _registerUser,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.greenAccent,
                    ),
                    child: Text(
                      "Créer un compte",
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String labelText,
      IconData icon, [
        bool isRequired = false,
        TextInputType keyboardType = TextInputType.text,
        bool obscureText = false,
      ]) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      validator: (value) {
        if (isRequired && (value == null || value.isEmpty)) {
          return '$labelText est requis';
        }
        if (labelText == "Email" && value != null && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
          return 'Veuillez entrer un email valide';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dateNaissanceController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date de naissance',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
      ),
      onTap: () => _selectDate(context),
      validator: (value) {
        if (_selectedDate == null) {
          return 'La date de naissance est requise';
        }
        return null;
      },
    );
  }
}
