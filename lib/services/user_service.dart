import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';

// Stockage sécurisé du token
final FlutterSecureStorage _storage = FlutterSecureStorage();

class UtilisateurService {
  final String apiUrl = 'http://192.168.56.1:5053/api/Utilisateurs';
  final String loginUrl = 'http://192.168.56.1:5053/login';

  // Méthode de connexion
  Future<String> login(String email, String password) async {
    var request = http.MultipartRequest('POST', Uri.parse(loginUrl));
    request.fields['email'] = email;
    request.fields['mot_de_passe'] = password;

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        var responseData = await response.stream.bytesToString();
        print('Response data: $responseData');

        // Stockage du token
        await _storage.write(key: 'token', value: responseData);
        print('Token stocké avec succès');
        return responseData;
      } else {
        throw Exception('Erreur lors de la connexion : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la connexion : $e');
    }
  }

  // Méthode pour inscrire  un utilisateur (avec hachage de mot de passe côté serveur)
  Future<void> postUtilisateur(Utilisateur utilisateur) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(utilisateur.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception(
          'Erreur lors de la création de l\'utilisateur : ${response.body}',
        );
      }
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'utilisateur : $e');
    }
  }



  // Méthode pour créer un nouvel utilisateur
  Future<void> createUtilisateur(Utilisateur utilisateur) async {
    String? token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token non disponible. Veuillez vous connecter.');
    }

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(utilisateur.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Erreur lors de la création de l\'utilisateur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la création de l\'utilisateur : $e');
    }
  }


  // Méthode pour récupérer tous les utilisateurs avec token
  Future<List<Utilisateur>> fetchUtilisateurs() async {
    // Récupérer le token stocké
    String? token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token non disponible. Veuillez vous connecter.');
    }

    try {
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
      } else if (response.statusCode == 401) {
        throw Exception('Non autorisé : le token est peut-être invalide ou expiré.');
      } else {
        throw Exception('Erreur lors du chargement des utilisateurs : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération des utilisateurs : $e');
    }
  }

  // Méthode pour récupérer un utilisateur par ID avec token
  Future<Utilisateur> fetchUtilisateurById(int id) async {
    String? token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token non disponible. Veuillez vous connecter.');
    }

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return Utilisateur.fromJson(json.decode(response.body));
      } else if (response.statusCode == 404) {
        throw Exception('Utilisateur non trouvé');
      } else if (response.statusCode == 401) {
        throw Exception('Non autorisé : le token est peut-être invalide ou expiré.');
      } else {
        throw Exception('Erreur lors de la récupération de l\'utilisateur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la récupération de l\'utilisateur : $e');
    }
  }

  // Méthode pour mettre à jour un utilisateur
  Future<void> updateUtilisateur(int id, Utilisateur utilisateur) async {
    String? token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token non disponible. Veuillez vous connecter.');
    }

    try {
      final response = await http.put(
        Uri.parse('$apiUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(utilisateur.toJson()),
      );

      if (response.statusCode != 204) {
        throw Exception('Erreur lors de la mise à jour de l\'utilisateur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de l\'utilisateur : $e');
    }
  }

  // Méthode pour supprimer un utilisateur
  Future<void> deleteUtilisateur(int id) async {
    String? token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token non disponible. Veuillez vous connecter.');
    }

    try {
      final response = await http.delete(
        Uri.parse('$apiUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode != 204) {
        throw Exception('Erreur lors de la suppression de l\'utilisateur : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la suppression de l\'utilisateur : $e');
    }
  }


  Future<List<Utilisateur>> searchUtilisateursByName(String name) async {
    String? token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token non disponible. Veuillez vous connecter.');
    }

    try {
      final response = await http.get(
        Uri.parse('$apiUrl/byname/$name'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Utilisateur.fromJson(json)).toList();
      } else if (response.statusCode == 404) {
        return []; // Aucun utilisateur trouvé
      } else if (response.statusCode == 401) {
        throw Exception('Non autorisé : le token est peut-être invalide ou expiré.');
      } else {
        throw Exception('Erreur lors de la recherche des utilisateurs : ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la recherche des utilisateurs : $e');
    }
  }

  Future<Utilisateur> fetchCurrentUser() async {
    String? token = await _storage.read(key: 'token');
    if (token == null) {
      throw Exception('Token non disponible. Veuillez vous connecter.');
    }

    // Décoder le token pour obtenir l'ID de l'utilisateur
    try {
      final decodedToken = json.decode(
        utf8.decode(base64.decode(base64.normalize(token.split('.')[1]))),
      );
      final int userId = int.parse(decodedToken['id']);

      // Récupérer les informations de l'utilisateur par ID
      return await fetchUtilisateurById(userId);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des informations utilisateur : $e');
    }
  }


}
