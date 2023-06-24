import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import '../services/api_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _confirmPassword = '';

  // Create a TextEditingController for the Password TextFormField
  final TextEditingController _passwordController = TextEditingController();

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();

    final apiService = ApiService();
    final success = await apiService.registerUser(_email, _password);

    if (success) {
      print('Registration successful');
      Navigator.of(context).pushReplacementNamed(AppRoutes.loginPage);
    } else {
      // Show an error message or handle registration failure and go to the main page.
      print('Registration failed');
      Navigator.of(context).pushReplacementNamed(AppRoutes.mainPage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (email) {
                  if (email == null || email.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
                onSaved: (email) => _email = email!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                controller:
                    _passwordController, // Add the TextEditingController
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (password) => _password = password!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (confirmPassword) {
                  if (confirmPassword == null || confirmPassword.isEmpty) {
                    return 'Please confirm your password';
                  }
                  // Use _passwordController.text for comparison
                  if (confirmPassword != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
                onSaved: (confirmPassword) =>
                    _confirmPassword = confirmPassword!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
