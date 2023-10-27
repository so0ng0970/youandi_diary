import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:youandi_diary/common/provider/go_router.dart';
import 'package:youandi_diary/firebase/firebase_api.dart';
import 'package:youandi_diary/user/component/user_profile.dart';
import 'common/const/data.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  KakaoSdk.init(
    nativeAppKey: NATIVE_KEY,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseApi().initNotification();

  FirebaseMessaging.onMessageOpenedApp.listen(
    (RemoteMessage message) {
      print('onMessageOpenedApp dtriggered!');
      navigatorKey.currentState?.pushNamed(
        UserProfile.routeName,
        arguments: message,
      );
    },
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'SongMyung',
      ),
      routerConfig: router,
    );
  }
}
