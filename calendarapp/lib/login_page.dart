import 'package:calendarapp/calendar.dart';
import 'package:calendarapp/components/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'components/my_textfield.dart';
import 'components/my_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //Pop
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      // Wrong Email
      if (e.code == 'user-not-found') {
        // Show Error
        wrongEmailMessage();
      }

      //Wrong Password
      else if (e.code == 'wrong-password') {
        //show error
        wrongPasswordMessage();
      }
    }
  }

  //Wrong Email message popup
  void wrongEmailMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Email'),
        );
      },
    );
  }

// Wrong Password message popup
  void wrongPasswordMessage() {
    showDialog(
      context: context,
      builder: (context) {
        return const AlertDialog(
          title: Text('Incorrect Password'),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/IMG_9742.JPG'), // Background image path
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor:
            Colors.transparent, // Make scaffold background transparent
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Login to the App",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w800)),
                  const SizedBox(
                    height: 28,
                  ),
                  const Text("Use your fingerprint to log into the app",
                      style: TextStyle(
                        color: Colors.white,
                      )),
                  const SizedBox(
                    height: 28,
                  ),
                  const Divider(
                    color: Colors.white60,
                  ),
                  const SizedBox(
                    height: 28,
                  ),
                  ElevatedButton.icon(
                    onPressed: () async {
                      bool auth = await Authentication.authentication();
                      print("can authenticate $auth");
                      if (auth) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => const Calendar()),
                          ),
                        );
                      }
                    },
                    icon: const Icon(Icons.fingerprint),
                    label: const Text("Authenticate"),
                  ),
                  const SizedBox(height: 50),
                  // username
                  MyTextField(
                    controller: emailController,
                    hintText: 'Username',
                    obscureText: false,
                  ),
                  // const SizedBox(height: 10),
                  // password
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    obscureText: true,
                  ),
                  // sign in button
                  MyButton(
                    onTap: signUserIn,
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
