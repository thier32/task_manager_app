import 'package:flutter/material.dart';
import 'package:task_manager_app/main.reflectable.dart';
import 'pages/login_page.dart';
import 'main.reflectable.dart'; // Import du fichier généré

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  initializeReflectable();
  // Capture les erreurs de l'interface Flutter
  FlutterError.onError = (details) {
    FlutterError.presentError(details);
    final context = navigatorKey.currentContext;
    if(context != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur : ${details.exception}'),
          backgroundColor: Colors.red,
        ),
      );
    };
  };
  
  runApp(const MonGestionnaireDeTachesApp());
}

class MonGestionnaireDeTachesApp extends StatelessWidget {
  const MonGestionnaireDeTachesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestionnaire de tâches',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}
