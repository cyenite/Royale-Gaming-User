import 'package:app_tournament/config/app_information.dart';
import 'package:app_tournament/config/hive_open_ad.dart';
import 'package:app_tournament/games/new_games.dart';
import 'package:app_tournament/games/play_ongoing.dart';
import 'package:app_tournament/services/auth.dart';
import 'package:app_tournament/settings/wallet/animated.dart';
import 'package:app_tournament/settings/wallet/wallet.dart';
import 'package:app_tournament/ui/custom/bottom_bar.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/gradient/text_gradient.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class HomePageController extends StatefulWidget {
  const HomePageController({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePageController> {
  int _currentIndex = 0;
  var user = AuthService().user;
  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  void registerNotification() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint("Handling a background message: ${message.notification!.title}");
      String title = message.notification!.title ?? "";
      String msg = message.notification!.body ?? "";
      // showSnackbar(title, msg);
      showSnackbar(title, msg);
    });
    // _firebaseMessaging.subscribeToTopic('Notification');
    await notificationGet();
    // String items = topics.join('/');
    // _firebaseMessaging.subscribeToTopic('pro/333/444/deep');
    // String? token = await _firebaseMessaging.getToken();
    // debugPrint('token $token');
  }

  void showSnackbar(String? title, String? msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 10),
        content: Text(
          '$msg',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void initState() {
    openAdHive();
    // loadInterstitialAd();
    registerNotification();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) => const OngoingGameplay(),
            ),
          );
        },
        backgroundColor: Colors.pinkAccent,
        child: const Icon(
          Ionicons.game_controller,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      // drawer: Drawer(
      //   child: ListView(
      //     children: [
      //       DrawerHeader(
      //         child: Column(
      //           crossAxisAlignment: CrossAxisAlignment.start,
      //           mainAxisAlignment: MainAxisAlignment.end,
      //           children: [
      //             DesignContainer.rounded(
      //               allPadding: 0,
      //               clipBehavior: Clip.antiAliasWithSaveLayer,
      //               child: CachedNetworkImage(
      //                   height: 64,
      //                   width: 64,
      //                   imageUrl: user!.isAnonymous
      //                       ? AppInformation().skipUserProfile
      //                       : user!.photoURL.toString(),
      //                   fit: BoxFit.cover),
      //             ),
      //             DesignText.b1(
      //               user!.isAnonymous
      //                   ? "Welcome to -"
      //                   : user!.displayName.toString(),
      //               fontWeight: 700,
      //             ),
      //             // SingleChildScrollView(
      //             //   scrollDirection: Axis.horizontal,
      //             //   child: DesignText.b2(
      //             //     user!.isAnonymous
      //             //         ? "Assam Exam Prep. - Complete Mock Test"
      //             //         : user!.email.toString(),
      //             //     fontWeight: 600,
      //             //     xMuted: true,
      //             //   ),
      //             // ),
      //             TextButton(
      //               onPressed: () {
      //                 Navigator.of(context).push(
      //                   MaterialPageRoute(
      //                     builder: (BuildContext context) => const AdminPage(),
      //                   ),
      //                 );
      //               },
      //               child: const DesignText('Admin Page'),
      //             )
      //           ],
      //         ),
      //       ),
      //     ],
      //   ),
      // ),
      appBar: AppBar(
        // backgroundColor: darkModeProvider.isLightTheme
        //     ? DesignColor.blackFront
        //     : Colors.white,
        elevation: _currentIndex == 2 ? 0.0 : 0.6,
        // automaticallyImplyLeading: false,
        // leading: Builder(
        //     builder: (context) => IconButton(
        //         onPressed: () {
        //           Scaffold.of(context).openDrawer();
        //         },
        //         icon: const Icon(
        //           FeatherIcons.alignLeft,
        //         ))),
        // actions: [
        //   Row(
        //     children: [
        //       DarkModeToggle(
        //         onToggleCallback: (v) async {
        //           final themeProvider =
        //               Provider.of<ThemeProvider>(context, listen: false);
        //           await themeProvider.toggleThemeData();
        //           setState(() {});
        //         },
        //       ),
        //     ],
        //   )
        // ],
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                DarkModeToggle(
                  onToggleCallback: (e) async {
                    await darkModeProvider.toggleDarkMode();
                    setState(() {});
                  },
                ),
                const SizedBox(width: 4)
              ],
            ),
          ),
        ],
        // iconTheme: const IconThemeData(color: Colors.black),
        title: TextGradient(
          text: _currentIndex == 0
              ? AppInformation().appName
              : _currentIndex == 1
                  ? "Wallet"
                  : "Profile",
          appbarfontsize: 24,
        ),
      ),
      body: getBody(),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildBottomBar() {
    final themeProvider = Provider.of<DarkModeProvider>(context);
    return CustomBottomBar(
      backgroundColor: themeProvider.isDarkTheme ? DesignColor.blackFront : null,
      bottomColor: themeProvider.isDarkTheme ? DesignColor.blackFront : null,
      containerHeight: 60,
      selectedIndex: _currentIndex,
      showElevation: true,
      itemCornerRadius: 8,
      curve: Curves.easeInOutBack,
      onItemSelected: (index) => setState(() => _currentIndex = index),
      items: <BottomBarItem>[
        BottomBarItem(icon: Icon(_currentIndex == 0 ? Ionicons.game_controller : Ionicons.game_controller_outline), title: const Text('Play')),
        BottomBarItem(
          icon: Icon(_currentIndex == 1 ? Ionicons.wallet : Ionicons.wallet_outline),
          title: const Text('Wallet'),
          activeColor: Colors.purpleAccent,
        ),
      ],
    );
  }

  Widget getBody() {
    List<Widget> pages = const [
      NewGamesScreen(),
      Wallet(),
    ];
    return IndexedStack(
      index: _currentIndex,
      children: pages,
    );
  }
}
