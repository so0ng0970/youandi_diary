import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:youandi_diary/common/component/main_drawer.dart';

class DefaultLayout extends StatelessWidget {
  final Widget child;

  const DefaultLayout({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbar(),
      drawer: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (!snapshot.hasData) {
            return const Text('Not authenticated');
          } else {
            final user = snapshot.data!;
            return MainDrawer(
              profileImg: user.photoURL ?? '',
              nickName: user.displayName ?? '',
              email: user.email ?? '',
            );
          }
        },
      ),
      body: child,
    );
  }

  AppBar? appbar() {
    return AppBar();
  }
}
