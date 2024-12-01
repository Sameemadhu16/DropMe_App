import 'package:flutter/material.dart';
import 'authentication/signup_screen.dart'; // Import the SignUpScreen
import 'authentication/login_screen.dart';

Future<void> main() async
{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Colors.black,
        ),
        home: LoginScreen(),
        // routes: {
        //   '/signup': (context) =>
        //       const SignUpScreen(), // Add SignUpScreen route
        //   '/login': (context) => const LoginScreen(),
        // },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, '/signup'); // Navigate to SignUpScreen
          },
          child: const Text('Go to Sign Up'),
        ),
      ),
    );
  }
}
