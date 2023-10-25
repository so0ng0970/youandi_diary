import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:youandi_diary/common/provider/go_router.dart';
import 'package:youandi_diary/firebase/firebase_api.dart';
import 'package:youandi_diary/firebase_options.dart';

import 'common/const/data.dart';

final navigatorKey = GlobalKey<NavigatorState>();
final firebaseService = FirebaseService();

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await firebaseService.setupFlutterNotifications();
  firebaseService.showFlutterNotification(message);

  print('Handling a background message ${message.messageId}');
}

late AndroidNotificationChannel channel;

bool isFlutterLocalNotificationsInitialized = false;

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

void main() async {
  KakaoSdk.init(
    nativeAppKey: NATIVE_KEY,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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
