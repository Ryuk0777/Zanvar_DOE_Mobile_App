import 'package:flutter/material.dart';

class PasswordInputScreen extends StatefulWidget {
  const PasswordInputScreen({super.key});

  @override
  _PasswordInputScreenState createState() => _PasswordInputScreenState();
}

class _PasswordInputScreenState extends State<PasswordInputScreen> {
  
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool isPasswordVisible = false;
  bool hasMinLength = false;
  bool hasNumber = false;
  bool hasSymbol = false;

  bool bothPassAreSaame = false;

  void _validatePassword(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      hasNumber = password.contains(RegExp(r'[0-9]'));
      hasSymbol = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    });
  }

  void _validateConfirmPassword(String confirmPassword) {

    if(confirmPassword == passwordController.text){
      setState(() {
        bothPassAreSaame = true;
      });
    }
  }
   

  @override
  Widget build(BuildContext context) {
    bool isPasswordValid = hasMinLength && hasNumber && hasSymbol;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context), // ✅ Back navigation added
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text(
              "Create your password 3/3",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                _buildProgressIndicator(isActive: true),
                _buildProgressIndicator(isActive: true),
                _buildProgressIndicator(isActive: true),
              ],
            ),
            SizedBox(height: 30),
            Text(
              "Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              onChanged: _validatePassword,
              decoration: InputDecoration(
                hintText: "Enter password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.purple),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),

            SizedBox(height: 20),
            Text(
              "Confirm Password",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            TextField(
              controller: confirmPasswordController,
              obscureText: !isPasswordVisible,
              onChanged: _validateConfirmPassword,
              decoration: InputDecoration(
                hintText: "Confirm password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.purple),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      isPasswordVisible = !isPasswordVisible;
                    });
                  },
                ),
              ),
            ),
            SizedBox(height: 10),
            _buildPasswordCriteria("8 characters minimum", hasMinLength),
            _buildPasswordCriteria("a number", hasNumber),
            _buildPasswordCriteria("one symbol minimum", hasSymbol),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: isPasswordValid
                  ? () {
                    if(bothPassAreSaame){
                      
                      Navigator.pushNamed(context, '/accountSuccess'); // ✅ Navigation added
                    }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: isPasswordValid ? Colors.purple : Colors.purple.withValues(alpha: 0.6),
                minimumSize: Size(double.infinity, 50),
              ),
              child: Text(
                isPasswordValid ? "Create Account" : "Continue",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            SizedBox(height: 20),
            Text(
              "By using Classroom, you agree to the Terms and Privacy Policy.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
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
        SizedBox(width: 8),
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
