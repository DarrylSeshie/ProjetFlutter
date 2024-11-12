import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';

class UtilisateurService { // service utiliateur avec des methode qui contact api backend
  final String apiUrl = "http://localhost:7071/api/Utilisateurs";

  Future<List<Utilisateur>> fetchUtilisateurs(String token) async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Utilisateur.fromJson(json)).toList();
    } else {
      throw Exception(' Une erreur est survenue lors du chargement des utilisateurs');
    }
  }

  Future<void> createUtilisateur(Utilisateur utilisateur) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(utilisateur.toJson()),
    );

    if (response.statusCode != 201) {
      throw Exception('Erreur lors de la création de l\'utilisateur');
    }
  }

// suite.
}
