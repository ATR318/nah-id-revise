import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dashboard_scr.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  
  @override
  Widget build(BuildContext context) {
    final AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Revision Tracker"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              final user = await authService.signInWithGoogle();
      
              if (user != null) {

                await FirebaseFirestore.instance
                    .collection('Users')
                    .doc(user.uid)
                    .set({
                  'uid': user.uid,
                  'name': user.displayName,
                  'email': user.email,
                });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              }
            } catch (e, stackTrace) {
              print("ERROR: $e");
              print(stackTrace);
            }
          },
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}