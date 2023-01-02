import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

Future openAdHive() async {
  final settingsOpenAd = await Hive.openBox('multibox');
  List<bool> openAdHiveForTime = [true, false];
  try {
    if (settingsOpenAd.get('openAdID') == true) {
      final settingsInterstitial = await Hive.openBox('multiInterstitialAdbox');
      if (openAdHiveForTime
          .contains(settingsInterstitial.get('interstitialAdID'))) {
        // loadOpenAd();
        debugPrint('loadOpenAd & contains');
      } else {
        debugPrint('loadOpenAd & not_contains');
      }
    } else {
      debugPrint('loadopenAdIDFalse');
    }
  } catch (e) {
    debugPrint('openAdHive Error $e');
  }
}

// For Notification toggle true/false
Future notificationActive(bool notification) async {
  final settingsOpenAd = await Hive.openBox('notificationBox');
  settingsOpenAd.put('notification', notification);
}

bool notification = true;
Future notificationHive() async {
  final settingsNotification = await Hive.openBox('notificationBox');
  bool notificationActive = settingsNotification.get('notification') ?? true;
  debugPrint('$notificationActive  bool notification = true');
  notification = notificationActive;
}

Future notificationGet() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List notificationTopics = [
    _firebaseMessaging.subscribeToTopic('Notification'),
    // _firebaseMessaging.subscribeToTopic('Test')
  ];
  final settingsNotification = await Hive.openBox('notificationBox');
  try {
    if (settingsNotification.get('notification') ?? true == true) {
      notificationTopics;
      debugPrint('topic subscribeToTopic');
    } else {
      _firebaseMessaging.unsubscribeFromTopic('Notification');
      // _firebaseMessaging.unsubscribeFromTopic('Test');
      debugPrint('topic unsubscribeFromTopic');
    }
  } catch (e) {
    debugPrint('notificationGet Error $e');
  }
}

Future notificationToggle() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  List notificationTopics = [
    _firebaseMessaging.subscribeToTopic('Notification'),
    // _firebaseMessaging.subscribeToTopic('Test')
  ];
  final settingsNotification = await Hive.openBox('notificationBox');
  try {
    if (settingsNotification.get('notification') ?? true == false) {
      notificationTopics;
      debugPrint('topic subscribeToTopic');
    } else {
      _firebaseMessaging.unsubscribeFromTopic('Notification');
      // _firebaseMessaging.unsubscribeFromTopic('Test');
      debugPrint('topic unsubscribeFromTopic');
    }
  } catch (e) {
    debugPrint('notificationGet Error $e');
  }
}

// Ads
Future putopenAdHiveTrue() async {
  final settingsOpenAd = await Hive.openBox('multibox');
  settingsOpenAd.put('openAdID', true);
}

Future putopenAdHiveFalse() async {
  final settingsOpenAd = await Hive.openBox('multibox');
  settingsOpenAd.put('openAdID', false);
}

Future openInterstitialHive() async {
  final settingsInterstitial = await Hive.openBox('multiInterstitialAdbox');
  try {
    if (settingsInterstitial.get('interstitialAdID') == true) {
      // showInterstitialAd();
      debugPrint('loadInterstitialAd');
    } else {
      debugPrint('loadInterstitialAdFalse');
    }
  } catch (e) {
    debugPrint('openInterstitialHive Error $e');
  }
}

Future putInterstitialAdHiveTrueFalse() async {
  final settingsInterstitial = await Hive.openBox('multiInterstitialAdbox');
  if (settingsInterstitial.get('interstitialAdID') == true) {
    settingsInterstitial.put('interstitialAdID', false);
  } else {
    settingsInterstitial.put('interstitialAdID', true);
  }
}
