import 'package:firebase/ui/auth/signup_screen.dart';
import 'package:firebase/utills/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../posts/post_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading = true;
      });

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );

        User? user = userCredential.user;

        if (user != null && !user.emailVerified) {
          Utils().toastMessage('Please verify your email.');
          await user.sendEmailVerification();
          setState(() {
            loading = false;
          });
        } else if (user != null && user.emailVerified) {
          Utils().toastMessage('Welcome ${user.email}');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => PostScreen()),
          );
        }
      } catch (error) {
        Utils().toastMessage(error.toString());
        setState(() {
          loading = false;
        });
      }
    }
  }

  Future<void> resetPassword() async {
    if (emailController.text.isNotEmpty) {
      try {
        await _auth.sendPasswordResetEmail(email: emailController.text.trim());
        Utils().toastMessage('Password reset email sent.');
      } catch (error) {
        Utils().toastMessage(error.toString());
      }
    } else {
      Utils().toastMessage('Please enter your email to reset your password.');
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return; // user aborted sign-in

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential = await _auth.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PostScreen()),
      );
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      final LoginResult result = await FacebookAuth.instance.login();
      if (result.status == LoginStatus.success) {
        final AccessToken accessToken = result.accessToken!;
        final AuthCredential credential = FacebookAuthProvider.credential(accessToken.tokenString);

        UserCredential userCredential = await _auth.signInWithCredential(credential);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PostScreen()),
        );
      } else {
        Utils().toastMessage('Facebook login failed.');
      }
    } catch (error) {
      Utils().toastMessage(error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[600],
        foregroundColor: Colors.white,
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.lock,
              size: 100,
            ),
            const SizedBox(height: 20),

            // welcome back, you've been missed!
            Text(
              'Welcome back you\'ve been missed!',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.email),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter email';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      prefixIcon: Icon(Icons.password),
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Enter password';
                      }
                      return null;
                    },
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: resetPassword,
                      child: Text('Forgot Password?'),
                    ),
                  ),
                ],
              ),
            ),

            RoundButton(
              title: 'Login',
              loading: loading,
              onTap: login,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Don't have an account?"),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignupScreen()),
                    );
                  },
                  child: Text('Sign up'),
                ),
              ],
            ),

            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('lib/images/facebook.png'),
                      height: 50, // Set your desired height
                      width: 50,  // Set your desired width
                    ),
                    SizedBox(width: 10), // space between logo and button
                    TextButton(
                      onPressed: signInWithFacebook,
                      child: Text('Login with Facebook'),
                    ),
                  ],
                ),
                SizedBox(height: 20), // space between rows
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image(
                      image: AssetImage('lib/images/google.png'),
                      height: 50, // Set your desired height
                      width: 50,  // Set your desired width
                    ),
                    SizedBox(width: 10), // space between logo and button
                    TextButton(
                      onPressed: signInWithGoogle,
                      child: Text('Login with Google'),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
