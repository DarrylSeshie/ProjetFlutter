import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert'; // Sert à décoder les réponses JSON

import 'pages/add_user_page.dart';
import 'pages/users_list_page.dart';
import 'pages/user_detail_page.dart';
import 'pages/register_page.dart';
import 'widgets/splash_screen.dart'; // Fichier pour le splash screen
import 'pages/login_page.dart'; // Page de connexion

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application',
      initialRoute: '/', // Définit le splash screen comme route initiale
      routes: {
        '/': (context) => SplashScreen(), // Splash Screen
        '/login': (context) => LoginPage(), // Page de connexion
        '/users': (context) => UsersListPage(),
        '/userDetail': (context) => UserDetailPage(),
        '/addUser': (context) => AddUserPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}
