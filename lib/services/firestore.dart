import 'dart:async';

import 'package:app_tournament/config/app_information.dart';
import 'package:app_tournament/services/auth.dart';
import 'package:app_tournament/services/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  Future<void> newUsersReport() async {
    var user = AuthService().user!;
    var ref = _db.collection('usersdata').doc(user.uid);
    DocumentSnapshot snap = await ref.get();
    var data = {
      'totalsignin': FieldValue.increment(1),
      'name': user.displayName,
      'profile': user.photoURL,
      'email': user.email,
      'isDark': false,
      'coins': FieldValue.increment(0),
      'coinsWon': FieldValue.increment(0),
      'transaction': FieldValue.arrayUnion([
        {
          'coinsTransaction': 0,
          'purpose': 'joining',
          'pendingStatus': true,
          'date': DateTime.now().toString(),
        }
      ]),
      'id': user.uid,
      'last_signin': DateTime.now(),
    };
    var dataUpdate = {
      'totalsignin': FieldValue.increment(1),
      'last_signin': DateTime.now(),
    };
    if (!snap.exists) {
      return ref.set(data, SetOptions(merge: true));
    } else {
      return ref.set(dataUpdate, SetOptions(merge: true));
    }
  }

  /// Reads all documments from the new_games collection
  Future<List<NewGames>> getNewGmes() async {
    var ref = _db.collection('new_games').orderBy('date', descending: false);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var newGames = data.map((d) => NewGames.fromJson(d));
    return newGames.toList();
  }

  Future<List<Tournaments>> getJoined(List favList) async {
    var ref = _db.collection('alltournaments').where('tId', whereIn: favList);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var newGames = data.map((d) => Tournaments.fromJson(d));
    return newGames.toList();
  }

// for Tournament Future Results
  Future<List<Tournaments>> getResults(String tId) async {
    var ref = _db.collection('alltournaments').where('tId', isEqualTo: tId);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var newGames = data.map((d) => Tournaments.fromJson(d));
    return newGames.toList();
  }

// Get referrals for a user
  Future<List<UserData>> getReferrals(String username) async {
    var ref = _db.collection('usersdata').where('referee', isEqualTo: username);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var referrals = data.map((d) => UserData.fromJson(d));
    return referrals.toList();
  }

  Future<List<Tournaments>> getAllTournaments(String tId, String status) async {
    var ref = _db
        .collection('alltournaments')
        .where('id', isEqualTo: tId)
        .where('status', isEqualTo: status);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var newGames = data.map((d) => Tournaments.fromJson(d));
    return newGames.toList();
  }

  /// Retrieves a single quiz document
  Future<Tournaments> getTournaments(String tournamentId) async {
    var ref = _db.collection('alltournaments').doc(tournamentId);
    var snapshot = await ref.get();
    return Tournaments.fromJson(snapshot.data() ?? {});
  }

  Future<List<Tournaments>> streamOngoing() async {
    var ref = _db
        .collection('alltournaments')
        .orderBy('date', descending: false)
        .where('status', isEqualTo: 'ongoing');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var streamOngoing = data.map((e) => Tournaments.fromJson(e));
    return streamOngoing.toList();
  }

  Future<List<FAQModel>> streamFAQ() async {
    var ref = _db.collection('faq');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var streamFAQ = data.map((e) => FAQModel.fromJson(e));
    return streamFAQ.toList();
  }

  // Userdata for transaction
  Future<List<UserData>> futureTransactions() async {
    final user = AuthService().user!;
    var ref = _db.collection('usersdata').where('id', isEqualTo: user.uid);
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var streamOngoing = data.map((e) => UserData.fromJson(e));
    return streamOngoing.toList();
  }

  Stream<Tournaments> streamAlltournaments(String tId) {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('alltournaments').doc(tId);
        return ref.snapshots().map((doc) => Tournaments.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Tournaments()]);
      }
    });
  }

  Stream<UserData> getUsersdata() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('usersdata').doc(user.uid);
        return ref.snapshots().map((doc) => UserData.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([UserData()]);
      }
    });
  }

  Stream<Tournaments> streamTournamentsData() {
    return AuthService().userStream.switchMap((user) {
      if (user != null) {
        var ref = _db.collection('alltournaments').doc('hqu');
        return ref.snapshots().map((doc) => Tournaments.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Tournaments()]);
      }
    });
  }

  // Add money
  Future<void> updateWallet(
    int coins,
    String why,
    String date,
    String goodName,
    String walletName,
    String moneyRecNumber,
    bool pendingStatus,
  ) {
    var user = AuthService().user!;
    var ref = _db.collection('usersdata').doc(user.uid);
    var data = {
      'transaction': FieldValue.arrayUnion([
        {
          'coinsTransaction': coins,
          'purpose': why,
          'date': date,
          'goodName': user.displayName ?? '',
          'walletName': walletName,
          'moneyRecNumber': moneyRecNumber,
          'pendingStatus': pendingStatus,
        }
      ]),
      'coins': FieldValue.increment(coins),
    };
    return ref.set(data, SetOptions(merge: true));
  }

  /// Pay referral bonus to referee
  Future<void> payReferee(
    int amount,
    String referee,
  ) {
    var data = {
      'coins': FieldValue.increment(amount),
    };
    var ref =
        _db.collection('usersdata').where('name', isEqualTo: referee).get();
    ref.then((value) {
      if (value.docs.isNotEmpty) {
        return value.docs.first.reference.set(data, SetOptions(merge: true));
      }
    });
    return Future(() => null);
  }

  /// Updates the current user's report document after completing
  Future<void> updateJoining(Tournaments tournaments, String playerID) async {
    var user = AuthService().user!;
    var ref = _db.collection('alltournaments').doc(tournaments.tId);
    var ref1 = _db.collection('usersdata').doc(user.uid);
    List playerIdContains = tournaments.joinedPlayers.map((e) {
      return e.playerGameID;
    }).toList();
    var data = {
      'joinedPlayers': FieldValue.arrayUnion([
        {
          'playerGameID': playerID,
          'uid': user.uid,
        }
      ]),
      'joinedPlayersCount': FieldValue.increment(1)
    };
    var dataJoinedPlayers = {
      'joinedTournaments': FieldValue.arrayUnion([tournaments.tId]),
    };
    if (!playerIdContains.contains(playerID)) {
      return ref.set(data, SetOptions(merge: true)).whenComplete(() {
        return ref1.set(dataJoinedPlayers, SetOptions(merge: true));
      });
    } else {
      debugPrint('Noob Not Printed');
    }
  }

  void otpsent(String phNo) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phNo,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {},
      codeSent: (String verificationId, int? resendToken) {},
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  void phoneAuthProvider(
      String otp, String verificationId, String referee) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    String smsCode = otp;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId, smsCode: smsCode);
    await auth.signInWithCredential(credential);
    var user = AuthService().user!;
    var ref = _db.collection('usersdata').doc(user.uid);
    DocumentSnapshot snap = await ref.get();
    var data = {
      'totalsignin': FieldValue.increment(1),
      'name': 'anonymous',
      'profile': AppInformation().userProfile,
      'email': user.phoneNumber,
      'isDark': false,
      'coins': FieldValue.increment(0),
      'referee': referee,
      'referralComplete': false,
      'transaction': FieldValue.arrayUnion([
        {
          'coinsTransaction': 0,
          'purpose': 'joining',
          'pendingStatus': true,
          'date': DateTime.now().toString(),
        }
      ]),
      'id': user.uid,
      'last_signin': DateTime.now(),
    };
    var dataUpdate = {
      'totalsignin': FieldValue.increment(1),
      'last_signin': DateTime.now(),
    };
    if (!snap.exists) {
      return ref.set(data, SetOptions(merge: true));
    } else {
      return ref.set(dataUpdate, SetOptions(merge: true));
    }
  }
}
