import 'package:app_tournament/app.dart';
import 'package:app_tournament/config/hive_open_ad.dart';
import 'package:app_tournament/config/notification/notification.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp();

  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();

  Hive.init(appDocumentDirectory.path);

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  await _firebaseMessaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  await notificationHive();

  FirebaseMessaging.onMessage.listen(myBackgroundMessageHandler);
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);

  final settings = await Hive.openBox('settings');
  bool isLightTheme = settings.get('isLightTheme') ?? false;

  runApp(ChangeNotifierProvider(
      create: (_) => DarkModeProvider(isDarkTheme: isLightTheme),
      child: const App()));
}
