import 'package:app_tournament/games/completed.dart';
import 'package:app_tournament/games/new_open_game.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/shimmer/shimmer.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

import '../services/auth.dart';
import '../services/firestore.dart';
import '../shared/error.dart';
import '../shared/progress_bar.dart';
import '../tournaments/join.dart';
import '../ui/widgets/animate_shimmer.dart';
import '../ui/widgets/not_found_animate.dart';
import '../ui/widgets/pro_badge.dart';

class NewGamesItem extends StatelessWidget {
  final NewGames newGames;
  const NewGamesItem({Key? key, required this.newGames}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => TournamentsScreen(newGames: newGames),
          ),
        );
      },
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 2,
        margin: const EdgeInsets.all(4),
        color: darkModeProvider.isDarkTheme ? DesignColor.blackFront : null,
        child: Stack(
          children: [
            CachedNetworkImage(
              height: 200,
              width: double.infinity,
              imageUrl: newGames.img,
              fit: BoxFit.cover,
              placeholder: (context, index) {
                return const ShimmerCard();
              },
              errorWidget: (context, index, err) {
                return const ShimmerCard();
              },
            ),
            DesignButtons.customRadius(
                topLeft: 0,
                bottomLeft: 0,
                onPressed: () {},
                textLabel: newGames.title,
                colorText: Colors.white,
                // color: Colors.pinkAccent,
                icon: const Icon(Ionicons.logo_google_playstore, color: Colors.white)),
            Positioned(
              bottom: 10,
              right: 0,
              child: DesignButtons.customRadius(
                  bottomRight: 0,
                  topRight: 0,
                  onPressed: () {},
                  textLabel: '${newGames.id} ',
                  colorText: Colors.white,
                  // color: DesignColor.blueSmart.withOpacity(0.8),
                  icon: const Icon(Ionicons.play_circle, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

class TournamentsScreen extends StatefulWidget {
  final NewGames newGames;
  const TournamentsScreen({Key? key, required this.newGames}) : super(key: key);

  @override
  State<TournamentsScreen> createState() => _TournamentsScreenState();
}

class _TournamentsScreenState extends State<TournamentsScreen> {
  ConnectionState refreshIndicator = ConnectionState.waiting;

  Future retry() async {
    setState(() {
      refreshIndicator = ConnectionState.waiting;
    });
  }

  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        // backgroundColor: Colors.blueAccent,
        title: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DesignText(
            widget.newGames.title,
            color: darkModeProvider.isDarkTheme ? Colors.white : null,
          ),
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 2,
            // backgroundColor: Colors.blueAccent,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TabBar(
                  automaticIndicatorColorAdjustment: true,
                  tabs: [
                    Tab(
                      child: DesignText.bold1("Upcoming", color: darkModeProvider.isDarkTheme ? Colors.white : null, fontWeight: 800),
                    ),
                    Tab(
                      child: DesignText.bold1("Ongoing", color: darkModeProvider.isDarkTheme ? Colors.white : null, fontWeight: 800),
                    ),
                    Tab(
                      child: DesignText.bold1("Results", color: darkModeProvider.isDarkTheme ? Colors.white : null, fontWeight: 800),
                    ),
                  ],
                )
              ],
            ),
          ),
          body: TabBarView(
            children: [
              NewGamesList(newGames: widget.newGames),
              RefreshIndicator(
                strokeWidth: 1.5,
                onRefresh: () async {
                  await retry();
                },
                child: FutureBuilder<List<Tournaments>>(
                  future: FirestoreService().streamOngoing(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != refreshIndicator) {
                      if (snapshot.data!.isEmpty) {
                        // return Column(
                        //   children: [
                        //     const NotFoundAnimation(
                        //       text: 'No ongoing tournaments',
                        //     ),
                        //     Expanded(child: Container()),
                        //     DesignButtons.icon(
                        //       onPressed: () async {
                        //         await retry();
                        //       },
                        //       textLabel: 'Retry ',
                        //       icon: const Icon(Ionicons.refresh_circle_outline),
                        //     ),
                        //     const SizedBox(height: 30)
                        //   ],
                        // );
                        return SingleChildScrollView(
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              NotFoundAnimation(
                                text: 'No ongoing tournaments',
                                color: darkModeProvider.isDarkTheme ? Colors.white : null,
                              ),
                              const SizedBox(height: 30),
                              DesignButtons.icon(
                                onPressed: () async {
                                  await retry();
                                },
                                textLabel: 'Retry ',
                                colorText: darkModeProvider.isDarkTheme ? Colors.white : null,
                                icon: const Icon(Ionicons.refresh_circle_outline),
                              ),
                              const SizedBox(height: 30)
                            ],
                          ),
                        );
                      }
                    }
                    if (snapshot.connectionState == refreshIndicator) {
                      return const AnimateShimmer();
                    } else if (snapshot.hasError) {
                      return Center(
                        child: ErrorMessage(message: snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      List<Tournaments> streamOngoing = snapshot.data!;
                      return ListView(
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        primary: false,
                        padding: const EdgeInsets.all(6.0),
                        children: streamOngoing.map((streamOngoing) {
                          final List uidContains = streamOngoing.joinedPlayers.map((e) {
                            return e.uid;
                          }).toList();
                          final String timeConvert = DateFormat.yMMMd().add_jm().format(DateTime.parse(streamOngoing.gamePlayTime));
                          final user = AuthService().user!;
                          final bool checkJoined = uidContains.contains(user.uid);

                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) => JoinDetails(
                                    tournamentsView: streamOngoing,
                                  ),
                                ),
                              );
                            },
                            child: Hero(
                                tag: streamOngoing.image,
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  elevation: 2,
                                  margin: const EdgeInsets.all(4),
                                  child: Column(
                                    children: [
                                      Stack(
                                        children: [
                                          CachedNetworkImage(
                                            imageUrl: streamOngoing.image,
                                            fit: BoxFit.cover,
                                            height: 170,
                                            width: double.infinity,
                                            placeholder: (context, index) {
                                              return const ShimmerCard();
                                            },
                                            errorWidget: (context, index, err) {
                                              return const ShimmerCard();
                                            },
                                          ),
                                          const ProBadge(
                                            marginRight: 0,
                                            proBadge: 'On going',
                                          )
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.all(4),
                                              child: DesignText.bold2(
                                                streamOngoing.title,
                                                fontSize: 15,
                                                fontWeight: 700,
                                                color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 4),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: DesignButtons.icon(
                                                  onPressed: () {},
                                                  textLabel: streamOngoing.teamType,
                                                  color: const Color.fromARGB(255, 255, 212, 155),
                                                  icon: const Icon(
                                                    Ionicons.game_controller_outline,
                                                    size: 18,
                                                  )),
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: DesignButtons.icon(
                                                  onPressed: () {},
                                                  textLabel: streamOngoing.mapType,
                                                  colorText: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                  icon: const Icon(
                                                    Ionicons.navigate_circle_outline,
                                                    size: 18,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 4, right: 4),
                                        child: Table(
                                          border: TableBorder.all(
                                            color: Colors.black.withOpacity(0.1),
                                          ),
                                          children: [
                                            TableRow(children: [
                                              Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: DesignText.bold2(
                                                  timeConvert,
                                                  textAlign: TextAlign.center,
                                                  fontSize: 14,
                                                  fontWeight: 700,
                                                  color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: DesignText.bold2(
                                                  'Winner: Ksh.${streamOngoing.tournamentWinRewards}',
                                                  fontSize: 14,
                                                  fontWeight: 700,
                                                  color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(2),
                                                child: DesignText.bold2(
                                                  'Per-kill: Ksh. ${streamOngoing.tournamentSingleRewards}',
                                                  fontSize: 14,
                                                  fontWeight: 700,
                                                  color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                ),
                                              )
                                            ]),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: ProgressBar(maxPlayers: streamOngoing.maxPlayers, joinedPlayers: streamOngoing.joinedPlayersCount),
                                          ),
                                          DesignButtons.customRadius(
                                            // elevated: true,
                                            color: !checkJoined ? DesignColor.blueSmart : Colors.pinkAccent,
                                            onPressed: () async {
                                              if (checkJoined) {
                                                await FlutterWebBrowser.openWebPage(
                                                  url: streamOngoing.link,
                                                  customTabsOptions: CustomTabsOptions(
                                                    colorScheme:
                                                        darkModeProvider.isDarkTheme ? CustomTabsColorScheme.dark : CustomTabsColorScheme.light,
                                                    toolbarColor: darkModeProvider.isDarkTheme ? DesignColor.blackFront : Colors.white,
                                                    shareState: CustomTabsShareState.off,
                                                    instantAppsEnabled: false,
                                                    showTitle: true,
                                                    urlBarHidingEnabled: true,
                                                  ),
                                                  safariVCOptions: const SafariViewControllerOptions(
                                                    barCollapsingEnabled: true,
                                                    dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
                                                    modalPresentationCapturesStatusBarAppearance: true,
                                                  ),
                                                );
                                              } else if (streamOngoing.streamLink != '') {
                                                if (kDebugMode) {
                                                  print('spectating... ${streamOngoing.streamLink}');
                                                }
                                                await FlutterWebBrowser.openWebPage(
                                                  url: streamOngoing.streamLink,
                                                  customTabsOptions: CustomTabsOptions(
                                                    colorScheme:
                                                        darkModeProvider.isDarkTheme ? CustomTabsColorScheme.dark : CustomTabsColorScheme.light,
                                                    toolbarColor: darkModeProvider.isDarkTheme ? DesignColor.blackAppbar : Colors.white,
                                                    shareState: CustomTabsShareState.off,
                                                    instantAppsEnabled: false,
                                                    showTitle: true,
                                                    urlBarHidingEnabled: true,
                                                  ),
                                                  safariVCOptions: const SafariViewControllerOptions(
                                                    barCollapsingEnabled: true,
                                                    dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
                                                    modalPresentationCapturesStatusBarAppearance: true,
                                                  ),
                                                );
                                              }
                                            },
                                            textLabel: checkJoined ? 'Play Now' : 'Spectate',
                                            colorText: Colors.white,
                                            // bottomLeft: 0,
                                            // bottomRight: 0,
                                            // topLeft: 0,
                                            icon: Icon(
                                              checkJoined ? Ionicons.play_circle_sharp : Ionicons.eye_outline,
                                              color: Colors.white,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(width: 4)
                                        ],
                                      )
                                    ],
                                  ),
                                )),
                          );
                        }).toList(),
                      );
                    } else {
                      return const Text('Not Found');
                    }
                  },
                ),
              ),
              NewCompleted(newGames: widget.newGames)
            ],
          ),
        ),
      ),
    );
  }
}
