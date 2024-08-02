
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase/ui/auth/login_screen.dart';
import 'package:firebase/utills/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[600],
        foregroundColor: Colors.white,
        title: Text("After login"),

        actions: [
          IconButton(onPressed: (){
            auth.signOut().then((value) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
            }).onError((error, stackTrace) {
              Utils().toastMessage(error.toString());
            });
          }, icon:Icon(Icons.logout),),
          SizedBox(
            width:10,
          )

        ],

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        SizedBox(
        width: 250.0,
        child: DefaultTextStyle(
          style: const TextStyle(
            fontSize: 30.0,
            fontFamily: 'Agne',
            color: Colors.black,
          ),

          child: Center(
            child: AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(' Discipline is the best tool'             ),
                TypewriterAnimatedText(' Design first, then code'                 ),
                TypewriterAnimatedText(' Do not give up'                          ),
                TypewriterAnimatedText(' Do not test bugs out, design them out'    ),
              ],
              onTap: () {
                print("Tap Event");
              },
            ),
          ),
        ),
      ),
        ],
      ),
    );
  }
}
