// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/components/default_textfield.dart';
import 'package:socceirb/constants.dart';
import 'package:google_place/google_place.dart';
import 'package:http/http.dart' as http;

class MatchScreen extends StatefulWidget {
  MatchScreen({Key? key}) : super(key: key);
  final String routeName = "/match";
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<dynamic> _placeList = [];
  TextEditingController matchPosController = TextEditingController();
  TextEditingController matchTimeController = TextEditingController();
  TextEditingController matchPlayersController = TextEditingController();

  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  final myAppUser = auth.FirebaseAuth.instance.currentUser;

  Future getSuggestion(String input) async {
    String googleKey = "AIzaSyDzASEU_ras6xW2e0MiZZTH0PEWDVnvAaQ";
    String type = '(regions)';
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$googleKey';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        _placeList = json.decode(response.body)['predictions'];
      });
    } else {
      print('Failed to load predictions');
    }
  }

  Future<void> addMatch(
      {required String uidAdmin,
      required String position,
      required String time,
      String? playersNum}) {
    return matchs
        .doc(myAppUser!.uid)
        .set({
          'Admin': uidAdmin,
          'Position': position,
          'Time': time,
          'Players': playersNum,
        })
        .then((value) => {})
        .catchError((error) => print("Failed to create match: $error"));
  }

  @override
  Widget build(BuildContext context) {
    bool showSearch = context.watch<SuggestPlaces>().show;

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 10,
          ),
          child: Column(
            children: [
              SizedBox(height: 60),
              const Center(
                child: Text(
                  "Create new match",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.purple,
                  ),
                ),
              ),
              SizedBox(height: 60),
              TextField(
                controller: matchPosController,
                keyboardType: TextInputType.text,
                cursorHeight: 27,
                onEditingComplete: () => {
                  context.read<SuggestPlaces>().setFalse(),
                },
                onChanged: (value) async => {
                  await getSuggestion(matchPosController.text),
                  if (matchPosController.text == "")
                    {
                      context.read<SuggestPlaces>().setFalse(),
                    }
                  else
                    {
                      context.read<SuggestPlaces>().setTrue(),
                    }
                },
                onTap: () => {},
                decoration: const InputDecoration(
                  labelText: "Location",
                ),
              ),
              Stack(children: <Widget>[
                Column(
                  children: [
                    MyTextField(controller: matchTimeController, label: "Time"),
                    MyTextField(
                        controller: matchPlayersController,
                        label: "Number of players"),
                    SizedBox(
                      height: SizeConfig.screenHeight * 0.12,
                    ),
                    DefaultButton(
                        text: "Create Match",
                        press: () => {
                              addMatch(
                                uidAdmin: myAppUser!.uid,
                                position: matchPosController.text,
                                time: matchTimeController.text,
                                playersNum: matchPlayersController.text,
                              ),
                              print(matchPosController.text)
                            }),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
                showSearch ? ShowPlaces() : Container(),
              ]),
            ],
          ),
        ),
      )),
    );
  }

  Widget ShowPlaces() {
    return Center(
      child: Container(
        color: Colors.white.withOpacity(1),
        height: SizeConfig.screenHeight * 0.22,
        width: SizeConfig.screenWidth * 0.9,
        child: ListView.builder(
          itemCount: _placeList.length,
          itemBuilder: (context, index) {
            return SingleChildScrollView(
              child: GestureDetector(
                onTap: () => {
                  setState(() {
                    matchPosController.text = _placeList[index]['description'];
                  }),
                },
                child: ListTile(
                  visualDensity: VisualDensity(horizontal: 0, vertical: -4),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _placeList[index]['description'],
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class SuggestPlaces with ChangeNotifier {
  bool show = false;

  void setTrue() {
    show = true;
    notifyListeners();
  }

  void setFalse() {
    show = false;
    notifyListeners();
  }
}
