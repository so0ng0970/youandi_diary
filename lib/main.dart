import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:youandi_diary/common/provider/go_router.dart';
import 'package:youandi_diary/firebase_options.dart';

import 'common/const/data.dart';

void main() async {
  KakaoSdk.init(
    nativeAppKey: NATIVE_KEY,
  );
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
      final router = ref.watch(routerProvider);
    return  MaterialApp.router(
      routerConfig: router,
    );
  }
}
