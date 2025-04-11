import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zanvar_doe_app/screens/account_failed_screen.dart';
import 'package:zanvar_doe_app/screens/account_success_screen.dart';
import 'package:zanvar_doe_app/screens/final_results.dart';
import 'package:zanvar_doe_app/screens/home_screen.dart';
import 'package:zanvar_doe_app/screens/login_screen.dart';
import 'package:zanvar_doe_app/screens/profile_screen.dart';
import 'package:zanvar_doe_app/screens/search_doe_screen.dart';
import 'package:zanvar_doe_app/screens/search_results_screen.dart';
import 'package:zanvar_doe_app/screens/welcome_screen.dart';
import 'package:zanvar_doe_app/screens/create_account_screen_1.dart';
import 'package:zanvar_doe_app/screens/create_account_screen_2.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLogin = prefs.getBool("isLogin") ?? false;
  String initialRoute = isLogin ? '/home' : '/';

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: initialRoute,
      routes: {
        '/': (context) => WelcomeScreen(),
        '/createAccountScreen1': (context) => CreateAccountScreen1(),
        '/createAccountScreen2': (context) => CreateAccountScreen2(),
        '/accountSuccess': (context) => AccountSuccessScreen(),
        '/accountFailure': (context) => AccountFailureScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/searchDOE': (context) => SearchDOEScreen(),
        '/profile': (context) => ProfileScreen(),
        '/searchResults': (context) => SearchResultsScreen(),
        '/finalResults': (context) => FinalResultScreen(),
      },
    );
  }
}
