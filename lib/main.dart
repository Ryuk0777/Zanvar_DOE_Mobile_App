import 'package:flutter/material.dart';
import 'package:zanvar_doe_app/screens/account_failed_screen.dart';
import 'package:zanvar_doe_app/screens/account_success_screen.dart';
import 'package:zanvar_doe_app/screens/home_screen.dart';
import 'package:zanvar_doe_app/screens/login_screen.dart';
import 'package:zanvar_doe_app/screens/profile_screen.dart';
import 'package:zanvar_doe_app/screens/search_doe_screen.dart';
import 'package:zanvar_doe_app/screens/search_results_screen.dart';
import 'package:zanvar_doe_app/screens/welcome_screen.dart';
import 'package:zanvar_doe_app/screens/create_account_screen_1.dart';
import 'package:zanvar_doe_app/screens/create_account_screen_2.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {

        // Home Screen
        '/': (context) => WelcomeScreen(),

        // Account Creation 
        '/createAccountScreen1': (context) => CreateAccountScreen1(),
        '/createAccountScreen2': (context) => CreateAccountScreen2(),
        '/accountSuccess': (context) => AccountSuccessScreen(),
        '/accountFailure': (context) => AccountFailureScreen(),

        // Account Login 
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(), 
        '/searchDOE': (context) => SearchDOEScreen(),
        '/profile': (context) => ProfileScreen(),
        '/searchResults': (context) => SearchResultsScreen(),
        
      },
    );
  }
}
