import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:projet_mobile_user/pages/add_user_page.dart';
import 'dart:convert'; // sert à décoder les réponses JSON
import 'pages/users_list_page.dart';
import 'pages/user_detail_page.dart';
import 'pages/register_page.dart';



import 'pages/login_page.dart';

void main() {
  runApp(MyApp());
}



class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Application',
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/users': (context) => UsersListPage(),
        '/userDetail': (context) => UserDetailPage(),
        '/addUser': (context) => AddUserPage(),
        '/register': (context) => RegisterPage(),
      },
    );
  }
}