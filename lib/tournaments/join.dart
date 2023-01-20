// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'package:app_tournament/config/app_information.dart';
import 'package:app_tournament/games/results.dart';
import 'package:app_tournament/services/auth.dart';
import 'package:app_tournament/services/firestore.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/tournaments/joinedmembers.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/shimmer/shimmer.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:app_tournament/ui/widgets/progress_circle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:clipboard/clipboard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class JoinDetails extends StatelessWidget {
  const JoinDetails({
    Key? key,
    required this.tournamentsView,
  }) : super(key: key);
  final Tournaments tournamentsView;
  @override
  Widget build(BuildContext context) {
    final darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: DesignText(
          tournamentsView.title,
          color: darkModeProvider.isDarkTheme ? Colors.white : null,
        ),
        // backgroundColor: Colors.blueAccent,
      ),
      body: StreamProvider(
          create: (context) => FirestoreService().streamAlltournaments(tournamentsView.tId),
          catchError: (context, error) => Tournaments(),
          initialData: Tournaments(),
          child: StartPage(
            tournamentsView: tournamentsView,
            darkModeProvider: darkModeProvider,
          )),
    );
  }
}

class StartPage extends StatefulWidget {
  final Tournaments tournamentsView;
  final DarkModeProvider darkModeProvider;
  const StartPage({
    Key? key,
    required this.tournamentsView,
    required this.darkModeProvider,
  }) : super(key: key);

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  bool animateProgress = false;
  Future anianimateProgress() async {
    setState(() {
      animateProgress = true;
    });
    await Future.delayed(const Duration(seconds: 1));
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (BuildContext context) => TournamentResults(tournaments: widget.tournamentsView),
      ),
    );
    setState(() {
      animateProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final tournamentsStream = Provider.of<Tournaments>(context);
    final user = AuthService().user!;
    final List uidContains = tournamentsStream.joinedPlayers.map((e) {
      return e.uid;
    }).toList();
    final String timeConvert = DateFormat.yMMMd().add_jm().format(DateTime.parse(tournamentsStream.gamePlayTime));
    var userData = Provider.of<UserData>(context);
    final bool checkJoined = uidContains.contains(user.uid);
    final bool checkMaxPlayers = tournamentsStream.joinedPlayersCount >= tournamentsStream.maxPlayers && !checkJoined;
    final TextEditingController _addMoney = TextEditingController();
    return Hero(
      tag: widget.tournamentsView.image,
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl: widget.tournamentsView.image,
                      fit: BoxFit.fill,
                      placeholder: (context, index) {
                        return const ShimmerCard();
                      },
                      errorWidget: (context, index, err) {
                        return const ShimmerCard();
                      },
                    ),
                  ),
                  if (tournamentsStream.status == 'ongoing' && checkJoined)
                    Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          const SizedBox(height: 6),
                          DesignText(
                            'Room Code and Password',
                            fontSize: 16,
                            color: widget.darkModeProvider.isDarkTheme ? Colors.white : DesignColor.blueSmart,
                          ),
                          Container(
                            alignment: Alignment.topLeft,
                            padding: const EdgeInsets.only(left: 10, right: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: DesignButtons.icon(
                                      onPressed: () {
                                        FlutterClipboard.copy(tournamentsStream.roomId)
                                            .then((value) => Fluttertoast.showToast(msg: "Copy Successful", toastLength: Toast.LENGTH_LONG));
                                      },
                                      textLabel: tournamentsStream.roomId,
                                      colorText: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                                      icon: const Icon(
                                        Ionicons.id_card_outline,
                                        size: 18,
                                      )),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: DesignButtons.icon(
                                      onPressed: () {
                                        FlutterClipboard.copy(tournamentsStream.roomPassword)
                                            .then((value) => Fluttertoast.showToast(msg: "Copy Successful", toastLength: Toast.LENGTH_LONG));
                                      },
                                      textLabel: tournamentsStream.roomPassword,
                                      colorText: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                                      icon: const Icon(
                                        Ionicons.lock_open_outline,
                                        size: 18,
                                      )),
                                ),
                              ],
                            ),
                          ),
                          DesignText.bold2(
                            'Click to copy',
                            fontWeight: 700,
                            color: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                          ),
                          // DesignButtons.icon(
                          //     elevated: true,
                          //     pdleft: 4,
                          //     pdbottom: 0,
                          //     pdright: 4,
                          //     pdtop: 0,
                          //     // color: DesignColor.blueSmart,
                          //     onPressed: () async {
                          //     },
                          //     textLabel: 'Push to Notification',
                          //     icon: const Icon(
                          //       Ionicons.notifications_circle_outline,
                          //       size: 18,
                          //     )),
                          const SizedBox(height: 6),
                          // const Divider(),
                        ],
                      ),
                    ),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Container(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      alignment: Alignment.topLeft,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: DesignButtons.icon(
                                    onPressed: () {},
                                    textLabel: widget.tournamentsView.teamType,
                                    colorText: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                                    icon: const Icon(
                                      Ionicons.game_controller_outline,
                                      size: 18,
                                    )),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: DesignButtons.icon(
                                  onPressed: () {},
                                  textLabel: widget.tournamentsView.mapType,
                                  colorText: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                                  icon: const Icon(
                                    Ionicons.map_outline,
                                    size: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: DesignButtons.icon(
                                  onPressed: () {},
                                  textLabel: widget.tournamentsView.fee == 0 ? 'Free' : 'Paid',
                                  colorText: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                                  icon: const Icon(
                                    Ionicons.wallet_outline,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          DesignButtons.icon(
                            onPressed: () {},
                            textLabel: timeConvert,
                            colorText: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                            icon: const Icon(
                              Ionicons.time_outline,
                              size: 18,
                            ),
                          ),
                          DesignButtons.icon(
                            onPressed: () {},
                            textLabel: 'Joining fee: Ksh.${widget.tournamentsView.fee}',
                            colorText: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                            icon: const Icon(
                              Ionicons.card_outline,
                              size: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Card(
                    clipBehavior: Clip.antiAlias,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          const DesignText(
                            'Instructions',
                            fontSize: 16,
                            color: DesignColor.blueSmart,
                          ),
                          DesignText.bold2(
                            AppInformation.instructionText,
                            color: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                            fontSize: 14,
                            fontWeight: 500,
                            textAlign: TextAlign.justify,
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          const DesignText(
                            'About The Tournament',
                            fontSize: 16,
                            color: DesignColor.blueSmart,
                          ),
                          DesignText.bold2(
                            widget.tournamentsView.aboutTournament,
                            color: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                            fontSize: 14,
                            fontWeight: 500,
                            textAlign: TextAlign.justify,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: DesignButtons.customRadius(
                    elevated: true,
                    color: const Color.fromARGB(255, 6, 97, 255),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: ((context) => JoinedMembers(
                                  joinedPlayers: widget.tournamentsView,
                                )),
                            fullscreenDialog: true,
                          ));
                    },
                    textLabel: 'Members',
                    bottomRight: 0,
                    bottomLeft: 0,
                    topRight: 0,
                    icon: const Icon(
                      Ionicons.people_circle_outline,
                      color: Colors.white,
                      size: 18,
                    )),
              ),
              Expanded(
                child: animateProgress
                    ? TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.fromLTRB(0, 14.5, 0, 14.5),
                          elevation: 1,
                          backgroundColor: DesignColor.blueSmart,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(0),
                              bottomRight: Radius.circular(0),
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(4),
                            ),
                          ),
                        ),
                        onPressed: () {},
                        child: const ProgressAwesome(color: Colors.white),
                      )
                    : DesignButtons.customRadius(
                        elevated: true,
                        color: !checkJoined || tournamentsStream.status == 'completed' ? DesignColor.blueSmart : Colors.pinkAccent,
                        onPressed: () async {
                          if (tournamentsStream.status == 'ongoing') {
                            if (checkJoined) {
                              await FlutterWebBrowser.openWebPage(
                                url: tournamentsStream.link,
                                customTabsOptions: CustomTabsOptions(
                                  colorScheme: widget.darkModeProvider.isDarkTheme ? CustomTabsColorScheme.dark : CustomTabsColorScheme.light,
                                  toolbarColor: widget.darkModeProvider.isDarkTheme ? DesignColor.blackFront : Colors.white,
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
                            } else if (tournamentsStream.streamLink != '') {
                              if (kDebugMode) {
                                print('spectating... ${tournamentsStream.streamLink}');
                              }
                              await FlutterWebBrowser.openWebPage(
                                url: tournamentsStream.streamLink,
                                customTabsOptions: CustomTabsOptions(
                                  colorScheme: widget.darkModeProvider.isDarkTheme ? CustomTabsColorScheme.dark : CustomTabsColorScheme.light,
                                  toolbarColor: widget.darkModeProvider.isDarkTheme ? DesignColor.blackAppbar : Colors.white,
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
                          } else {
                            final FirebaseFirestore _db = FirebaseFirestore.instance;
                            final DocumentReference ref1 = _db.collection('alltournaments').doc(widget.tournamentsView.tId);
                            final DocumentSnapshot snapShots = await ref1.get();
                            final List functionplayerGameID = snapShots['joinedPlayers'].map((e) {
                              return e['playerGameID'];
                            }).toList();
                            final List functionuidContains = snapShots['joinedPlayers'].map((e) {
                              return e['uid'];
                            }).toList();
                            final bool functioncheckJoined = functionuidContains.contains(user.uid);
                            final bool functioncheckMaxPlayers =
                                snapShots['joinedPlayersCount'] >= widget.tournamentsView.maxPlayers && !functioncheckJoined;
                            if (!functionplayerGameID.contains(_addMoney.text)) {
                              debugPrint(functionplayerGameID.toString());
                            } else {
                              debugPrint('$functionplayerGameID no else');
                            }
                            tournamentsStream.status == 'completed'
                                ? anianimateProgress()
                                : !functioncheckJoined
                                    ? functioncheckMaxPlayers
                                        ? Fluttertoast.showToast(msg: "Tournament Full", toastLength: Toast.LENGTH_SHORT)
                                        : showModalBottomSheet(
                                            shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(6))),
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Padding(
                                                padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                                child: SizedBox(
                                                  height: 160,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      children: [
                                                        DesignText.bold2(
                                                          'Add Your GamePlay Username',
                                                          fontWeight: 700,
                                                          fontSize: 14,
                                                          color: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                                                        ),
                                                        const SizedBox(height: 6),
                                                        TextField(
                                                          textCapitalization: TextCapitalization.sentences,
                                                          controller: _addMoney,
                                                          keyboardType: TextInputType.text,
                                                          decoration: const InputDecoration(
                                                            labelText: "Your game username",
                                                            filled: true,
                                                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                                                            contentPadding: EdgeInsets.all(16),
                                                            prefixIcon: Icon(
                                                              Ionicons.pricetags_outline,
                                                              color: Colors.black,
                                                              size: 18,
                                                            ),
                                                            focusedBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                                            ),
                                                            enabledBorder: OutlineInputBorder(
                                                              borderSide: BorderSide(color: Colors.blue, width: 1.0),
                                                            ),
                                                          ),
                                                        ),
                                                        DesignButtons.icon(
                                                          onPressed: () async {
                                                            final DocumentReference ref =
                                                                _db.collection('alltournaments').doc(widget.tournamentsView.tId);
                                                            final DocumentSnapshot snap = await ref.get();
                                                            final List functionplayerGameIDforAddGame = snap['joinedPlayers'].map((e) {
                                                              return e['playerGameID'];
                                                            }).toList();
                                                            if (!functionplayerGameIDforAddGame.contains(_addMoney.text)) {
                                                              debugPrint(functionplayerGameID.toList().toString());

                                                              if (userData.coins - widget.tournamentsView.fee <= -1) {
                                                                Fluttertoast.showToast(msg: "Money Need to Add", toastLength: Toast.LENGTH_SHORT);
                                                              } else {
                                                                await FirestoreService()
                                                                    .updateJoining(widget.tournamentsView, _addMoney.text)
                                                                    .whenComplete(() => FirestoreService().updateWallet(
                                                                        -widget.tournamentsView.fee,
                                                                        'Join Match no: ${widget.tournamentsView.id}',
                                                                        DateTime.now().toString(),
                                                                        '',
                                                                        '',
                                                                        '',
                                                                        true))
                                                                    .whenComplete(() => Navigator.pop(context))
                                                                    .whenComplete(
                                                                        () => Fluttertoast.showToast(msg: "SUCCESS", toastLength: Toast.LENGTH_LONG));
                                                              }
                                                            } else {
                                                              Fluttertoast.showToast(
                                                                  msg: "${_addMoney.text} Already Added", toastLength: Toast.LENGTH_SHORT);
                                                              debugPrint('$functionplayerGameID Already Joined');
                                                            }
                                                          },
                                                          textLabel: 'Join ',
                                                          colorText: widget.darkModeProvider.isDarkTheme ? Colors.white : null,
                                                          icon: const Icon(Ionicons.add_circle_outline),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            })
                                    : Fluttertoast.showToast(msg: "Already Added", toastLength: Toast.LENGTH_SHORT);
                          }
                        },
                        textLabel: tournamentsStream.status == 'completed'
                            ? 'Results'
                            : !checkJoined
                                ? checkMaxPlayers
                                    ? 'Tournament Full'
                                    : tournamentsStream.status == 'ongoing'
                                        ? checkJoined
                                            ? 'Play Now'
                                            : 'Spectate'
                                        : 'Join Now'
                                : tournamentsStream.status == 'ongoing'
                                    ? 'Play Now'
                                    : 'Already Joined',
                        bottomLeft: 0,
                        bottomRight: 0,
                        topLeft: 0,
                        icon: Icon(
                          !checkJoined ? Ionicons.play_circle_outline : Ionicons.play_circle_sharp,
                          color: Colors.white,
                          size: 18,
                        )),
              ),
              // const SizedBox(height: 4),
            ],
          ),
        ],
      ),
    );
  }
}
