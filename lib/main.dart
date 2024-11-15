import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // sert à décoder les réponses JSON
import 'pages/users_list_page.dart'; // Assure-toi que le chemin est correct
import 'pages/user_detail_page.dart'; // Assure-toi que le chemin est correct



import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion des Utilisateurs',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // La première page affichée
      routes: {
        '/login': (context) => LoginPage(),
        '/users': (context) => UsersListPage(),
        '/userDetail': (context) => UserDetailPage(),
      },
    );
  }
}
