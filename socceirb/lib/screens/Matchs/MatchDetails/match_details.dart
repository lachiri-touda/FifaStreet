// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/components/join_match.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/components/unjoin_match.dart';
import 'package:socceirb/screens/Matchs/MatchDetails/joining_users_data.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile%20Other/profile_other.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/services/authentication.dart';

class MatchDetails extends StatefulWidget {
  MatchDetails(
      {Key? key,
      required this.match,
      required this.myAppUser,
      required this.fromMatchsJoined})
      : super(key: key);
  final User myAppUser;
  final String routeName = "matchDetails";
  final Matchs match;
  final bool fromMatchsJoined;

  @override
  _MatchDetailsState createState() => _MatchDetailsState();
}

class _MatchDetailsState extends State<MatchDetails> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  CollectionReference matchsJoinedDb =
      FirebaseFirestore.instance.collection('matchs_joined');
  final user = auth.FirebaseAuth.instance.currentUser;
  bool alreadyJoined = false;

  @override
  void initState() {
    super.initState();
    getJoiningUsers();
  }

  Future<String?> getJoiningUsers() async {
    var document = matchs.doc(widget.match.id);
    bool isEmpty = false;
    List<String> joiningUsersIds = [];
    Map<String, User> map = {};
    await document.get().then((data) => {
          if (data['Joining Users'].length != 0)
            {
              for (var elm in data['Joining Users'])
                {
                  joiningUsersIds.add(elm),
                },
            }
          else
            {
              isEmpty = true,
            }
        });
    if (!isEmpty) {
      for (var userId in joiningUsersIds) {
        var document = users.doc(userId);
        document.get().then((data) => {
              map[userId] = User(
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
      }
    }
    /*setState(() {
      widget.match.usersJoining = map;
    });*/
    context.read<Matchs>().setUsersJoining(match: widget.match, newValue: map);
  }

  @override
  Widget build(BuildContext context) {
    //getJoiningUsers();
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

    List<User> matchJoiningUsers =
        context.read<Matchs>().getUsersJoining(widget.match);
    if (widget.myAppUser.matchsJoined.keys.toList().contains(widget.match.id)) {
      setState(() {
        alreadyJoined = true;
      });
    }
    Matchs myMatch = widget.match;
    return Scaffold(
      appBar: AppBar(
        //backgroundColor: kBaseColor,
        automaticallyImplyLeading: false,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: kGoldenColor,
            size: 23,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Stack(children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.2, 0.9],
                colors: [kBaseColor, kFadedBaseColor, kBaseColor],
              ),
            ),
            child: SafeArea(
              child: Center(
                  child: Text(
                "Match Details",
                style: TextStyle(
                  color: kGoldenColor,
                  fontSize: 20,
                ),
              )),
            ),
          )
        ]),
      ),
      body: Stack(children: [
        SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: SizeConfig.screenHeight,
            color: kGoldenColor,
            //decoration: backgroundDeco(),
            child: myMatch != null
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          //height: SizeConfig.screenHeight * 0.25,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.2, 0.9],
                              colors: [kBaseColor, kFadedBaseColor, kBaseColor],
                            ),
                            borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30)),
                          ),
                          child: matchAdminSection(
                              loadUser(userId: myMatch.admin), myMatch),
                        ),
                        matchInfo(myMatch),
                        //lineDivider(),
                        SizedBox(height: 10),
                        Container(
                          height: SizeConfig.screenHeight * 0.38,
                          decoration: BoxDecoration(
                            /*gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              stops: [0.1, 0.2, 0.9],
                              colors: [kBaseColor, kFadedBaseColor, kBaseColor],
                            ),*/
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              playersTitle(),
                              lineDivider(),
                              SizedBox(height: 15),
                              joiningPlayersList(),
                              Spacer(),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Center(child: Text("Refresh the page")),
          ),
        ),
        !alreadyJoined
            ? (int.parse(myMatch.players)) > 0
                ? joinButton(context, myMatch)
                : matchFull()
            : unjoinButton(context, myMatch),
      ]),
    );
  }

  BoxDecoration backgroundDeco() {
    return BoxDecoration(
      //color: Colors.amber[50],
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        stops: [0, 0.01, 0.8],
        colors: [
          kBgYellowColor,
          kFadedBgYellowColor.withOpacity(0.6),
          kBgYellowColor,
        ],
      ),
    );
  }

  Container lineDivider() {
    return Container(
      margin: EdgeInsets.only(left: 60, right: 60, top: 10),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.7, color: kBaseColor.withOpacity(1)),
        ),
      ),
    );
  }

  Align playersTitle() {
    return Align(
      alignment: Alignment.center,
      child: Text(
        "PLAYERS",
        style: TextStyle(
          color: kBaseColor,
          fontSize: 26,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  Container matchInfo(Matchs myMatch) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      child: Center(
        child: Text(
          "${myMatch.location.toString()}\n ${myMatch.date.toString()} at: ${myMatch.time.toString()}\nPlayers remaining: ${myMatch.players.toString()}",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 19,
            color: Color(0xff221822),
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Container joiningPlayersList() {
    return Container(
        height: SizeConfig.screenHeight * 0.28,
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("matchs_joined")
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Align(
                  alignment: Alignment(0, -0.12),
                  child: Text(
                    "Players loading ...",
                    style: TextStyle(
                        color: kBaseColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600),
                  ),
                );
              default:
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = snapshot.data!.docs[index]
                          .data()! as Map<String, dynamic>;
                      return widget.match.id == data['MatchId']
                          ? Column(
                              children: [
                                JoiningUsersData(
                                  index: index,
                                  doc: snapshot.data!.docs[index],
                                  match: widget.match,
                                ),
                                //Divider()
                              ],
                            )
                          : Container();
                    });
            }
          },
        ));
  }

  Align joinButton(BuildContext context, Matchs myMatch) {
    return Align(
      alignment: Alignment(0, 1.08),
      child: Container(
        margin: EdgeInsets.only(bottom: 40),
        child: DefaultButton(
          textColor: kGoldenColor,
          text: 'Join Match',
          press: () => {
            widget.match.usersJoining[widget.myAppUser.uid.toString()] =
                widget.myAppUser,
            context.read<User>().setValue(
                user: widget.myAppUser,
                info: "Matchs Joined",
                newValue: myMatch.id.toString()),
            context.read<User>().decrementPlayersFilterMatchs(
                user: widget.myAppUser, match: myMatch),
            if (widget.fromMatchsJoined)
              {myMatch.players = (int.parse(myMatch.players) - 1).toString()},
            joinMatch(
              user: widget.myAppUser,
              matchIds: widget.myAppUser.matchsJoined.keys.toList(),
              match: widget.match,
            ).then(
              (value) => setState(() {
                alreadyJoined = true;
              }),
            ),
          },
        ),
      ),
    );
  }

  Align matchFull() {
    return Align(
      alignment: Alignment(0, 1.08),
      child: Container(
        height: SizeConfig.screenHeight * 0.06,
        width: SizeConfig.screenWidth * 0.7,
        margin: EdgeInsets.only(bottom: 40),
        decoration: BoxDecoration(
          color: kBaseColor,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Center(
          child: Text(
            "Match Full",
            style: TextStyle(
              color: kGoldenColor,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }

  Align unjoinButton(BuildContext context, Matchs myMatch) {
    return Align(
      alignment: Alignment(0, 1.08),
      child: Container(
        margin: EdgeInsets.only(bottom: 40),
        child: DefaultButton(
          textColor: kGoldenColor,
          text: 'Unjoin Match',
          press: () => {
            widget.match.usersJoining.remove(widget.myAppUser.uid),
            context.read<User>().removeMatchJoined(
                user: widget.myAppUser, matchId: widget.match.id),
            unjoinMatch(
              user: widget.myAppUser,
              match: widget.match,
              matchIds: widget.myAppUser.matchsJoined.keys.toList(),
            ).then((val) => {
                  setState(() {
                    alreadyJoined = false;
                  }),
                }),
            context.read<User>().incrementPlayersFilterMatchs(
                user: widget.myAppUser, match: myMatch),
            if (widget.fromMatchsJoined)
              {myMatch.players = (int.parse(myMatch.players) + 1).toString()}
          },
        ),
      ),
    );
  }

  Container matchAdminSection(Future<User> loadedUser, Matchs myMatch) {
    return Container(
        margin: EdgeInsets.only(top: 5, bottom: 10),
        child: Align(
          alignment: Alignment.topCenter,
          child: FutureBuilder(
              future: loadedUser,
              builder: (context, AsyncSnapshot<User> player) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) => ProfileOther(
                                user: player.data ??
                                    User(
                                        matchsJoined: {},
                                        allMatchs: [],
                                        filterMatchs: [])),
                          ),
                        ),
                      },
                      child: playerPic(player.data ??
                          User(
                              matchsJoined: {},
                              allMatchs: [],
                              filterMatchs: [])),
                    ),
                    Text(
                      player.data?.name ?? "",
                      style: TextStyle(
                        color: kGoldenColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Organizer",
                      style: TextStyle(
                        color: kGoldenColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }),
        ));
  }

  CircleAvatar playerPic(User player) {
    var profileImage = player.profilePic ?? '';
    return CircleAvatar(
      radius: SizeConfig.screenWidth * 0.09,
      backgroundColor: kGoldenColor,
      child: CircleAvatar(
        radius: SizeConfig.screenWidth * 0.09 - 1,
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
                              ? const AssetImage('assets/images/profile.png')
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
