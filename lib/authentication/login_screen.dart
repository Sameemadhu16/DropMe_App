import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_app_clone/authentication/signup_screen.dart';
import 'package:uber_app_clone/global/global_var.dart';
// import 'package:uber_app_clone/main.dart';
import 'package:uber_app_clone/methods/common_methods.dart';
import 'package:uber_app_clone/widgets/loading_dailog.dart';
import 'package:uber_app_clone/pages/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

TextEditingController emailTextEditingController = TextEditingController();
TextEditingController passwordTextEditingController = TextEditingController();
CommonMethods cMethods = CommonMethods();

void checkIfNetworkIsAvailable(BuildContext context) async {
  bool isConnected = await cMethods
      .checkConnectivity(context); // Ensure checkConnectivity returns a boolean

  if (isConnected) {
    signinFormValidation(context);
  } else {
    cMethods.displaySnackBar("No network connection", context);
  }
}

void signinFormValidation(BuildContext context) {
  String email = emailTextEditingController.text.trim();
  String password = passwordTextEditingController.text.trim();

  if (email.isEmpty) {
    cMethods.displaySnackBar("Email cannot be empty", context);
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    cMethods.displaySnackBar("Please enter a valid email", context);
  } else if (password.isEmpty) {
    cMethods.displaySnackBar("Password cannot be empty", context);
  } else {
    signInUser(context, email, password);
  }
}

void signInUser(BuildContext context, String email, String password) async {
  // Show loading dialog
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return LoadingDailog(messageText: "Signing in, Please wait...");
    },
  );

  try {
    final User? userFirebase =
        (await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
            .user;

    if (!context.mounted) return;
    Navigator.pop(context); // Close the loading dialog

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance
          .ref()
          .child("users")
          .child(userFirebase.uid);
      final snap = await usersRef.get();

      if (snap.exists && snap.value != null) {
        final userData = snap.value as Map;
        if (userData["blockStatus"] == "no") {
          userName = userData["name"];
          Navigator.push(
              context, MaterialPageRoute(builder: (c) => HomePage()));
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar(
              "You are blocked. Contact support: company@gmail.com", context);
        }
      } else {
        FirebaseAuth.instance.signOut();
        cMethods.displaySnackBar("User not found", context);
      }
    }
  } on FirebaseAuthException catch (e) {
    Navigator.pop(context); // Close the loading dialog
    if (e.code == 'user-not-found') {
      cMethods.displaySnackBar("Email not found", context);
    } else if (e.code == 'wrong-password') {
      cMethods.displaySnackBar("Your password is wrong", context);
    } else {
      cMethods.displaySnackBar("Sign-in failed: ${e.message}", context);
    }
  } catch (error) {
    print("Error during sign-in: $error");
    if (!context.mounted) return;
    Navigator.pop(context); // Close the loading dialog
    cMethods.displaySnackBar("Sign-in failed: $error", context);
  }
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 250,
                width: 250,
              ),
              const Text(
                "Login to your Account",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),

              //text form field + button
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 22),
                child: Column(
                  children: [
                    TextField(
                        controller: emailTextEditingController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Enter your Email",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        )),
                    const SizedBox(
                      height: 22,
                    ),
                    TextField(
                        controller: passwordTextEditingController,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        decoration: const InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14,
                          ),
                          hintText: "Enter your Password",
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        )),
                    const SizedBox(
                      height: 22,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        checkIfNetworkIsAvailable(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      ),
                      child: const Text(
                        "Login",
                      ),
                    ),
                  ],
                ),
              ),

              // const SizedBox(height: 12,),
              //text button
              TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => SignUpScreen()));
                },
                child: const Text(
                  "Don't have an Account? Sign Up",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
