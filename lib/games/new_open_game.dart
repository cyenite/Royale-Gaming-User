// ignore_for_file: use_build_context_synchronously

import 'package:app_tournament/services/auth.dart';
import 'package:app_tournament/services/firestore.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/shared/progress_bar.dart';
import 'package:app_tournament/tournaments/join.dart';
import 'package:app_tournament/ui/shimmer/shimmer.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:app_tournament/ui/widgets/animate_shimmer.dart';
import 'package:app_tournament/ui/widgets/not_found_animate.dart';
import 'package:app_tournament/ui/widgets/pro_badge.dart';
import 'package:app_tournament/ui/widgets/progress_circle.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class NewGamesList extends StatelessWidget {
  final NewGames newGames;
  const NewGamesList({
    Key? key,
    required this.newGames,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider = Provider.of<DarkModeProvider>(context);
    return FutureBuilder<List<Tournaments>>(
      initialData: [Tournaments()],
      future: FirestoreService().getAllTournaments(newGames.id, 'new'),
      builder: (context, snapshot) {
        final user = AuthService().user!;
        final TextEditingController _addMoney = TextEditingController();
        if (snapshot.hasError) {
          return const ProgressAwesome();
        }
        if (snapshot.data!.isEmpty) {
          return const NotFoundAnimation(
            text: 'No future games added yet.',
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const AnimateShimmer();
        } else {
          return ListView(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            primary: false,
            children: [
              Column(
                verticalDirection: VerticalDirection.up,
                children: snapshot.data!.map(
                  (game) {
                    return StreamProvider(
                      create: (context) => FirestoreService().streamAlltournaments(game.tId),
                      catchError: (context, error) => Tournaments(),
                      initialData: Tournaments(),
                      child: Builder(builder: (context) {
                        final tournamentsStream = Provider.of<Tournaments>(context);
                        final List uidContains = tournamentsStream.joinedPlayers.map((e) {
                          return e.uid;
                        }).toList();
                        final String timeConvert = DateFormat.yMMMd().add_jm().format(DateTime.parse(tournamentsStream.gamePlayTime));
                        final UserData userData = Provider.of<UserData>(context);
                        final bool checkJoined = uidContains.contains(user.uid);
                        final bool checkMaxPlayers = tournamentsStream.joinedPlayersCount >= tournamentsStream.maxPlayers && !checkJoined;
                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) => JoinDetails(
                                  tournamentsView: game,
                                ),
                              ),
                            );
                          },
                          child: Hero(
                            tag: game.image,
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
                                        imageUrl: game.image,
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
                                        proBadge: ' New ',
                                      )
                                    ],
                                  ),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(1),
                                          child: DesignText.bold2(
                                            game.title,
                                            color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                            fontSize: 15,
                                            fontWeight: 700,
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
                                              textLabel: game.teamType,
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
                                              textLabel: game.mapType,
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
                                              color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                              textAlign: TextAlign.center,
                                              fontSize: 14,
                                              fontWeight: 700,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: DesignText.bold2(
                                              'Winner: Ksh.${game.tournamentWinRewards}',
                                              fontSize: 14,
                                              color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                              fontWeight: 700,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2),
                                            child: DesignText.bold2(
                                              'Per-kill: Ksh.${game.tournamentSingleRewards}',
                                              fontSize: 14,
                                              color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                              fontWeight: 700,
                                            ),
                                          )
                                        ]),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Flexible(
                                        child: ProgressBar(maxPlayers: game.maxPlayers, joinedPlayers: game.joinedPlayersCount),
                                      ),
                                      DesignButtons.customRadius(
                                          // elevated: true,
                                          color: !checkJoined ? const Color.fromARGB(255, 0, 61, 167) : Colors.pinkAccent,
                                          onPressed: () async {
                                            if (tournamentsStream.status == 'ongoing') {
                                              Fluttertoast.showToast(msg: "Go to Play Now Section", toastLength: Toast.LENGTH_SHORT);
                                            } else {
                                              final FirebaseFirestore _db = FirebaseFirestore.instance;
                                              final DocumentReference ref1 = _db.collection('alltournaments').doc(game.tId);
                                              final DocumentSnapshot snapShots = await ref1.get();
                                              final List functionplayerGameID = snapShots['joinedPlayers'].map((e) {
                                                return e['playerGameID'];
                                              }).toList();
                                              final List functionuidContains = snapShots['joinedPlayers'].map((e) {
                                                return e['uid'];
                                              }).toList();
                                              final bool functioncheckJoined = functionuidContains.contains(user.uid);
                                              final bool functioncheckMaxPlayers =
                                                  snapShots['joinedPlayersCount'] >= game.maxPlayers && !functioncheckJoined;
                                              if (!functionplayerGameID.contains(_addMoney.text)) {
                                                debugPrint(functionplayerGameID.toString());
                                              } else {
                                                debugPrint('$functionplayerGameID no else');
                                              }

                                              !functioncheckJoined
                                                  ? functioncheckMaxPlayers
                                                      ? Fluttertoast.showToast(msg: "Tournament Full", toastLength: Toast.LENGTH_SHORT)
                                                      : showModalBottomSheet(
                                                          shape: const RoundedRectangleBorder(
                                                              borderRadius: BorderRadius.vertical(top: Radius.circular(6))),
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
                                                                        color: darkModeProvider.isDarkTheme ? Colors.white : null,
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
                                                                              _db.collection('alltournaments').doc(game.tId);
                                                                          final DocumentSnapshot snap = await ref.get();
                                                                          final List functionplayerGameIDforAddGame = snap['joinedPlayers'].map((e) {
                                                                            return e['playerGameID'];
                                                                          }).toList();
                                                                          if (!functionplayerGameIDforAddGame.contains(_addMoney.text)) {
                                                                            debugPrint(functionplayerGameID.toList().toString());

                                                                            if (userData.coins - game.fee <= -1) {
                                                                              Fluttertoast.showToast(
                                                                                  msg: "Not enough money in your wallet",
                                                                                  toastLength: Toast.LENGTH_LONG);
                                                                            } else {
                                                                              await FirestoreService()
                                                                                  .updateJoining(game, _addMoney.text)
                                                                                  .whenComplete(() => FirestoreService().updateWallet(
                                                                                      -game.fee,
                                                                                      'Join Match no: ${game.id}',
                                                                                      DateTime.now().toString(),
                                                                                      '',
                                                                                      '',
                                                                                      '',
                                                                                      true))
                                                                                  .whenComplete(() => FirestoreService()
                                                                                      .payReferee((game.fee / 5).round(), userData.referee))
                                                                                  .whenComplete(() => Navigator.pop(context))
                                                                                  .whenComplete(() => Fluttertoast.showToast(
                                                                                      msg: "SUCCESS", toastLength: Toast.LENGTH_LONG));
                                                                            }
                                                                          } else {
                                                                            Fluttertoast.showToast(
                                                                                msg: "${_addMoney.text} Already Added",
                                                                                toastLength: Toast.LENGTH_SHORT);
                                                                            debugPrint('$functionplayerGameID Already Joined');
                                                                          }
                                                                        },
                                                                        textLabel: 'Join ',
                                                                        colorText: darkModeProvider.isDarkTheme ? Colors.white : null,
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
                                                      : 'Join Now'
                                                  : tournamentsStream.status == 'ongoing'
                                                      ? 'Play Now'
                                                      : 'Already Joined',
                                          colorText: Colors.white,
                                          icon: Icon(
                                            !checkJoined ? Ionicons.play_circle_outline : Ionicons.play_circle_sharp,
                                            color: Colors.white,
                                            size: 18,
                                          )),
                                      const SizedBox(width: 4)
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  },
                ).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}
