import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:skardubazar/auth/login_screen.dart';
import 'package:skardubazar/services/session_manager.dart';
import 'package:skardubazar/utils/flutter_toast.dart';
import 'package:skardubazar/views/New/home.dart';
import 'package:skardubazar/views/home_page.dart';
import 'package:skardubazar/widgets/round_button.dart';

import '../models/userProfile.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final fireStore = FirebaseFirestore.instance.collection('Users');
  String id = DateTime.now().millisecondsSinceEpoch.toString();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
  }

  Future<void> _signUp() async {
    setState(() {
      loading = true;
    });

    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String phone = phoneController.text.trim();

    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      String userId = userCredential.user?.uid ?? '';
      UserProfile userProfile = UserProfile(
        Name: nameController.text,
        email: email,
        phoneNumber: phone,
        image: '',
        userId: userId,
        id: id,
      );

      SessionController().userId = userId;

      await fireStore.doc(userId).set({
        'Name': userProfile.Name,
        'email': userProfile.email,
        'userId': userId,
        'phoneNumber': userProfile.phoneNumber,
        'image': userProfile.image,
        'id': id
      });

      setState(() {
        loading = false;
      });
      Utils().toastMessage("Register successful");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } catch (error) {
      if (error is FirebaseAuthException) {
        if (error.code == 'email-already-in-use') {
          Utils().toastMessage('This email is already in use.');
        } else {
          Utils().toastMessage(error.message ?? 'Sign up failed.');
        }
      } else {
        Utils().toastMessage('Sign up failed. Please try again.');
      }

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text('Sign up')),
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
                      //   'Signup ',
                      //   style: TextStyle(
                      //       fontSize: 20, fontWeight: FontWeight.bold),
                      // ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextFormField(
                        // keyboardType: TextInputType.emailAddress,
                        controller: nameController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            hintText: 'Name',
                            prefixIcon: const Icon(Icons.person)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 15,
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
                        keyboardType: TextInputType.phone,
                        controller: phoneController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 20.0),
                            hintText: 'Phone Number',
                            prefixIcon: const Icon(Icons.phone)),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter Phone number';
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
                title: 'Sign up',
                loading: loading,
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    _signUp();
                  }
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()));
                      },
                      child: const Text('Login'))
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
