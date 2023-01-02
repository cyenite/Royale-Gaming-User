import 'package:app_tournament/services/firestore.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/ui/gradient/text_gradient.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:app_tournament/ui/widgets/animate_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

class TournamentResults extends StatefulWidget {
  const TournamentResults({
    Key? key,
    required this.tournaments,
  }) : super(key: key);
  final Tournaments tournaments;

  @override
  State<TournamentResults> createState() => _TournamentResultsState();
}

class _TournamentResultsState extends State<TournamentResults> {
  bool animate = true;
  ConnectionState refreshIndicator = ConnectionState.waiting;
  bool data = true;
  Future retry() async {
    setState(() {
      data = false;
    });
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      data = true;
    });
  }

  Future animateAwait() async {
    setState(() {
      animate = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final DarkModeProvider darkModeProvider = Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueAccent,
        elevation: 1,
        // title:  DesignText(
        //   'Results',
        //   color: Colors.white,
        // ),
        title: const TextGradient(text: 'Results', appbarfontsize: 24),
      ),
      body: RefreshIndicator(
        strokeWidth: 1.5,
        onRefresh: () async {
          await retry();
        },
        child: FutureBuilder<List<Tournaments>>(
            future: FirestoreService().getResults(widget.tournaments.tId),
            builder: (context, snapshot) {
              if (!snapshot.hasData || data == false) {
                return const AnimateShimmer();
              } else if (snapshot.hasData) {
                final List<Tournaments> getResults = snapshot.data!;
                return ListView(
                  physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                  primary: false,
                  children: [
                    Column(
                        children: getResults.map((results) {
                      return GestureDetector(
                        onTap: animateAwait,
                        child: Column(
                          children: [
                            Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                  children: [
                                    DesignText(
                                      'Winner',
                                      fontSize: 22,
                                      color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                    ),
                                    const Divider(),
                                    DataTable(
                                      columns: [
                                        DataColumn(
                                          label: DesignText(
                                            'Players Name',
                                            color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                          ),
                                        ),
                                        DataColumn(
                                          label: DesignText(
                                            'Kills',
                                            color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                          ),
                                        ),
                                        DataColumn(
                                          label: DesignText(
                                            'Rewards',
                                            color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                          ),
                                        )
                                      ],
                                      rows: results.playerResults
                                          .where((e) => e.winner)
                                          .map((playerResults) => DataRow(cells: [
                                                DataCell(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      Expanded(
                                                          child: DesignText.bold1(
                                                        playerResults.playerGameID,
                                                        color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                      )),
                                                      const SizedBox(
                                                        height: 20,
                                                        child: VerticalDivider(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                DataCell(
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                    children: [
                                                      DesignText.bold2(
                                                        playerResults.playerSingleRewards.toString(),
                                                        color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                      ),
                                                      const SizedBox(
                                                        height: 20,
                                                        child: VerticalDivider(),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                DataCell(
                                                  DesignText.bold2(
                                                    'KES ${playerResults.playerTotalCoins}',
                                                    color: darkModeProvider.isDarkTheme ? Colors.greenAccent : null,
                                                  ),
                                                ),
                                              ]))
                                          .toList(),
                                    ),
                                  ],
                                )),
                            const SizedBox(height: 20),
                            Card(
                                clipBehavior: Clip.antiAlias,
                                child: Column(children: [
                                  DesignText(
                                    'All Rewarded Players',
                                    fontSize: 22,
                                    color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                  ),
                                  const Divider()
                                ])),
                            Stack(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: DataTable(
                                        // columnSpacing: 20,
                                        columns: [
                                          DataColumn(
                                            label: DesignText(
                                              'Players Name',
                                              color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                            ),
                                          ),
                                          DataColumn(
                                            label: DesignText(
                                              'Kills',
                                              color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                            ),
                                          ),
                                          DataColumn(
                                            label: DesignText(
                                              'Rewards',
                                              color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                            ),
                                          )
                                        ],
                                        rows: widget.tournaments.playerResults
                                            .where((e) => !e.winner)
                                            .map((playerResults) => DataRow(cells: [
                                                  DataCell(
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child: DesignText.bold1(
                                                            playerResults.playerGameID,
                                                            color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                          child: VerticalDivider(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  DataCell(
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        DesignText.bold2(
                                                          playerResults.playerSingleRewards.toString(),
                                                          color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                          child: VerticalDivider(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  DataCell(
                                                    DesignText.bold2(
                                                      'KES ${playerResults.playerTotalCoins}',
                                                      color: darkModeProvider.isDarkTheme ? Colors.greenAccent : Colors.green,
                                                    ),
                                                  ),
                                                ]))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                                animate
                                    ? Positioned(
                                        child: Center(
                                        child: Lottie.asset(
                                          'assets/success_celebration.json',
                                        ),
                                      ))
                                    : Container()
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList()),
                  ],
                );
              } else {
                return const Text('Not Found');
              }
            }),
      ),
    );
  }
}
