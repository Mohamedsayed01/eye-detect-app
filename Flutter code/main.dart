import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/auth/login.dart';
import 'package:myapp/auth/signup.dart';
import 'package:myapp/homepage.dart';
import 'package:url_launcher/url_launcher.dart';

final Uri _url = Uri.parse('https://huggingface.co/spaces/Mez01/mezo');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoading = false;

  Future<void> _launchUrl() async {
    setState(() {
      _isLoading = true;
    });

    await Future.delayed(Duration(seconds: 3));

    setState(() {
      _isLoading = false;
    });

    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('====================== User is currently signed out!');
      } else {
        print('====================== User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: (FirebaseAuth.instance.currentUser != null &&
          FirebaseAuth.instance.currentUser!.emailVerified)
          ? HomePage(isLoading: _isLoading, launchUrl: _launchUrl)
          : Login(),
      routes: {
        "signup": (context) => SignUp(),
        "login": (context) => Login(),
        "homepage": (context) => HomePage(isLoading: _isLoading, launchUrl: _launchUrl),
      },
    );
  }
}
