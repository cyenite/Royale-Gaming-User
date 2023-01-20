import 'package:app_tournament/services/models.dart';
import 'package:app_tournament/ui/theme/text.dart';
import 'package:flutter/material.dart';

class JoinedMembers extends StatelessWidget {
  const JoinedMembers({
    required this.joinedPlayers,
    Key? key,
  }) : super(key: key);
  final Tournaments joinedPlayers;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const DesignText(
          "Joined Members",
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const MembersCard(membersName: "Joined Members", index: '#'),
            Expanded(
              child: ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: joinedPlayers.joinedPlayers.length,
                  itemBuilder: (context, index) {
                    List<JoinedPlayers> data =
                        joinedPlayers.joinedPlayers.map((e) => e).toList();
                    return MembersCard(
                        index: (index + 1).toString(),
                        membersName: data[index].playerGameID);
                  },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class MembersCard extends StatelessWidget {
  const MembersCard({
    Key? key,
    required this.membersName,
    required this.index,
  }) : super(key: key);
  final String membersName;
  final String index;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Colors.blue,
      child: SizedBox(
        height: 50,
        child: Container(
          alignment: Alignment.centerLeft,
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  alignment: Alignment.center,
                  child: DesignText(
                    index,
                    fontWeight: 700,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                flex: 4,
                child: DesignText(
                  membersName,
                  fontWeight: 700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
