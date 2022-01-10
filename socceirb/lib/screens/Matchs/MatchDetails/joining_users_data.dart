import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

class JoiningUsersData extends StatefulWidget {
  JoiningUsersData({Key? key, required this.doc, required this.match})
      : super(key: key);

  final QueryDocumentSnapshot doc;
  final Matchs match;

  @override
  _JoiningUsersDataState createState() => _JoiningUsersDataState();
}

class _JoiningUsersDataState extends State<JoiningUsersData> {
  @override
  Widget build(BuildContext context) {
    Future<User> loadUser({required String userId}) async {
      User player = User(matchsJoined: {}, allMatchs: [], filterMatchs: []);
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      var document = users.doc(userId);

      await document.get().then((data) => {
            player = User(
              name: data['Name'],
              email: data["Email"],
              phone: data["Phone Number"],
              address: data["Address"],
              position: data["Poste de jeu"],
              profilePic: data["Profile Picture"],
              matchsJoined: {},
              allMatchs: [],
              filterMatchs: [],
            )
          });

      return player;
    }

    Map<String, dynamic> data = widget.doc.data()! as Map<String, dynamic>;

    return Container(
      child: FutureBuilder(
        future: loadUser(userId: data['UserId']),
        builder: (context, AsyncSnapshot<User> player) {
          if (!player.hasData) {
            return Container();
          }
          return Container(
              height: SizeConfig.screenHeight * 0.1,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Row(
                    children: [
                      playerPic(player.data!),
                      Spacer(),
                      Text(
                        player.data!.name != ''
                            ? player.data!.name!
                            : player.data!.email!,
                        style: TextStyle(
                          color: kBaseColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Text(
                        player.data!.position != ''
                            ? player.data!.position!
                            : '',
                        style: TextStyle(
                          color: kBaseColor,
                          fontSize: 17,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  //Divider(color: kBaseColor)
                ],
              ));
        },
      ),
    );
  }

  CircleAvatar playerPic(User player) {
    var profileImage = player.profilePic ?? '';
    return CircleAvatar(
      radius: SizeConfig.screenWidth * 0.08,
      backgroundColor: kGoldenColor,
      child: CircleAvatar(
        radius: SizeConfig.screenWidth * 0.08 - 1,
        backgroundColor: Colors.transparent,
        child: AspectRatio(
          aspectRatio: 1,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: profileImage == ''
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: FractionalOffset.topCenter,
                          image: profileImage == ''
                              ? AssetImage('assets/images/profile.png')
                                  as ImageProvider
                              : NetworkImage(profileImage)),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: FractionalOffset.topCenter,
                        image: NetworkImage(
                          profileImage,
                        ),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
