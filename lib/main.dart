import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
// Import the SignUpScreen
import 'authentication/login_screen.dart';
import 'authentication/signup_screen.dart'; // Import the SignUpScreen

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await Permission.locationWhenInUse.isDenied.then((valueOfPermission) async {
    if (valueOfPermission) {
      Permission.locationWhenInUse.request();
    }
  });

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
        home: HomeScreen(),
        routes: {
          '/signup': (context) => SignUpScreen(),
          '/login': (context) => LoginScreen() // Define the route
        },
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
        title: const Text('DropMe'),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: const Color.fromARGB(
                255, 6, 24, 51), // Set the background color to dark blue
            padding: EdgeInsets.all(16.0),
            height:
                MediaQuery.of(context).size.height, // Ensure full screen height
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Welcome to DropMe!',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(
                        255, 255, 255, 255), // Change text color to white
                    shadows: [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.grey,
                        offset: Offset(2.0, 2.0),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Image.asset(
                  'assets/images/logo.png', // Add your logo image here
                  height: 250,
                ),
                const SizedBox(height: 40),
                MouseRegion(
                  onEnter: (_) {},
                  onExit: (_) {},
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/signup'); // Navigate to SignUpScreen
                    },
                    icon: const Icon(
                      Icons.person_add,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                    label: const Text(
                      'DropMe! Lets Go!',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontWeight:
                            FontWeight.bold, // Change label color to black
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle: const TextStyle(fontSize: 18),
                      shadowColor: Colors.black,
                      enabledMouseCursor: MouseCursor.defer,
                      elevation: 10,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                MouseRegion(
                  onEnter: (_) {},
                  onExit: (_) {},
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/login'); // Navigate to LoginScreen
                    },
                    icon: const Icon(
                      Icons.login,
                      color: Colors.black,
                    ),
                    label: const Text(
                      'Go to Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ), // Change label color to black
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 15),
                      textStyle:
                          const TextStyle(fontSize: 18, color: Colors.black),
                      shadowColor: Colors.black,
                      elevation: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
