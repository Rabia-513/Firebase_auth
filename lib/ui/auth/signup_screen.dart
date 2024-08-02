import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/utills/utils.dart';
import 'package:firebase/widgets/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool loading =false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  FirebaseAuth _auth=FirebaseAuth.instance;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
  void signup(){
    if (_formKey.currentState!.validate()) {
      setState(() {
        loading=true;
      });
      _auth.createUserWithEmailAndPassword(
          email: emailController.text.toString(),
          password: passwordController.text.toString()).then((value){
        setState(() {
          loading=false;
        });

      }).onError((error, stackTrace) {
        Utils().toastMessage(error.toString());
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[600],
        foregroundColor: Colors.white,
        title: Text("Signup"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(

          children: [
            const Icon(
              Icons.person,
              size: 200,
            ),
            const SizedBox(height: 20),

            // welcome back, you've been missed!
            Text(
              'welcome signup here!',
              style: TextStyle(
                color: Colors.grey[700],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: InputDecoration(
                          hintText: 'Email', prefixIcon: Icon(Icons.email),
                        enabledBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: 'Password',
                          prefixIcon: Icon(Icons.password),                        enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter password';
                        }
                        return null;
                      },
                    ),
                  ],
                )),
            SizedBox(
              height: 20,
            ),
            RoundButton(
              title: 'Signup',
              loading: loading,
              onTap: () {
               signup();
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[
                Text("Already have account/"),
                TextButton(onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(
                        builder:(context) =>LoginScreen()  ),
                  );
                },
                    child: Text('Login'))
              ],),
          ],
        ),
      ),
    );
  }
}
