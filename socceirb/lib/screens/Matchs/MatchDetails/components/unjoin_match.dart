import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

Future<void> unjoinMatch(
    {required User user,
    required Matchs match,
    required List<String> matchIds}) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference matchsJoinedDb =
      FirebaseFirestore.instance.collection('matchs_joined');
  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  matchs.doc(match.id).update(
    {
      'Players': (int.parse(match.players) + 1).toString(),
    },
  );
  users.doc(user.uid).update(
    {
      'Matchs joined': matchIds,
    },
  );
  matchsJoinedDb
      .where('MatchId', isEqualTo: match.id)
      .get()
      .then((value) => {
            value.docs.forEach((element) {
              matchsJoinedDb.doc(element.id).delete();
            })
          })
      .catchError((error) => print("Failed to add user: $error"));
  //match.players = (int.parse(match.players) + 1).toString();
}
