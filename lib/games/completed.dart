import 'package:app_tournament/games/results.dart';
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
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class NewCompleted extends StatelessWidget {
  final NewGames newGames;
  const NewCompleted({
    Key? key,
    required this.newGames,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider = Provider.of<DarkModeProvider>(context);
    return FutureBuilder<List<Tournaments>>(
      initialData: [Tournaments()],
      future: FirestoreService().getAllTournaments(newGames.id, 'completed'),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const ProgressAwesome();
        }
        if (snapshot.data!.isEmpty) {
          return const NotFoundAnimation(
            text: 'No completed games',
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
                    final String timeConvert = DateFormat.yMMMd().add_jm().format(DateTime.parse(game.gamePlayTime));
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) => JoinDetails(tournamentsView: game),
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
                                    proBadge: 'Completed',
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
                                          'Per-kill: Ksh. ${game.tournamentSingleRewards}',
                                          color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                          fontSize: 14,
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
                                  DesignButtons.icon(
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          fullscreenDialog: true,
                                          builder: (BuildContext context) => TournamentResults(tournaments: game),
                                        ),
                                      );
                                    },
                                    textLabel: 'Results',
                                    colorText: darkModeProvider.isDarkTheme ? Colors.white : null,
                                    icon: const Icon(Ionicons.play_forward_circle_outline),
                                  ),
                                  const SizedBox(width: 4)
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
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
