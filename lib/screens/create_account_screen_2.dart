import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:zanvar_doe_app/data/notifiers.dart';
import 'package:http/http.dart' as http;

class CreateAccountScreen2 extends StatefulWidget {
  const CreateAccountScreen2({Key? key}) : super(key: key);

  @override
  _CreateAccountScreen2State createState() => _CreateAccountScreen2State();
}

class _CreateAccountScreen2State extends State<CreateAccountScreen2> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  bool hasMinLength = false;
  bool hasNumber = false;
  bool hasSymbol = false;
  bool bothPassAreSame = false;

  void _validatePassword(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSymbol = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
    _validateConfirmPassword(confirmPasswordController.text);
  }

  void _validateConfirmPassword(String confirmPassword) {
    setState(() {
      bothPassAreSame =
          passwordController.text.isNotEmpty &&
          confirmPassword.isNotEmpty &&
          confirmPassword == passwordController.text;
    });
  }

  Future<void> createAccount(Map data) async {
    try {
          final response = await http.post(
                Uri.parse(""), // Change to legit api end point
                body: json.encode(data),
                headers: {'Content-Type': 'application/json'},
              );

    if(response.statusCode == 201){
      print("Account Created Successfully");
      Navigator.pushNamed(context, '/accountSuccess');
    } else {
      print("Failed to create account: ${response.body}");
        Navigator.pushNamed(context, '/accountFailure');
    }
    } catch (e) {
      print("Failed to create account: $e");
      Navigator.pushNamed(context, '/accountFailure');
    } 

  }

  @override
  Widget build(BuildContext context) {
    bool isPasswordValid = hasMinLength && hasNumber && hasSymbol;

    return ValueListenableBuilder(
      valueListenable: createAccountMapNotifier,
      builder: (context, value, child) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(
              context,
            ).unfocus(); // Dismisses the keyboard when tapping outside
          },
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ListView(
                children: [
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      "Create your password 2/2",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildProgressIndicator(isActive: true),
                        _buildProgressIndicator(isActive: true),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    "Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: passwordController,
                    obscureText: !isPasswordVisible,
                    onChanged: _validatePassword,
                    decoration: InputDecoration(
                      hintText: "Enter password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Confirm Password",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: !isConfirmPasswordVisible,
                    onChanged: _validateConfirmPassword,
                    decoration: InputDecoration(
                      hintText: "Confirm password",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isConfirmPasswordVisible =
                                !isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildPasswordCriteria("8 characters minimum", hasMinLength),
                  _buildPasswordCriteria("A number", hasNumber),
                  _buildPasswordCriteria("One symbol minimum", hasSymbol),
                  _buildPasswordCriteria("Passwords match", bothPassAreSame),
                  const SizedBox(height: 20),
                  const Text(
                    "By continuing, you agree to the Terms and Privacy Policy",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isPasswordValid && bothPassAreSame
                            ? Colors.purple
                            : Colors.purple.withValues(alpha: 0.6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed:
                      isPasswordValid && bothPassAreSame
                          ? () {
                            createAccountMapNotifier.value['password'] =
                                passwordController.text;
                            createAccount(createAccountMapNotifier.value);
                          }
                          : null,
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProgressIndicator({required bool isActive}) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Container(
        width: 20,
        height: 4,
        decoration: BoxDecoration(
          color: isActive ? Colors.purple : Colors.grey[300],
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildPasswordCriteria(String text, bool isValid) {
    return Row(
      children: [
        Icon(
          isValid ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isValid ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 14,
            color: isValid ? Colors.green : Colors.grey,
          ),
        ),
      ],
    );
  }
}
