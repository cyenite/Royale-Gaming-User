import 'package:app_tournament/config/app_information.dart';
import 'package:app_tournament/config/hive_open_ad.dart';
import 'package:app_tournament/services/auth.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/container.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:ionicons/ionicons.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loadingAnimation = false;
  Future loadingAnimation() async {
    setState(() {
      _loadingAnimation = true;
    });
    await Future.delayed(const Duration(seconds: 3));
    setState(() {
      _loadingAnimation = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserData userData = Provider.of<UserData>(context);
    final user = AuthService().user;
    return SingleChildScrollView(
      child: Column(
        children: [
          DesignContainer(
            color: userData.isDark ? DesignColor.blackFront : const Color(0xffffffff),
            margin: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DesignContainer.rounded(
                      allPadding: 0,
                      margin: const EdgeInsets.only(right: 8),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedNetworkImage(
                          height: 64, imageUrl: user!.isAnonymous ? AppInformation().userProfile : user.photoURL.toString(), fit: BoxFit.cover),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DesignText.bold1(
                          user.isAnonymous ? "Welcome to -" : user.displayName.toString(),
                          fontWeight: 700,
                        ),
                        const SizedBox(height: 4),
                        DesignText.caption(
                          user.isAnonymous ? AppInformation().appMainTitle : user.email.toString(),
                          xMuted: true,
                          fontWeight: 600,
                        ),
                        const SizedBox(height: 4),
                        DesignText.caption(
                          'Your Balance:  ' 'Ksh. ${userData.coins}',
                          color: Colors.red,
                          fontWeight: 700,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          DesignContainer(
            color: userData.isDark ? DesignColor.blackFront : const Color(0xffffffff),
            margin: const EdgeInsets.fromLTRB(10, 4, 10, 0),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const DesignText.bold1(
                  "Options",
                  fontWeight: 800,
                ),
                SwitchListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  inactiveTrackColor: Colors.blueAccent.withAlpha(100),
                  activeTrackColor: Colors.blueAccent.withAlpha(150),
                  activeColor: Colors.blue,
                  title: Row(
                    children: const [
                      Icon(Ionicons.notifications_outline, size: 18),
                      SizedBox(width: 4),
                      DesignText.bold2(
                        "Notifications",
                        letterSpacing: 0,
                      ),
                    ],
                  ),
                  onChanged: (value) async {
                    await notificationActive(value);
                    setState(() {
                      notification = value;
                      debugPrint('topic hive toggle value-> $value');
                    });
                    // await Future.delayed(const Duration(seconds: 1));
                    notificationToggle();
                    loadingAnimation();
                  },
                  value: notification,
                ),
                ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.all(0),
                  visualDensity: VisualDensity.compact,
                  title: Row(
                    children: const [
                      Icon(Ionicons.refresh_outline, size: 18),
                      SizedBox(width: 4),
                      DesignText.bold2(
                        "FAQ",
                        letterSpacing: 0,
                      ),
                    ],
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      DesignButtons.icon(
                        icon: const Icon(Ionicons.log_out_outline),
                        textLabel: 'Logout',
                        onPressed: () async {
                          await AuthService().signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                      ),
                      DesignButtons.icon(
                        icon: const Icon(FontAwesomeIcons.eraser),
                        textLabel: 'Delete Your Data',
                        onPressed: () async {
                          var collection = FirebaseFirestore.instance.collection('reports');
                          await collection.doc(user.uid).delete();
                          await AuthService().signOut();
                          Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          if (_loadingAnimation)
            Lottie.asset(
              'assets/notification_bell.json',
              fit: BoxFit.fill,
            )
          else
            Container(),
          const SizedBox(height: 30)
        ],
      ),
    );
  }
}
