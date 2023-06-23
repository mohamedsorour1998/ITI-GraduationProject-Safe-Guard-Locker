// Contains the login form and handles login functionality.
import 'package:flutter/material.dart';
import '../utils/app_routes.dart';
import '../services/api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
void _submitForm() async {
  if (!_formKey.currentState!.validate()) {
    return;
  }
  _formKey.currentState!.save();

  final apiService = ApiService();
  final success = await apiService.loginUser(_email, _password);

  if (success) {
    Navigator.of(context).pushReplacementNamed(AppRoutes.mainPage);
  } else {
    // Show an error message or handle login failure and go to the main page.
    print('Login failed');
    Navigator.of(context).pushReplacementNamed(AppRoutes.mainPage);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
                validator: (password) {
                  if (password == null || password.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
                onSaved: (password) => _password = password!,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.registerPage);
                },
                child: Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}