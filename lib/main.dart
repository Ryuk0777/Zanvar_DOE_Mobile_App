import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Import your screen widgets here
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

class MyApp extends StatefulWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    authenticate();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.initialRoute,
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

  Future<void> authenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("auth_token");

    if (token != null && token.isNotEmpty) {
      try {
        final response = await http.post(
          Uri.parse("https://doe-backend.onrender.com/auth/verify-token"),
          headers: {'Content-Type': 'application/json'},
          body: json.encode({"token": token}),
        );

        var data = jsonDecode(response.body);

        if(data["valid"]){
          prefs.setBool("isLogin", true);
        }else{
          prefs.setBool("isLogin", false);
        }

      } catch (e) {
        prefs.setBool("isLogin", false);
      }
    } else {
      prefs.setBool("isLogin", false);
    }
  }
}
