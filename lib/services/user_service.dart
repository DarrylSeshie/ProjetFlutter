import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';


class UtilisateurService {
  final String apiUrl = 'http://10.0.2.2:5053/api/Utilisateurs';
  final String loginUrl = 'http://10.0.2.2:5053/login';


  // Méthode pour envoyer une requête de connexion avec multipart/form-data
  Future<String> login(String email, String password) async {
    var request = http.MultipartRequest('POST', Uri.parse(loginUrl));
    request.fields['email'] = email;
    request.fields['mot_de_passe'] = password;

    try {
      var response = await request.send();
      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print('Response data: $responseData');
        var jsonResponse = json.decode(responseData);
        return jsonResponse['token']; // Suppose que la réponse contient un token
      } else {
        throw Exception('Erreur lors de la connexion : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    }
  }


  // Méthode pour récupérer tous les utilisateurs
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
      throw Exception('Une erreur est survenue lors du chargement des utilisateurs');
    }
  }

  // Méthode pour créer un nouvel utilisateur
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

  // Méthode pour récupérer un utilisateur par ID
  Future<Utilisateur> fetchUtilisateurById(String token, int id) async {
    final response = await http.get(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return Utilisateur.fromJson(json.decode(response.body));
    } else {
      throw Exception('Erreur lors de la récupération de l\'utilisateur');
    }
  }

  // Méthode pour mettre à jour un utilisateur existant
  Future<void> updateUtilisateur(String token, int id, Utilisateur utilisateur) async {
    final response = await http.put(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(utilisateur.toJson()),
    );

    if (response.statusCode != 204) {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur');
    }
  }

  // Méthode pour supprimer un utilisateur par ID
  Future<void> deleteUtilisateur(String token, int id) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/$id'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 204) {
      throw Exception('Erreur lors de la suppression de l\'utilisateur');
    }
  }
}
