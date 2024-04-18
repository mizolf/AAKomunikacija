import 'package:flutter/material.dart';
import 'package:ict_aac/screen/home.dart';
import 'package:ict_aac/models/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  String? errorMessage = '';
  bool isLogin = true;

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  Future<void> signInWithEmailAndPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-found') {
        _wrongEmailMessage();
      } else if (e.code == 'wrong-password') {
        _wrongPasswordMessage();
      }
    }
  }

  Future<void> createUserWithEmailAndPassword() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(child: CircularProgressIndicator());
      },
    );
    try {
      await Auth().createUserWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'email-already-in-use') {
        _accountExists();
      }
    }
  }

  void _wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Korisnik ne postoji'),
          content: const Text('Unijeli ste krivi email.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zatvori'),
            ),
          ],
        );
      },
    );
  }

  void _wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Netočna zaporka'),
          content: const Text('Unijeli ste krivu zaporku.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zatvori'),
            ),
          ],
        );
      },
    );
  }

  void _accountExists() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Email je korišten'),
          content: const Text('Račun s ovim emailom već postoji.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Zatvori'),
            ),
          ],
        );
      },
    );
  }

  Widget _emailField() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF6CA8F1),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controllerEmail,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.email_outlined, color: Colors.white),
            hintText: 'Unesite email adresu',
            hintStyle: TextStyle(color: Colors.white38)),
      ),
    );
  }

  Widget _passwordField() {
    return Container(
      alignment: Alignment.centerLeft,
      height: 60,
      decoration: BoxDecoration(
        color: const Color(0xFF6CA8F1),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: _controllerPassword,
        obscureText: true,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(color: Colors.white),
        decoration: const InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(
              Icons.password_outlined,
              color: Colors.white,
            ),
            hintText: 'Unesite lozinku',
            hintStyle: TextStyle(color: Colors.white38)),
      ),
    );
  }

  Widget _loginButton() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 25),
      width: double.infinity,
      height: 100,
      child: ElevatedButton(
        onPressed: isLogin
            ? () {
                signInWithEmailAndPassword();
              }
            : () {
                createUserWithEmailAndPassword();
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.white,
          shadowColor: Colors.black,
        ),
        child: Text(
          isLogin ? 'PRIJAVA' : 'REGISTRIRAJ SE',
          style: const TextStyle(
            color: Color(0xFF527DAA),
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Widget _loginOrRegisterButton() {
    return TextButton(
      onPressed: () {
        setState(() {
          isLogin = !isLogin;
        });
      },
      child: Text(
        isLogin ? 'REGISTRIRAJ SE' : 'PRIJAVI SE',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
                gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 117, 171, 238),
                Color(0xFF61A4F1),
                Color(0xFF478DE0),
                Color.fromARGB(255, 49, 120, 202),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
          ),
          Container(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 40.0, vertical: 120.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isLogin ? 'Prijavi se' : 'Registriraj se',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Email',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      _emailField(),
                      const SizedBox(
                        height: 30,
                      ),
                      const Text(
                        'Lozinka',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      _passwordField(),
                      const SizedBox(
                        height: 30,
                      ),
                      _loginButton(),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        '- ILI -',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _loginOrRegisterButton(),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
