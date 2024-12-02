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
  } else if (password.length < 6) {
    cMethods.displaySnackBar(
        "Your password must be at least 6 characters", context);
  } else if (!RegExp(
          r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$')
      .hasMatch(password)) {
    cMethods.displaySnackBar(
        "Password must contain uppercase, lowercase, number, and special character",
        context);
  } else {
    signInUser(context);
  }
}

Future<void> signInUser(BuildContext context) async {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) => LoadingDailog(
      messageText: "Allowing you to Login...",
    ),
  );

  try {
    final User? userFirebase = (await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    ))
        .user;

    if (!context.mounted) return;
    Navigator.pop(context); // Close the loading dialog

    if (userFirebase != null) {
      DatabaseReference usersRef = FirebaseDatabase.instance.ref().child("users").child(userFirebase.uid);
      final snap = await usersRef.get(); // Updated from .once() to .get()

      if (snap.exists && snap.value != null) {
        final userData = snap.value as Map;
        if (userData["blockStatus"] == "no") {
          userName = userData["name"];
          Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
        } else {
          FirebaseAuth.instance.signOut();
          cMethods.displaySnackBar("You are blocked. Contact support: company@gmail.com", context);
        }
      } else {
        FirebaseAuth.instance.signOut();
        cMethods.displaySnackBar("User not found", context);
      }
    } else {
      cMethods.displaySnackBar("Sign in failed. Please try again.", context);
    }
  } catch (e) {
    Navigator.pop(context); // Ensure the loading dialog is dismissed on error
    cMethods.displaySnackBar("Error: ${e.toString()}", context);
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
                  "Don\'t have an Account? Sign Up",
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
