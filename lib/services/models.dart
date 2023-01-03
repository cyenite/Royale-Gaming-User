import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class NewGames {
  late final String id;
  final String title;
  final String description;
  final String img;
  final List<Tournaments> games;

  NewGames({this.id = '', this.title = '', this.description = '', this.img = '', this.games = const []});
  factory NewGames.fromJson(Map<String, dynamic> json) => _$NewGamesFromJson(json);
  Map<String, dynamic> toJson() => _$NewGamesToJson(this);
}

@JsonSerializable()
class Joined {
  late final String id;
  final String title;
  final String description;
  final String img;
  final List<Tournaments> games;
  Joined({this.id = '', this.title = '', this.description = '', this.img = '', this.games = const []});
  factory Joined.fromJson(Map<String, dynamic> json) => _$JoinedFromJson(json);
  Map<String, dynamic> toJson() => _$JoinedToJson(this);
}

@JsonSerializable()
class Tournaments {
  String id;
  String tId;
  String title;
  String description;
  String topic;
  String image;
  String status;
  String teamType;
  String mapType;
  String gamePlayTime;
  String aboutTournament;
  int tournamentSingleRewards;
  int tournamentWinRewards;
  int fee;
  String roomId;
  String link;
  String streamLink;
  String roomPassword;
  int maxPlayers;
  int joinedPlayersCount;
  List<JoinedPlayers> joinedPlayers;
  List<JoinedPlayers> playerResults;

  Tournaments({
    this.id = '',
    this.tId = '',
    this.title = '',
    this.description = '',
    this.topic = '',
    this.image = '',
    this.status = '',
    this.teamType = '',
    this.mapType = '',
    this.link = '',
    this.streamLink = '',
    this.gamePlayTime = '0000-00-00 00:00:00.000',
    this.aboutTournament = '',
    this.tournamentSingleRewards = 0,
    this.tournamentWinRewards = 0,
    this.fee = 0,
    this.roomId = '',
    this.roomPassword = '',
    this.maxPlayers = 0,
    this.joinedPlayersCount = 0,
    this.joinedPlayers = const [],
    this.playerResults = const [],
  });
  factory Tournaments.fromJson(Map<String, dynamic> json) => _$TournamentsFromJson(json);
  Map<String, dynamic> toJson() => _$TournamentsToJson(this);
}

@JsonSerializable()
class JoinedPlayers {
  String uid;
  String playerGameID;
  int playerSingleRewards;
  int playerTotalCoins;
  bool winner;
  JoinedPlayers({
    this.uid = '',
    this.playerGameID = '',
    this.playerSingleRewards = 0,
    this.playerTotalCoins = 0,
    this.winner = false,
  });
  factory JoinedPlayers.fromJson(Map<String, dynamic> json) => _$JoinedPlayersFromJson(json);
  Map<String, dynamic> toJson() => _$JoinedPlayersToJson(this);
}

@JsonSerializable()
class UserData {
  String id;
  String name;
  String profile;
  String email;
  int coins;
  int coinsWon;
  bool isDark;
  int totalsignin;
  List<Transaction> transaction;
  List joinedTournaments;

  UserData({
    this.id = '',
    this.email = '',
    this.profile = '',
    this.name = '',
    this.isDark = false,
    this.totalsignin = 0,
    this.coins = 0,
    this.coinsWon = 0,
    this.transaction = const [],
    this.joinedTournaments = const [],
  });
  factory UserData.fromJson(Map<String, dynamic> json) => _$UserDataFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataToJson(this);
}

@JsonSerializable()
class Transaction {
  int coinsTransaction;
  String purpose;
  String transactionId;
  String date;
  String goodName;
  String walletName;
  String moneyRecNumber;
  bool pendingStatus;
  Transaction({
    this.coinsTransaction = 0,
    this.purpose = '',
    this.transactionId = '',
    this.date = '',
    this.goodName = '',
    this.walletName = '',
    this.moneyRecNumber = '',
    this.pendingStatus = false,
  });
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
  Map<String, dynamic> toJson() => _$TransactionToJson(this);
}

@JsonSerializable()
class FAQModel {
  String question;
  String answer;
  bool isNew;
  FAQModel({
    this.question = '',
    this.answer = '',
    this.isNew = false,
  });
  factory FAQModel.fromJson(Map<String, dynamic> json) => _$FAQFromJson(json);
}
