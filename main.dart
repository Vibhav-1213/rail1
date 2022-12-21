import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rail/firebase_options.dart';
import 'Home.dart';
import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(debugShowCheckedModeBanner: false, home: LoginPage()));
}

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return LoginPageState();
  }
}

final GoogleSignIn _googleSignIn =
    GoogleSignIn(clientId: DefaultFirebaseOptions.currentPlatform.iosClientId);

class LoginPageState extends State<LoginPage> {
  GoogleSignInAccount? _currentUser;

  @override
  void initState() {
    _googleSignIn.onCurrentUserChanged.listen((account) {
      log(account.toString());
      setState(() {
        _currentUser = account;
      });
    });
    _googleSignIn.signInSilently();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: CustomScrollView(
        slivers: [
          SliverAppBar.large(
            backgroundColor: Colors.black87,
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(4.0),
              child: Container(
                color: Colors.blueAccent,
                height: 4.0,
              ),
            ),
            leading: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
            title: const Text(
              'Discover Trains',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.white,
                  ))
            ],
          ),
          SliverToBoxAdapter(
            child: _buildWidget(),
          ),
        ],
      ),
    );
  }

  Widget _buildWidget() {
    GoogleSignInAccount? user = _currentUser;
    if (user == null) {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              child: Image.asset(
                "assets/images/Train1.jpg",
                height: 300,
                width: 350,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              'Sign in to continue',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: signIn,
                child: const Text(
                  'Sign In',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      );
    } else {
      return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Container(
                child: Image.asset(
                  "assets/images/Train1.jpg",
                  height: 300,
                  width: 350,
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 10,
              endIndent: 10,
            ),
            Container(
              child: ListTile(
                leading: GoogleUserCircleAvatar(identity: user),
                title: Text(
                  user.displayName ?? '',
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  user.email,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const Divider(
              color: Colors.white,
              indent: 10,
              endIndent: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              'Signed in Successfully!',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: signOut,
                child: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.white),
                )),
            const SizedBox(
              height: 10,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => (const HomePage())));
                },
                child: const Text(
                  'Book your Tickets!',
                  style: TextStyle(color: Colors.white),
                )),
          ],
        ),
      );
    }
  }

  void signOut() {
    _googleSignIn.signOut();
  }

  Future<void> signIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (e) {
      print('Error signing in $e');
    }
  }
}
