import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:myapp/auth/login.dart';
import 'package:myapp/auth/signup.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

class HomePage extends StatelessWidget {
  final bool isLoading;
  final Future<void> Function() launchUrl;

  const HomePage({
    Key? key,
    required this.isLoading,
    required this.launchUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Spacer(),
            const Text(
              'Sign Out',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () async {
                try {
                  GoogleSignIn googleSignIn = GoogleSignIn();
                  if (await googleSignIn.isSignedIn()) {
                    await googleSignIn.disconnect();
                  }
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushNamedAndRemoveUntil("login", (route) => false);
                } catch (e) {
                  print('Error during sign out: $e');
                }
              },
              icon: Icon(Icons.exit_to_app),
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Image.asset(
                'images/eye.examble.jpg',
                width: 350,
                height: 350,
              ),
            ), const Text(
              'Notification Note',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.red,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            const Text(
              'Please make sure to upload or take a ',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'photo that focuses on the eye only.',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const Text(
              'Then check your case result.',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            isLoading
                ? const Text(
              'Loading......',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            )
                : ElevatedButton(
              onPressed: launchUrl,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[500],
                padding: EdgeInsets.symmetric(horizontal: 60, vertical: 13),
                textStyle: const TextStyle(
                  fontSize: 20,
                ),
              ),
              child: const Text(
                'Get Start',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
