import 'package:flutter/material.dart';
import 'package:socceirb/app_navigation_bottom_bar.dart';
import 'package:socceirb/screens/Home/home_screen.dart';
import 'package:socceirb/screens/Map/map_screen.dart';
import 'package:socceirb/screens/NewMatch/match_screen.dart';
import 'package:socceirb/screens/Profile/components/info_change.dart';
import 'package:socceirb/screens/Profile/profile_screen.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/screens/SignUp/signup_screen.dart';

final Map<String, WidgetBuilder> routes = {
  const Home().routeName: (context) => const Home(),
  //const Profile().routeName: (context) => const Profile(),
  const MapScreen().routeName: (context) => const MapScreen(),
  const MatchScreen().routeName: (context) => const MatchScreen(),
  InfoChange().routeName: (context) => InfoChange(),
  const SigninScreen().routeName: (context) => const SigninScreen(),
  const SignupScreen().routeName: (context) => const SignupScreen(),
  const AppNavigationBottomBar().routeName: (context) =>
      const AppNavigationBottomBar(),
};
