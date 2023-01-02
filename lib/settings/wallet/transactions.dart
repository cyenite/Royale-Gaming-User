import 'package:app_tournament/services/firestore.dart';
import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/ui/custom/custom_color.dart';
import 'package:app_tournament/ui/theme/buttons/buttons.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:app_tournament/ui/theme/theme_provider.dart';
import 'package:app_tournament/ui/widgets/animate_shimmer.dart';
import 'package:app_tournament/ui/widgets/not_found_animate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class Transactions extends StatefulWidget {
  const Transactions({Key? key}) : super(key: key);

  @override
  State<Transactions> createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  @override
  Widget build(BuildContext context) {
    // Tournaments onGoingplays = Provider.of<Tournaments>(context);
    ConnectionState refreshIndicator = ConnectionState.waiting;
    Future retry() async {
      setState(() {
        refreshIndicator = ConnectionState.waiting;
      });
    }

    final DarkModeProvider darkModeProvider = Provider.of<DarkModeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.blueAccent,
        elevation: 1,
        title: DesignText(
          'Transactions',
          color: darkModeProvider.isDarkTheme ? Colors.white : null,
        ),
      ),
      body: RefreshIndicator(
        strokeWidth: 1.5,
        onRefresh: () async {
          await retry();
        },
        child: FutureBuilder<List<UserData>>(
          future: FirestoreService().futureTransactions(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != refreshIndicator) {
              if (snapshot.data!.isEmpty) {
                return SingleChildScrollView(
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const NotFoundAnimation(
                        text: 'No Transactions History',
                      ),
                      const SizedBox(height: 30),
                      DesignButtons.icon(
                        onPressed: () async {
                          await retry();
                        },
                        textLabel: 'Retry ',
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
            } else if (snapshot.hasData) {
              final List<UserData> streamOngoing = snapshot.data!;
              return ListView(
                physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                primary: false,
                padding: const EdgeInsets.all(6.0),
                children: streamOngoing.map((streamOngoing) {
                  return SingleChildScrollView(
                      child: Padding(
                    padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Container(
                            color: DesignColor.blueSmart,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(14),
                                  child: DesignText(
                                    'Coins',
                                    color: Colors.white,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(14),
                                  child: DesignText('Purpose', color: Colors.white),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(14),
                                  child: DesignText('Date', color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            verticalDirection: VerticalDirection.up,
                            children: streamOngoing.transaction.map((userTransactions) {
                              final String dateTime = DateFormat.yMMMd().add_jm().format(DateTime.parse(userTransactions.date));
                              return Container(
                                color: userTransactions.coinsTransaction.isNegative ? Colors.lightGreen : Colors.lightBlue,
                                child: Row(
                                  // crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DesignText(
                                          userTransactions.coinsTransaction.toString(),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          showCupertinoDialog(
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: DesignText(
                                                      userTransactions.purpose,
                                                      color: darkModeProvider.isDarkTheme ? Colors.white : null,
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              DesignText.bold2(userTransactions.purpose.length >= 20 ? 'Click to view' : userTransactions.purpose,
                                                  color: Colors.white),
                                              userTransactions.purpose == 'Withdraw'
                                                  ? DesignText.bold2(userTransactions.pendingStatus ? 'Success' : 'Pending', color: Colors.white)
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: DesignText(dateTime, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    ),
                  ));
                }).toList(),
              );
            } else {
              return const Text('Not Found');
            }
          },
        ),
      ),
    );
  }
}
