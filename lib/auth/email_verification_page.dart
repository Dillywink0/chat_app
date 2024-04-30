// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:chat_app/Pages/home/home_page.dart';

import '../auth/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// EmailVerificationScreen widget for email verification
class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  Timer? timer;

  @override
  void initState() {
    // Initializing state
    super.initState();
    // Sending email verification to current user
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    // Starting a timer to check email verification status periodically
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  // Method to check if email is verified
  void checkEmailVerified() async {
    // Reloading current user to get latest email verification status
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      // Showing snackbar if email is successfully verified
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email Successfully Verified")),
      );

      // Canceling timer
      timer?.cancel();

      // Navigate to the next screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  HomePage()),
      );
    }
  }

  @override
  void dispose() {
    // Disposing timer
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Building UI
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'Check your \n Email',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'We have sent you an email on ${auth.currentUser?.email}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Center(child: CircularProgressIndicator()),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'Verifying email....',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ElevatedButton(
                  child: const Text('Resend'),
                  onPressed: () {
                    // Resending email verification
                    try {
                      FirebaseAuth.instance.currentUser
                          ?.sendEmailVerification();
                    } catch (e) {
                      debugPrint('$e');
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
