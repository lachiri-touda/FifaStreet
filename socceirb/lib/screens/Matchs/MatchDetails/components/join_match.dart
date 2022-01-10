import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

Future<void> joinMatch(
    {required User user,
    required Matchs match,
    required List<String> matchIds}) async {
  CollectionReference matchsJoinedDb =
      FirebaseFirestore.instance.collection('matchs_joined');
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  matchs.doc(match.id).update({
    'Joining Users': FieldValue.arrayUnion([user.uid])
  });
  matchs.doc(match.id).update(
    {
      'Players': match.players,
    },
  );
  users.doc(user.uid).update(
    {
      'Matchs joined': matchIds,
    },
  );
  matchsJoinedDb
      .doc()
      .set({
        'MatchId': match.id,
        'UserId': user.uid,
      })
      .then((value) => {})
      .catchError((error) => print("Failed to add user: $error"));
  //match.players = (int.parse(match.players) - 1).toString();
  user.matchsJoined[match.id] = Matchs(
    location: match.location,
    latitude: match.latitude,
    longitude: match.longitude,
    time: match.time,
    players: match.players,
    admin: match.admin,
    date: match.date,
    id: match.id,
    usersJoining: {},
  );
}
