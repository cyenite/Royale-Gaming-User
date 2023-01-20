import 'dart:async';

import 'package:app_tournament/games/tournaments.dart';
import 'package:app_tournament/services/services.dart';
import 'package:app_tournament/shared/shared.dart';
import 'package:app_tournament/ui/widgets/animate_shimmer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewGamesScreen extends StatefulWidget {
  const NewGamesScreen({Key? key}) : super(key: key);
  @override
  State<NewGamesScreen> createState() => _NewGamesScreenState();
}

class _NewGamesScreenState extends State<NewGamesScreen> {
  ConnectionState refreshIndicator = ConnectionState.waiting;
  Future retry() async {
    setState(() {
      refreshIndicator = ConnectionState.waiting;
    });
  }

  late Timer timer;

  startTimer() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        FirestoreService().getNewGmes();
        refreshIndicator = ConnectionState.waiting;
      });
    });
  }

  @override
  void initState() {
    //! startTimer();
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 1.5,
      onRefresh: () async {
        setState(() {
          refreshIndicator = ConnectionState.waiting;
        });
      },
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('new_games')
            .orderBy('date', descending: false)
            .snapshots(),
        builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.connectionState == refreshIndicator) {
            return const AnimateShimmer();
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            var newGames = snapshot.data!.docs;
            return ListView(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              primary: false,
              padding: const EdgeInsets.all(6.0),
              children: newGames
                  .map((data) => NewGamesItem(
                      newGames: NewGames.fromJson(
                          data.data() as Map<String, dynamic>)))
                  .toList(),
            );
          } else {
            return const Text('Not Found');
          }
        },
      ),
    );
  }
}
