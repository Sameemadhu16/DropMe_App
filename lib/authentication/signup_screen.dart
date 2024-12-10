import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber_app_clone/authentication/login_screen.dart';
import 'package:uber_app_clone/methods/common_methods.dart';
import 'package:uber_app_clone/pages/home.dart';
import 'package:uber_app_clone/widgets/loading_dailog.dart';

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

  void checkIfNetworkIsAvailable() async {
    bool isConnected = await cMethods.checkConnectivity(
        context); // Ensure checkConnectivity returns a boolean

    if (isConnected) {
      signUpFormValidation();
    } else {
      cMethods.displaySnackBar("No network connection", context);
    }
  }

  void signUpFormValidation() {
    String username = usernameTextEditingController.text.trim();
    String phone = userPhoneTextEditingController.text.trim();
    String email = emailTextEditingController.text.trim();
    String password = passwordTextEditingController.text.trim();

    if (username.isEmpty) {
      cMethods.displaySnackBar("Username cannot be empty", context);
    } else if (username.length < 3) {
      cMethods.displaySnackBar(
          "Your name must be 4 or more characters", context);
    } else if (phone.isEmpty) {
      cMethods.displaySnackBar("Phone number cannot be empty", context);
    } else if (phone.length != 10) {
      cMethods.displaySnackBar(
          "Your phone number must be 10 characters", context);
    } else if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      cMethods.displaySnackBar(
          "Your phone number must contain only digits", context);
    } else if (email.isEmpty) {
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
      registerNewUser();
    }
  }

  Future<void> registerNewUser() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => LoadingDailog(
        messageText: "Registering your account...",
      ),
    );

    try {
      final User? userFirebase =
          (await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ))
              .user;

      if (userFirebase != null) {
        print("User registered successfully with UID: ${userFirebase.uid}");

        DatabaseReference usersRef = FirebaseDatabase.instance
            .ref()
            .child("users")
            .child(userFirebase.uid);

        Map userDataMap = {
          "name": usernameTextEditingController.text.trim(),
          "email": emailTextEditingController.text.trim(),
          "phone": userPhoneTextEditingController.text.trim(),
          "id": userFirebase.uid,
          "blockStatus": "no",
        };

        await usersRef.set(userDataMap);
        print("User data saved to the database.");

        if (!context.mounted) return;
        Navigator.pop(context); // Close the loading dialog
        Navigator.push(context, MaterialPageRoute(builder: (c) => HomePage()));
      }
    } catch (error) {
      print("Error during registration: $error");
      if (!context.mounted) return;
      Navigator.pop(context); // Close the loading dialog
      cMethods.displaySnackBar("Registration failed: $error", context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: const Color.fromARGB(
              255, 6, 24, 51), // Set the background color to dark blue
          padding: EdgeInsets.all(16.0),
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 250,
                width: 250,
              ),
              const Text(
                "Let’s Get You Signed Up!",
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
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(12), // Rounded corners
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          checkIfNetworkIsAvailable();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors
                              .transparent, // Must be transparent to show gradient
                          shadowColor: Colors
                              .transparent, // Removes shadow to match gradient
                          padding: EdgeInsets.symmetric(
                              horizontal: 80, vertical: 10),
                        ),
                        child: const Text(
                          "Login",
                          style: TextStyle(
                            color: Colors
                                .black, // Ensure text is visible on the gradient
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
