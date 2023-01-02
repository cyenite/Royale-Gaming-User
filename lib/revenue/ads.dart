// import 'dart:io' show Platform;
// import 'package:flutter/material.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

// AppOpenAd? openAd;
// InterstitialAd? _interstitialAd;
// int _numInterstitialLoadAttempts = 0;
// const int maxFailedLoadAttempts = 3;

// Future loadOpenAd() async {
//   await AppOpenAd.load(
//     adUnitId: Platform.isAndroid
//         ? 'adId'
//         : 'adId',
//     request: const AdRequest(),
//     adLoadCallback: AppOpenAdLoadCallback(
//       onAdLoaded: (AppOpenAd ad) {
//         debugPrint('AppOpenAd Ads is Loaded');
//         openAd = ad;
//         _numInterstitialLoadAttempts = 0;
//         openAd!.setImmersiveMode(true);
//         openAd!.show();
//       },
//       onAdFailedToLoad: (LoadAdError error) {
//         debugPrint('AppOpenAd failed to load: $error.');
//         _numInterstitialLoadAttempts += 1;
//         openAd = null;
//         if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
//           loadOpenAd();
//         }
//       },
//     ),
//     orientation: AppOpenAd.orientationPortrait,
//   );
// } 
// void loadInterstitialAd() {
//   InterstitialAd.load(
//       adUnitId: Platform.isAndroid
//           ? 'adId'
//           : 'adId',
//       request: const AdRequest(),
//       adLoadCallback: InterstitialAdLoadCallback(
//         onAdLoaded: (InterstitialAd ad) {
//           debugPrint('$ad loaded');
//           _interstitialAd = ad;
//           _numInterstitialLoadAttempts = 0;
//           _interstitialAd!.setImmersiveMode(true);
//         },
//         onAdFailedToLoad: (LoadAdError error) {
//           debugPrint('InterstitialAd failed to load: $error.');
//           _numInterstitialLoadAttempts += 1;
//           _interstitialAd = null;
//           if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
//             loadInterstitialAd();
//           }
//         },
//       ));
// }

// void showInterstitialAd() {
//   if (_interstitialAd == null) {
//     debugPrint('Warning: attempt to show interstitial before loaded.');
//     return;
//   }
//   _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
//     onAdShowedFullScreenContent: (InterstitialAd ad) =>
//         debugPrint('ad onAdShowedFullScreenContent.'),
//     onAdDismissedFullScreenContent: (InterstitialAd ad) {
//       debugPrint('$ad onAdDismissedFullScreenContent.');
//       ad.dispose();
//       loadInterstitialAd();
//     },
//     onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
//       debugPrint('$ad onAdFailedToShowFullScreenContent: $error');
//       ad.dispose();
//       loadInterstitialAd();
//     },
//   ); 
//   _interstitialAd!.show();
//   _interstitialAd = null;
// }
