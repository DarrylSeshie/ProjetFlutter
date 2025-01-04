import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialisation de l'animation
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Durée d'une boucle d'animation
      vsync: this,
    )..repeat(); // Répète l'animation indéfiniment

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);

    // Naviguer vers la page de connexion après 5 secondes
    _navigateToLogin();
  }

  @override
  void dispose() {
    _controller.dispose(); // Libérer les ressources de l'animation
    super.dispose();
  }

  void _navigateToLogin() async {
    await Future.delayed(Duration(seconds: 5)); // Temps d'attente
    Navigator.pushReplacementNamed(context, '/login'); // Redirection vers /login
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.tealAccent, // Couleur de fond personnalisée
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image animée
            FadeTransition(
              opacity: _animation,
              child: Image.asset(
                'assets/images/users_splash_list.png', // Chemin vers votre logo
                height: 150, // Taille du logo
              ),
            ),
            SizedBox(height: 30),

            // Loader circulaire animé
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white), // Couleur du loader
              strokeWidth: 3, // Épaisseur du loader
            ),
            SizedBox(height: 20),

            // Texte d'accueil
            Text(
              'Veuillez patienter...',
              style: TextStyle(
                color: Colors.white, // Couleur du texte
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
