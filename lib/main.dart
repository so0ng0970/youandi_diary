import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:youandi_diary/firebase_options.dart';
import 'package:youandi_diary/common/screen/splash_screen.dart';

import 'common/const/data.dart';

void main() async {
  KakaoSdk.init(
    nativeAppKey: NATIVE_KEY,
  );
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: SplashScreen());
  }
}
