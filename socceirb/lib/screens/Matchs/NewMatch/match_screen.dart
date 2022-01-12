// ignore_for_file: prefer_const_constructors, unused_local_variable

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socceirb/components/default_button.dart';
import 'package:socceirb/components/default_textfield.dart';
import 'package:socceirb/components/success_alert.dart';
import 'package:socceirb/components/text_inputv2.dart';
import 'package:socceirb/constants.dart';
import 'package:http/http.dart' as http;
import 'package:socceirb/screens/Matchs/MatchsList/matchs_list.dart';
import 'package:socceirb/screens/Matchs/MatchsList/user_match_list.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'components/addMatch.dart';
import 'package:intl/intl.dart';

class MatchScreen extends StatefulWidget {
  const MatchScreen({Key? key, required this.myAppUser}) : super(key: key);
  final String routeName = "/match";
  final User myAppUser;
  @override
  State<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen> {
  List<dynamic> _placeList = [];
  TextEditingController matchPosController = TextEditingController();
  TextEditingController matchTimeController = TextEditingController();
  TextEditingController matchPlayersController = TextEditingController();
  TextEditingController matchDateController = TextEditingController();
  CollectionReference matchs = FirebaseFirestore.instance.collection('matchs');
  final myAppUser = auth.FirebaseAuth.instance.currentUser;
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(28),
    borderSide: const BorderSide(color: Colors.purple),
    gapPadding: 10,
  );

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

  @override
  Widget build(BuildContext context) {
    bool showSearch = context.watch<SuggestPlaces>().show;
    TextEditingController dateinput = TextEditingController();
    TextEditingController timeinput = TextEditingController();

    return GestureDetector(
      onTap: () => {
        FocusManager.instance.primaryFocus?.unfocus(),
        context.read<SuggestPlaces>().setFalse(),
      },
      child: Scaffold(
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: Container(
            height: SizeConfig.screenHeight,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.1, 0.2, 0.9],
                colors: [kBaseColor, kFadedBaseColor, kBaseColor],
              ),
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      "Create new match",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: kGoldenColor,
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  Container(
                    width: SizeConfig.screenWidth * 0.85,
                    height: SizeConfig.screenHeight * 0.07,
                    child: TextField(
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
                      onTap: () => {
                        if (_placeList.isNotEmpty)
                          {
                            context.read<SuggestPlaces>().setTrue(),
                          }
                      },
                      controller: matchPosController,
                      style: TextStyle(color: Colors.white),
                      textAlign: TextAlign.left,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        prefixIcon: Icon(null),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 35,
                          vertical: 10,
                        ),
                        filled: true,
                        fillColor: Color(0xff28293f),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0x00ffffff)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Color(0x00ffffff)),
                        ),
                        hintText: "Match location ",
                        hintStyle:
                            TextStyle(color: Colors.grey[400], fontSize: 17),
                      ),
                    ),
                  ),
                  Stack(children: <Widget>[
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        TextInputV2(
                          controller: matchDateController,
                          hintText: "Date format: XX/XX/XXXX",
                          textInputType: TextInputType.datetime,
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2101));

                            if (pickedDate != null) {
                              String formattedDate =
                                  DateFormat('dd/MM/yyyy').format(pickedDate);

                              setState(() {
                                dateinput.text =
                                    formattedDate; //set output date to TextField value.
                                matchDateController.text = formattedDate;
                              });
                            } else {
                              print("Date is not selected");
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextInputV2(
                          controller: matchTimeController,
                          hintText: "Time format: XX:XX",
                          textInputType: TextInputType.datetime,
                          readOnly: true,
                          onTap: () async {
                            TimeOfDay? pickedTime = await showTimePicker(
                              initialTime: TimeOfDay.now(),
                              context: context,
                            );

                            if (pickedTime != null) {
                              DateTime parsedTime = DateFormat.jm()
                                  .parse(pickedTime.format(context).toString());
                              String formattedTime =
                                  DateFormat('HH:mm').format(parsedTime);

                              setState(() {
                                timeinput.text = formattedTime;
                                matchTimeController.text = formattedTime;
                              });
                            } else {
                              print("Time is not selected");
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        TextInputV2(
                          controller: matchPlayersController,
                          hintText: "Number of players",
                          textInputType: TextInputType.datetime,
                        ),
                        SizedBox(
                          height: SizeConfig.screenHeight * 0.07,
                        ),
                        DefaultButton(
                            bgColor: kGoldenColor,
                            textColor: kBaseColor,
                            text: "Create Match",
                            press: () => {
                                  if (matchPosController.text != '' &&
                                      matchTimeController.text != '' &&
                                      matchPlayersController.text != '' &&
                                      matchDateController.text != '')
                                    {
                                      addMatch(
                                        uidAdmin: myAppUser!.uid,
                                        position: matchPosController.text,
                                        time: matchTimeController.text,
                                        playersNum: matchPlayersController.text,
                                        matchs: matchs,
                                        date: matchDateController.text,
                                        user: widget.myAppUser,
                                      )
                                          .then((val) => {
                                                showSuccessAlert(
                                                  message:
                                                      'Match Successfully Created.',
                                                  context: context,
                                                  image:
                                                      "assets/images/succes.png",
                                                )
                                              })
                                          .catchError((err) => {
                                                showSuccessAlert(
                                                  message:
                                                      'Something went wrong.\nMake sure your internet connection and try again.',
                                                  context: context,
                                                  image:
                                                      'assets/images/error.png',
                                                )
                                              }),
                                    }
                                  else
                                    {
                                      showSuccessAlert(
                                        message:
                                            'Something went wrong.\nMake sure you have filled all the fields and try again.',
                                        context: context,
                                        image: 'assets/images/error.png',
                                      )
                                    },
                                  setState(() => {
                                        matchPosController.text = '',
                                        matchTimeController.text = '',
                                        matchPlayersController.text = '',
                                        matchDateController.text = '',
                                        _placeList = [],
                                      })
                                }),
                        SizedBox(
                          height: 20,
                        ),
                        DefaultButton(
                            bgColor: kGoldenColor,
                            textColor: kBaseColor,
                            text: "Matchs Created",
                            press: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute<void>(
                                        builder: (BuildContext context) =>
                                            UserMatchsList(
                                              myAppUser: widget.myAppUser,
                                            )),
                                  ),
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
          ),
        ),
      ),
    );
  }

  Widget ShowPlaces() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: kBaseColor,
          borderRadius: BorderRadius.circular(10),
        ),
        //color: Colors.white.withOpacity(1),
        height: SizeConfig.screenHeight * 0.25,
        width: SizeConfig.screenWidth * 0.85,
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
                          color: Colors.grey[200],
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
