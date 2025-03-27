import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/components/textformfield.dart';
import '../components/Customlogoauth.dart';
import '../components/custombuttenauth.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();


  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null){
      return; //=================stop
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushNamedAndRemoveUntil("homepage", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Form(
              key: formState,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1),

                  // logo <==========================================
                  const CustomLogoAuth(),

                  const Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Login To Continue Using The Eye Detect App",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  Container(height: 20),

                  // Email <=============================================
                  const Text(
                    "Email",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(height: 10),
                  CustomTextFrom(
                    obscureText: false,
                    hinttext: "Enter Your Email",
                    mycontroller: email,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                      return null;
                    },
                  ),
                  Container(height: 20),

                  // Password <==========================================
                  const Text(
                    "Password",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(height: 10),
                  CustomTextFrom(
                    obscureText: true,
                    hinttext: "Enter Your Password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be Empty";
                      }
                      return null;
                    },
                  ),

                  InkWell(
                    onTap: () async {
                      if (email.text == "" ){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Enter Email',
                          desc: 'Please enter your email and try again',
                          btnOkOnPress: () {},
                        ).show();
                        return;

                      }
                      try{
                        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                        AwesomeDialog(
                            context: context,
                            dialogType: DialogType.success,
                            animType: AnimType.rightSlide,
                            title: 'Email Sent',
                            desc: 'Password reset link has been sent.'
                                'Please open the email.',
                            btnOkOnPress: () {},
                        ).show();
                      }catch(e){
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Invalid Email',
                          desc: 'Please enter the valid email and try again.',
                          btnOkOnPress: () {},
                        ).show();
                        }
                        print(e);
                      },

                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Login button <==========================================
            CustomButtonAuth(
              title: "Login",
              onPressed: () async {

                if (formState.currentState!.validate()) {
                  try {
                    final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email.text,
                      password: password.text,);

                    if (credential.user!.emailVerified){
                      Navigator.of(context).pushReplacementNamed("homepage");

                    }else{
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.success,
                        animType: AnimType.rightSlide,
                        title: 'Email Sent',
                        desc: 'A verification email has been sent to your email address.',
                        btnOkOnPress: () {},
                      ).show();
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'No user found for that email.',
                        btnOkOnPress: () {},
                      ).show();
                    } else if (e.code == 'wrong-password') {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.error,
                        animType: AnimType.rightSlide,
                        title: 'Error',
                        desc: 'Wrong password provided for that user.',
                        btnOkOnPress: () {},
                      ).show();
                    } else {
                      print("Not Valid");
                    }
                  }
                }
              },
            ),
            Container(height: 10),

            // Login with Google <==========================================
            MaterialButton(
              height: 42,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.orange,
              textColor: Colors.black,
              onPressed: () {
                signInWithGoogle();
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  Image.asset("images/google.png", width: 25),
                ],
              ),
            ),
            Container(height: 15),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Don't Have An Account? "),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
