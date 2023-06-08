import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Text('${snapshot.hasError}');
            } else {
              return Center(
                child: Column(
                  children: const [
                    Text(
                      '로그인 성공 ',
                    ),
                  ],
                ),
              );
            }
          }),
    );
  }
}
