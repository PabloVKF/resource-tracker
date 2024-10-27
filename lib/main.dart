import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';


import 'firebase_options.dart';
import 'route_generator.dart';
import 'theme_manager.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeManager.lightTheme,
      darkTheme: ThemeManager.darkTheme,
      themeMode: ThemeManager.themeMode,
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
