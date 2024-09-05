import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:mescidgo/core/constants/colors.dart';
import 'package:mescidgo/core/widgets/custom_app_bar.dart';
import 'package:mescidgo/features/auth/domain/validators/auth_validators.dart';
import 'package:mescidgo/features/auth/presentation/widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({
    Key? key,
  }) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _surnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _register() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    // Validate user input
    if (!AuthValidators.isValidEmail(email)) {
      setState(() {
        _errorMessage = 'Invalid email format';
      });
      return;
    }

    if (!AuthValidators.isPasswordMatching(password, confirmPassword)) {
      setState(() {
        _errorMessage = 'Passwords do not match';
      });
      return;
    }

    if (!AuthValidators.isPasswordLengthValid(password)) {
      setState(() {
        _errorMessage = 'Password must be at least 6 characters long';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;
      if (user != null) {
        await _database.ref().child('users/${user.uid}').set({
          'name': _nameController.text.trim(),
          'surname': _surnameController.text.trim(),
          'email': email,
        });

        Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = 'Registration failed: ${e.message}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.nearWhite,
      appBar: CustomAppBar(
        title: 'Kayıt Ol',
        showBackButton: true,
        titleCentered: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTextField(_nameController, 'Name'),
            _buildTextField(_surnameController, 'Surname'),
            _buildTextField(_emailController, 'Email', keyboardType: TextInputType.emailAddress),
            _buildTextField(_passwordController, 'Password', obscureText: true),
            _buildTextField(_confirmPasswordController, 'Confirm Password', obscureText: true),
            SizedBox(height: 20),
            if (_errorMessage != null)
              Text(_errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            _isLoading
                ? Center(child: CircularProgressIndicator(color: AppColors.primaryGreen))
                : CustomButton(
                    text: 'Kayıt Ol',
                    backgroundColor: AppColors.primaryGreen,
                    textColor: AppColors.primaryBeige,
                    onPressed: _register,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, {bool obscureText = false, TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
        obscureText: obscureText,
        keyboardType: keyboardType,
      ),
    );
  }
}
