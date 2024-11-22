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
  late TextEditingController _prenomController;
  late TextEditingController _emailController;
  late TextEditingController _rueController;
  late TextEditingController _codePostalController;
  late TextEditingController _communeController;
  late TextEditingController _paysController;
  late TextEditingController _pointController;
  final UtilisateurService utilisateurService = UtilisateurService();
  bool isLoading = false;

  // Pour le champ "Rôle"
  final List<String> _roles = ['Admin', 'User'];
  String? _selectedRole;

  // Pour le champ "Date de naissance"
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController(text: widget.utilisateur.nom ?? '');
    _prenomController = TextEditingController(text: widget.utilisateur.prenom ?? '');
    _emailController = TextEditingController(text: widget.utilisateur.email);
    _rueController = TextEditingController(text: widget.utilisateur.rue ?? '');
    _codePostalController = TextEditingController(text: widget.utilisateur.codePostal ?? '');
    _communeController = TextEditingController(text: widget.utilisateur.commune ?? '');
    _paysController = TextEditingController(text: widget.utilisateur.pays ?? '');
    _pointController = TextEditingController(text: widget.utilisateur.point?.toString() ?? '');
    _selectedRole = widget.utilisateur.role;
    if (widget.utilisateur.dateDeNaissance != null) {
      _selectedDate = widget.utilisateur.dateDeNaissance;
      _dateController.text =
      "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
    }
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _rueController.dispose();
    _codePostalController.dispose();
    _communeController.dispose();
    _paysController.dispose();
    _pointController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        _dateController.text =
        "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  Future<void> _updateUtilisateur() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });

      widget.utilisateur.nom = _nomController.text;
      widget.utilisateur.prenom = _prenomController.text;
      widget.utilisateur.email = _emailController.text;
      widget.utilisateur.rue = _rueController.text;
      widget.utilisateur.codePostal = _codePostalController.text;
      widget.utilisateur.commune = _communeController.text;
      widget.utilisateur.pays = _paysController.text;
      widget.utilisateur.role = _selectedRole;
      widget.utilisateur.point = int.tryParse(_pointController.text) ?? 0;
      widget.utilisateur.dateDeNaissance = _selectedDate;

      try {
        await utilisateurService.updateUtilisateur(widget.utilisateur.id, widget.utilisateur);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur mis à jour avec succès')));
        Navigator.pop(context); // Retour à la page précédente après mise à jour
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur lors de la mise à jour : $e')));
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
        title: Text('Modifier Utilisateur'),
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
                    : _buildUpdateButton(),
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
          "Mettre à jour l'utilisateur",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        SizedBox(height: 8),
        Text(
          "Vous pouvez mettre à jour les informations de cet utilisateur.",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ],
    );
  }

  Widget _buildFormField(TextEditingController controller, String label, String? errorText, IconData icon,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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

  Widget _buildUpdateButton() {
    return ElevatedButton(
      onPressed: _updateUtilisateur,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: EdgeInsets.symmetric(vertical: 16),
        backgroundColor: Colors.greenAccent,
      ),
      child: Center(
        child: Text(
          'Mettre à jour',
          style: TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}
