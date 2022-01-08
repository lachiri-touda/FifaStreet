// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/screens/Home/components/home_locationInput.dart';
import 'package:socceirb/screens/Home/components/home_top_container.dart';
import 'package:socceirb/screens/Home/components/home_topbar.dart';
import 'package:socceirb/screens/Matchs/MatchsList/match_joined.dart';
import 'package:socceirb/screens/Matchs/MatchsList/matchs_list.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/services/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Home extends StatefulWidget {
  Home({Key? key, required this.myAppUser}) : super(key: key);
  final User myAppUser;
  final String routeName = "/home";

  @override
  State<Home> createState() => HomeState();
}

class HomeState extends State<Home> {
  bool allMatchs = true;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    getJoinedMatchs();
  }

  Future<String?> getJoinedMatchs() async {
    var document = users.doc(widget.myAppUser.uid);
    bool isEmpty = false;
    List<String> matchsJoinedIds = [];
    Map<String, Matchs> map = {};
    await document.get().then((data) => {
          if (data['Matchs joined'].length != 0)
            {
              for (var elm in data['Matchs joined'])
                {
                  matchsJoinedIds.add(elm),
                },
            }
          else
            {
              isEmpty = true,
            }
        });
    if (!isEmpty) {
      for (var match in matchsJoinedIds) {
        var document = matchs.doc(match);
        document.get().then((data) => {
              map[match] = Matchs(
                location: data['Location'],
                latitude: data['Latitude'].toString(),
                longitude: data['Longitude'].toString(),
                date: data['Date'],
                time: data['Time'],
                players: data['Players'],
                id: document.id,
              )
            });
      }
    }
    /*setState(() {
      widget.myAppUser.matchsJoined = map;
    });*/
    context.read<User>().setMatchsJoined(user: widget.myAppUser, newValue: map);
  }

  @override
  Widget build(BuildContext context) {
    List homePages = [
      MatchsList(myAppUser: widget.myAppUser),
      MatchsJoined(myAppUser: widget.myAppUser)
    ];
    PageController pageController = PageController();

    final authService = context.watch<AuthenticationService>().firebaseAuth;
    final myuser =
        context.watch<AuthenticationService>().firebaseAuth.currentUser;
    TextEditingController locationController = TextEditingController();
    OutlineInputBorder border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Color(0x00ffffff)),
    );
    //SizeConfig().init(context);
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          //resizeToAvoidBottomInset: false,
          appBar: AppBar(
            elevation: 0,
            flexibleSpace: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    stops: [0.1, 0.2, 0.9],
                    colors: [kBaseColor, kFadedBaseColor, kBaseColor],
                  ),
                ),
                child: SafeArea(child: HomeTopBar())),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: SizeConfig.screenHeight,
              width: SizeConfig.screenWidth,
              color: Colors.grey[300],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  // HomeTopContainer(locationController: locationController),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
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
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        width: SizeConfig.screenWidth * 0.85,
                        height: SizeConfig.screenHeight * 0.07,
                        child: TextField(
                          controller: locationController,
                          style: TextStyle(color: Colors.white),
                          obscureText: false,
                          textAlign: TextAlign.left,
                          decoration: textFieldDeco(border),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.symmetric(vertical: 15),
                          //padding: EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                          height: SizeConfig.screenHeight * 0.04,
                          width: SizeConfig.screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: currentPage == 0 ? kGoldenColor : kBaseColor,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                bottomLeft: Radius.circular(20)),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () => {
                                setState(() => {
                                      currentPage = 0,
                                    }),
                                pageController.animateToPage(0,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease),
                              },
                              child: Text(
                                "All Matchs",
                                style: TextStyle(
                                    color: currentPage == 0
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.symmetric(vertical: 15),
                          height: SizeConfig.screenHeight * 0.04,
                          width: SizeConfig.screenWidth * 0.3,
                          decoration: BoxDecoration(
                            color: currentPage == 1 ? kGoldenColor : kBaseColor,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Center(
                            child: InkWell(
                              onTap: () => {
                                setState(() => {
                                      currentPage = 1,
                                    }),
                                pageController.animateToPage(1,
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.ease),
                              },
                              child: Text(
                                "Matchs Joined",
                                style: TextStyle(
                                    color: currentPage == 1
                                        ? Colors.black
                                        : Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 30,
                    child: PageView.builder(
                      controller: pageController,
                      onPageChanged: (value) {
                        setState(() {
                          currentPage = value;
                        });
                      },
                      itemCount: homePages.length,
                      itemBuilder: (context, index) => homePages[index],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration textFieldDeco(OutlineInputBorder border) {
    return InputDecoration(
      prefixIcon: Icon(
        Icons.location_on_sharp,
        color: kGoldenColor,
        size: 20,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 35,
        vertical: 20,
      ),
      filled: true,
      fillColor: kFillColor,
      enabledBorder: border,
      focusedBorder: border,
      hintText: 'Filter by location',
      hintStyle: TextStyle(color: Colors.grey[400], fontSize: 17),
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
