import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/components/textformfield.dart';
import '../components/Customlogoauth.dart';
import '../components/custombuttenauth.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> formState = GlobalKey<FormState>();

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
                    "Sign Up",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "SignUp To Continue Using The Eye Detect App",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                  Container(height: 10),
                  // Username <====================================
                  const Text(
                    "User Name",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Container(height: 10),
                  CustomTextFrom(
                    obscureText: false,
                    hinttext: "Enter Your Username",
                    mycontroller: username,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                      return null;
                    },
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
                        return "Can't be empty";
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
                    obscureText: false,
                    hinttext: "Enter Your Password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == "") {
                        return "Can't be empty";
                      }
                      return null;
                    },
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 5, bottom: 10),
                    alignment: Alignment.topRight,
                    child: const Text(
                      "                     ",
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                ],
              ),
            ),
            // Sign Up button <==========================================
            CustomButtonAuth(
              title: "Sign Up",
              onPressed: () async {
                if (formState.currentState!.validate()) {
                  try {
                    final credential =
                    await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email.text,
                      password: password.text,
                    );
                    FirebaseAuth.instance.currentUser?.sendEmailVerification();
                    Navigator.of(context).pushReplacementNamed("login");
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      print('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      print('The account already exists for that email.');
                    }
                  } catch (e) {
                    print(e);
                  }
                }
              },
            ),
            Container(height: 10),
            Container(height: 15),
            InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("login");
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "Do You Have An Account? "),
                      TextSpan(
                        text: "Login",
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
