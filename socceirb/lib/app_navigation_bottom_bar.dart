// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/routes.dart';
import 'package:socceirb/screens/Home/home_screen.dart';
import 'package:socceirb/screens/Map/map_screen.dart';
import 'package:socceirb/screens/Matchs/MatchsList/matchs_list.dart';
import 'package:socceirb/screens/Matchs/NewMatch/match_screen.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/Profile/profile_screen.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/screens/SignUp/signup_screen.dart';

class AppNavigationBottomBar extends StatefulWidget {
  const AppNavigationBottomBar({Key? key, required this.myAppUser})
      : super(key: key);
  final User myAppUser;
  final String routeName = "/AppNav";

  @override
  State<AppNavigationBottomBar> createState() => _AppNavigationBottomBarState();
}

class _AppNavigationBottomBarState extends State<AppNavigationBottomBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final screenBar = [
      Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (_) => Home(
                    myAppUser: widget.myAppUser,
                  ) /*MatchsList(
                    myAppUser: widget.myAppUser,
                  )*/
              );
        },
      ),
      Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (_) => MapScreen(
                    myAppUser: widget.myAppUser,
                  ));
        },
      ),
      Navigator(
        onGenerateRoute: (settings) {
          return MaterialPageRoute(
              builder: (_) => MatchScreen(
                    myAppUser: widget.myAppUser,
                  ));
        },
      ),
      Profile(
        myAppUser: widget.myAppUser,
      ),
    ];
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: screenBar,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: Color(0xfa211a2a),
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: kGoldenColor,
          unselectedItemColor: Colors.grey[500],
          onTap: (index) => {
            _onItemTapped(index),
          },
          iconSize: 30,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.map_outlined),
              label: 'Map',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'New Match',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined),
              label: 'Profile',
            ),
          ],
        ),
        //initialRoute: const Home().routeName,
      ),
    );
  }
}
