// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewGames _$NewGamesFromJson(Map<String, dynamic> json) => NewGames(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      img: json['img'] as String? ?? '',
      games: (json['games'] as List<dynamic>?)
              ?.map((e) => Tournaments.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$NewGamesToJson(NewGames instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'img': instance.img,
      'games': instance.games,
    };

Joined _$JoinedFromJson(Map<String, dynamic> json) => Joined(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      img: json['img'] as String? ?? '',
      games: (json['games'] as List<dynamic>?)
              ?.map((e) => Tournaments.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$JoinedToJson(Joined instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'img': instance.img,
      'games': instance.games,
    };

Tournaments _$TournamentsFromJson(Map<String, dynamic> json) => Tournaments(
      id: json['id'] as String? ?? '',
      tId: json['tId'] as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      topic: json['topic'] as String? ?? '',
      image: json['image'] as String? ?? '',
      status: json['status'] as String? ?? '',
      teamType: json['teamType'] as String? ?? '',
      mapType: json['mapType'] as String? ?? '',
      gamePlayTime:
          json['gamePlayTime'] as String? ?? '0000-00-00 00:00:00.000',
      aboutTournament: json['aboutTournament'] as String? ?? '',
      tournamentSingleRewards: json['tournamentSingleRewards'] as int? ?? 0,
      tournamentWinRewards: json['tournamentWinRewards'] as int? ?? 0,
      fee: json['fee'] as int? ?? 0,
      roomId: json['roomId'] as String? ?? '',
      link: json['roomLink'] as String? ?? '',
      streamLink: json['streamLink'] as String? ?? '',
      roomPassword: json['roomPassword'] as String? ?? '',
      maxPlayers: json['maxPlayers'] as int? ?? 0,
      joinedPlayersCount: json['joinedPlayersCount'] as int? ?? 0,
      joinedPlayers: (json['joinedPlayers'] as List<dynamic>?)
              ?.map((e) => JoinedPlayers.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      playerResults: (json['playerResults'] as List<dynamic>?)
              ?.map((e) => JoinedPlayers.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TournamentsToJson(Tournaments instance) =>
    <String, dynamic>{
      'id': instance.id,
      'tId': instance.tId,
      'title': instance.title,
      'description': instance.description,
      'topic': instance.topic,
      'image': instance.image,
      'status': instance.status,
      'teamType': instance.teamType,
      'mapType': instance.mapType,
      'gamePlayTime': instance.gamePlayTime,
      'aboutTournament': instance.aboutTournament,
      'tournamentSingleRewards': instance.tournamentSingleRewards,
      'tournamentWinRewards': instance.tournamentWinRewards,
      'fee': instance.fee,
      'roomId': instance.roomId,
      'roomPassword': instance.roomPassword,
      'maxPlayers': instance.maxPlayers,
      'joinedPlayersCount': instance.joinedPlayersCount,
      'joinedPlayers': instance.joinedPlayers,
      'playerResults': instance.playerResults,
    };

JoinedPlayers _$JoinedPlayersFromJson(Map<String, dynamic> json) =>
    JoinedPlayers(
      uid: json['uid'] as String? ?? '',
      playerGameID: json['playerGameID'] as String? ?? '',
      playerSingleRewards: json['playerSingleRewards'] as int? ?? 0,
      playerTotalCoins: json['playerTotalCoins'] as int? ?? 0,
      winner: json['winner'] as bool? ?? false,
    );

FAQModel _$FAQFromJson(Map<String, dynamic> json) => FAQModel(
      question: json['question'] as String? ?? '',
      answer: json['answer'] as String? ?? '',
      isNew: json['isNew'] as bool? ?? false,
    );

Map<String, dynamic> _$JoinedPlayersToJson(JoinedPlayers instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'playerGameID': instance.playerGameID,
      'playerSingleRewards': instance.playerSingleRewards,
      'playerTotalCoins': instance.playerTotalCoins,
      'winner': instance.winner,
    };

UserData _$UserDataFromJson(Map<String, dynamic> json) => UserData(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      profile: json['profile'] as String? ?? '',
      name: json['name'] as String? ?? '',
      referee: json['referee'] as String? ?? '',
      isDark: json['isDark'] as bool? ?? false,
      totalsignin: json['totalsignin'] as int? ?? 0,
      coins: json['coins'] as int? ?? 0,
      refereeBonus: json['refereeBonus'] as int? ?? 0,
      transaction: (json['transaction'] as List<dynamic>?)
              ?.map((e) => Transaction.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      joinedTournaments:
          json['joinedTournaments'] as List<dynamic>? ?? const [],
    );

Map<String, dynamic> _$UserDataToJson(UserData instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'profile': instance.profile,
      'email': instance.email,
      'coins': instance.coins,
      'isDark': instance.isDark,
      'totalsignin': instance.totalsignin,
      'transaction': instance.transaction,
      'joinedTournaments': instance.joinedTournaments,
      'referee': instance.referee,
      'refereeBonus': instance.refereeBonus,
    };

Transaction _$TransactionFromJson(Map<String, dynamic> json) => Transaction(
      coinsTransaction: json['coinsTransaction'] as int? ?? 0,
      purpose: json['purpose'] as String? ?? '',
      transactionId: json['transactionId'] as String? ?? '',
      date: json['date'] as String? ?? '',
      goodName: json['goodName'] as String? ?? '',
      walletName: json['walletName'] as String? ?? '',
      moneyRecNumber: json['moneyRecNumber'] as String? ?? '',
      pendingStatus: json['pendingStatus'] as bool? ?? false,
    );

Map<String, dynamic> _$TransactionToJson(Transaction instance) =>
    <String, dynamic>{
      'coinsTransaction': instance.coinsTransaction,
      'purpose': instance.purpose,
      'transactionId': instance.transactionId,
      'date': instance.date,
      'goodName': instance.goodName,
      'walletName': instance.walletName,
      'moneyRecNumber': instance.moneyRecNumber,
      'pendingStatus': instance.pendingStatus,
    };
