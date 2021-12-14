import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/routes.dart';
import 'package:socceirb/screens/Home/home_screen.dart';
import 'package:socceirb/screens/Map/map_screen.dart';
import 'package:socceirb/screens/NewMatch/match_screen.dart';
import 'package:socceirb/screens/Profile/components/user.dart';
import 'package:socceirb/screens/Profile/profile_screen.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/screens/SignUp/signup_screen.dart';

class AppNavigationBottomBar extends StatefulWidget {
  const AppNavigationBottomBar({Key? key, required this.myAppUser})
      : super(key: key);
  final User? myAppUser;
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
      const Home(),
      MapScreen(),
      const MatchScreen(),
      Profile(
        myAppUser: widget.myAppUser!,
      ),
    ];
    return SafeArea(
      child: Scaffold(
        body: IndexedStack(
          index: _selectedIndex,
          children: screenBar,
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedIndex,
          backgroundColor: Colors.purple,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          selectedItemColor: Colors.amber[800],
          unselectedItemColor: Colors.white,
          onTap: (index) => {
            _onItemTapped(index),
            //Navigator.pushNamed(context, screenBar[index]),
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
