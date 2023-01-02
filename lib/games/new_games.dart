import 'package:app_tournament/games/tournaments.dart';
import 'package:app_tournament/services/services.dart';
import 'package:app_tournament/shared/shared.dart';
import 'package:app_tournament/ui/widgets/animate_shimmer.dart';
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

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 1.5,
      onRefresh: () async {
        setState(() {
          refreshIndicator = ConnectionState.waiting;
        });
      },
      child: FutureBuilder<List<NewGames>>(
        future: FirestoreService().getNewGmes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == refreshIndicator) {
            return const AnimateShimmer();
          } else if (snapshot.hasError) {
            return Center(
              child: ErrorMessage(message: snapshot.error.toString()),
            );
          } else if (snapshot.hasData) {
            List<NewGames> newGames = snapshot.data!;
            return ListView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              primary: false,
              padding: const EdgeInsets.all(6.0),
              children: newGames.map((newGames) => NewGamesItem(newGames: newGames)).toList(),
            );
          } else {
            return const Text('Not Found');
          }
        },
      ),
    );
  }
}
