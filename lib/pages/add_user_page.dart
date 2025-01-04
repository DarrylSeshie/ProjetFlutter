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
  final TextEditingController _prenomController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _motDePasseController = TextEditingController();
  final TextEditingController _rueController = TextEditingController();
  final TextEditingController _codePostalController = TextEditingController();
  final TextEditingController _communeController = TextEditingController();
  final TextEditingController _paysController = TextEditingController();
  final TextEditingController _pointController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  // Pour le champ "Rôle"
  final List<String> _roles = ['Admin', 'User'];
  String? _selectedRole;

  // Pour le champ "Date de naissance"
  DateTime? _selectedDate;

  bool isLoading = false;

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
        _dateController.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _addUser() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      // Création d'une instance de l'utilisateur à partir des données du formulaire
      Utilisateur newUser = Utilisateur(
        id: 0,
        email: _emailController.text,
        motDePasse: _motDePasseController.text,
        nom: _nomController.text,
        prenom: _prenomController.text,
        rue: _rueController.text,
        codePostal: _codePostalController.text,
        commune: _communeController.text,
        pays: _paysController.text,
        role: _selectedRole,
        point: int.tryParse(_pointController.text) ?? 0, // Conversion sécurisée en entier
        dateDeNaissance: _selectedDate,
          photo: 'no-Image',
      );

      try {
        await utilisateurService.createUtilisateur(newUser);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur ajouté avec succès')));

        // Redirection vers la liste des utilisateurs après succès
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de l\'ajout de l\'utilisateur : $e')));
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un utilisateur'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 20),
                _buildFormField(_nomController, 'Nom', 'Le nom est requis', Icons.person),
                SizedBox(height: 10),
                _buildFormField(_prenomController, 'Prénom', null, Icons.person_outline),
                SizedBox(height: 10),
                _buildFormField(_emailController, 'Email', 'L\'email est requis', Icons.email,
                    keyboardType: TextInputType.emailAddress),
                SizedBox(height: 10),
                _buildFormField(_motDePasseController, 'Mot de passe', 'Le mot de passe est requis', Icons.lock,
                    isPassword: true),
                SizedBox(height: 10),
                _buildFormField(_rueController, 'Rue', null, Icons.home),
                SizedBox(height: 10),
                _buildFormField(_codePostalController, 'Code Postal', null, Icons.pin_drop),
                SizedBox(height: 10),
                _buildFormField(_communeController, 'Commune', null, Icons.location_city),
                SizedBox(height: 10),
                _buildFormField(_paysController, 'Pays', null, Icons.flag),
                SizedBox(height: 10),
                _buildFormField(
                  _pointController,
                  'Points',
                  'Les points doivent être un nombre entier',
                  Icons.score,
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 10),
                _buildRoleDropdown(),
                SizedBox(height: 10),
                _buildDateField(context),
                SizedBox(height: 30),
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : _buildAddButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Créer un nouvel utilisateur",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.greenAccent,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Renseignez les informations nécessaires pour ajouter un utilisateur.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFormField(
      TextEditingController controller, String label, String? errorText, IconData icon,
      {TextInputType keyboardType = TextInputType.text, bool isPassword = false}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: isPassword,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      validator: errorText != null
          ? (value) {
        if (value == null || value.isEmpty) {
          return errorText;
        }
        return null;
      }
          : null,
    );
  }

  Widget _buildRoleDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedRole,
      decoration: InputDecoration(
        labelText: 'Rôle',
        prefixIcon: Icon(Icons.account_circle),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
      ),
      items: _roles
          .map((role) => DropdownMenuItem(
        value: role,
        child: Text(role),
      ))
          .toList(),
      onChanged: (value) {
        setState(() {
          _selectedRole = value;
        });
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Le rôle est requis';
        }
        return null;
      },
    );
  }

  Widget _buildDateField(BuildContext context) {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: 'Date de naissance',
        prefixIcon: Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
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

  Widget _buildAddButton() {
    return ElevatedButton(
      onPressed: _addUser,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.greenAccent,
      ),
      child: Center(
        child: Text(
          'Ajouter',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
