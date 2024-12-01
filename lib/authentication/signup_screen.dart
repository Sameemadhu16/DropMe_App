import 'package:flutter/material.dart';
import 'package:uber_app_clone/authentication/login_screen.dart';
import 'package:uber_app_clone/methods/common_methods.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameTextEditingController = TextEditingController();
  TextEditingController userPhoneTextEditingController =
      TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  CommonMethods cMethods = CommonMethods();

  checkIfNetworkIsAvailable() {
    cMethods.checkConnectivity(context); //object oriented approach

    signUpFormValidation();
  }

  void signUpFormValidation() {
  String username = usernameTextEditingController.text.trim();
  String phone = userPhoneTextEditingController.text.trim();
  String email = emailTextEditingController.text.trim();
  String password = passwordTextEditingController.text.trim();

  if (username.isEmpty) {
    cMethods.displaySnackBar("Username cannot be empty", context);
  } else if (username.length < 3) {
    cMethods.displaySnackBar("Your name must be 4 or more characters", context);
  } else if (phone.isEmpty) {
    cMethods.displaySnackBar("Phone number cannot be empty", context);
  } else if (phone.length != 10) {
    cMethods.displaySnackBar("Your phone number must be 10 characters", context);
  } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
    cMethods.displaySnackBar("Your phone number must contain only digits", context);
  } else if (email.isEmpty) {
    cMethods.displaySnackBar("Email cannot be empty", context);
  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email)) {
    cMethods.displaySnackBar("Please enter a valid email", context);
  } else if (password.isEmpty) {
    cMethods.displaySnackBar("Password cannot be empty", context);
  } else if (password.length < 6) {
    cMethods.displaySnackBar("Your password must be at least 6 characters", context);
  } else if (!RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,}$').hasMatch(password)) {
    cMethods.displaySnackBar("Password must contain uppercase, lowercase, number, and special character", context);
  } else {
    // Register the user
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
                "Create a User\'s Account",
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
                      controller: usernameTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Username",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        hintText: "Enter your Username",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    TextField(
                      controller: userPhoneTextEditingController,
                      keyboardType: TextInputType.text,
                      decoration: const InputDecoration(
                        labelText: "Phone Number",
                        labelStyle: TextStyle(
                          fontSize: 14,
                        ),
                        hintText: "Enter your Phone Number",
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                        ),
                      ),
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(
                      height: 22,
                    ),
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
                        checkIfNetworkIsAvailable();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        padding:
                            EdgeInsets.symmetric(horizontal: 80, vertical: 10),
                      ),
                      child: const Text(
                        "Sign Up",
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
                      MaterialPageRoute(builder: (c) => LoginScreen()));
                },
                child: const Text(
                  "Already have an account? Login here",
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
