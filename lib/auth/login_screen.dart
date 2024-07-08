import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skardubazar/auth/signup_screen.dart';
import 'package:skardubazar/services/session_manager.dart';
import 'package:skardubazar/utils/flutter_toast.dart';
import 'package:skardubazar/views/home_page.dart';
import 'package:skardubazar/widgets/round_button.dart';

import '../views/New/home.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  void login() {
    setState(() {
      loading = true;
    });

    _auth
        .signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text.toString(),
    )
        .then((value) {
      SessionController().userId = value.user!.uid.toString();
      Utils().toastMessage("Login successful");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
      setState(() {
        loading = false;
      });
    }).onError((error, stackTrace) {
      if (error is FirebaseAuthException) {
        // Handle specific FirebaseAuthException cases
        switch (error.code) {
          case 'user-not-found':
            Utils().toastMessage('User not found. Please register first.');
            break;
          case 'wrong-password':
            Utils().toastMessage('Incorrect password. Please try again.');
            break;
          case 'invalid-credential':
            // Handle invalid credential error (malformed or expired)
            Utils().toastMessage('Email is not registered. Please sign up.');
            break;
          // Add more cases as needed based on the FirebaseAuthException codes
          default:
            Utils().toastMessage('Login failed. Please try again.');
            break;
        }
      } else {
        // Handle other errors
        debugPrint(error.toString());
        Utils().toastMessage('Login failed. Please try again.');
      }

      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Center(child: const Text('Login')),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // const Text(
                        //   'Login ',
                        //   style: TextStyle(
                        //       fontSize: 20, fontWeight: FontWeight.bold),
                        // ),
                        const SizedBox(
                          height: 50,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              hintText: 'Email',
                              prefixIcon: const Icon(Icons.alternate_email)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                          keyboardType: TextInputType.text,
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 20.0, horizontal: 20.0),
                              hintText: 'Password',
                              prefixIcon: const Icon(Icons.lock_open)),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter password';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 50,
                ),
                RoundButton(
                  title: 'Login',
                  loading: loading,
                  onTap: () {
                    if (_formKey.currentState!.validate()) {
                      login();
                    }
                  },
                ),
                const SizedBox(
                  height: 30,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUpScreen()));
                        },
                        child: const Text('Sign up'))
                  ],
                ),
                const SizedBox(
                  height: 30,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
