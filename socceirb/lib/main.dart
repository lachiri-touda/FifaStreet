import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socceirb/constants.dart';
import 'package:socceirb/routes.dart';
import 'package:socceirb/screens/Home/home_screen.dart';
import 'package:socceirb/screens/Map/map_screen.dart';
import 'package:socceirb/screens/NewMatch/match_screen.dart';
import 'package:socceirb/screens/Profile/profile_screen.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:socceirb/screens/SignUp/signup_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socceirb/services/authentication.dart';
import 'package:socceirb/themes.dart';
import 'package:socceirb/wrapper.dart';

import 'app_navigation_bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticationService(),
        ),
        ChangeNotifierProvider(create: (_) => UserData()),
        ChangeNotifierProvider(create: (_) => HomePageAccess()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        inputDecorationTheme: inputDecorationTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: Wrapper(),
      routes: routes,
      //initialRoute: const Home().routeName,
    );
  }
}
