import 'package:app_tournament/services/firestore.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/ui/gradient/text_gradient.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:app_tournament/ui/widgets/animate_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ReferralsPage extends StatefulWidget {
  final String username;
  const ReferralsPage({
    Key? key,
    required this.username,
  }) : super(key: key);

  @override
  State<ReferralsPage> createState() => _ReferralsPageState();
}

class _ReferralsPageState extends State<ReferralsPage> {
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
    final DarkModeProvider darkModeProvider =
        Provider.of<DarkModeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueAccent,
        elevation: 1,
        // title:  DesignText(
        //   'Results',
        //   color: Colors.white,
        // ),
        title: const TextGradient(text: 'Referral Bonuses', appbarfontsize: 24),
      ),
      body: RefreshIndicator(
        strokeWidth: 1.5,
        onRefresh: () async {
          await retry();
        },
        child: FutureBuilder<List<UserData>>(
            future: FirestoreService().getReferrals(widget.username),
            builder: (context, snapshot) {
              if (!snapshot.hasData || data == false) {
                return const AnimateShimmer();
              } else if (snapshot.hasData) {
                final List<UserData> getResults = snapshot.data!;
                return ListView(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  primary: false,
                  children: [
                    Column(children: [
                      GestureDetector(
                        onTap: animateAwait,
                        child: Column(
                          children: [
                            Stack(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Card(
                                      clipBehavior: Clip.antiAlias,
                                      child: DataTable(
                                        // columnSpacing: 20,
                                        columns: [
                                          DataColumn(
                                            label: DesignText(
                                              'Username',
                                              color:
                                                  darkModeProvider.isDarkTheme
                                                      ? Colors.white
                                                      : null,
                                            ),
                                          ),
                                          DataColumn(
                                            label: DesignText(
                                              'Rewards',
                                              color:
                                                  darkModeProvider.isDarkTheme
                                                      ? Colors.white
                                                      : null,
                                            ),
                                          )
                                        ],
                                        rows: getResults
                                            .where((e) =>
                                                e.referee == widget.username)
                                            .map((referrals) => DataRow(cells: [
                                                  DataCell(
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                          child:
                                                              DesignText.bold1(
                                                            referrals.name,
                                                            color: darkModeProvider
                                                                    .isDarkTheme
                                                                ? Colors.white
                                                                : null,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                          child:
                                                              VerticalDivider(),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  DataCell(
                                                    DesignText.bold2(
                                                      'KES ${referrals.refereeBonus}',
                                                      color: darkModeProvider
                                                              .isDarkTheme
                                                          ? Colors.greenAccent
                                                          : Colors.green,
                                                    ),
                                                  ),
                                                ]))
                                            .toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
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
