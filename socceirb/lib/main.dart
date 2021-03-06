import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socceirb/routes.dart';
import 'package:socceirb/screens/Matchs/MatchsList/match_joined.dart';
import 'package:socceirb/screens/Matchs/NewMatch/components/matchs.dart';
import 'package:socceirb/screens/Matchs/NewMatch/match_screen.dart';
import 'package:socceirb/screens/SignIn/signin_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:socceirb/services/authentication.dart';
import 'package:socceirb/themes.dart';
import 'package:socceirb/wrapper.dart';
import 'package:socceirb/screens/Profile/components/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticationService(),
        ),
        ChangeNotifierProvider(
            create: (_) =>
                User(allMatchs: [], filterMatchs: [], matchsJoined: {})),
        ChangeNotifierProvider(
            create: (_) => Matchs(
                admin: '',
                date: '',
                id: '',
                latitude: '',
                location: '',
                longitude: '',
                players: '',
                time: '',
                usersJoining: {})),
        ChangeNotifierProvider(create: (_) => HomePageAccess()),
        ChangeNotifierProvider(create: (_) => SuggestPlaces()),
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
        fontFamily: "Muli",
        //inputDecorationTheme: inputDecorationTheme(),
      ),
      debugShowCheckedModeBanner: false,
      home: const Wrapper(),
      routes: routes,
    );
  }
}
