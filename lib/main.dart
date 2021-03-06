import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/core/utils/colors.dart';
import 'package:flutter_app/routes/router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: PageRouter.rootPage,
      onGenerateRoute: PageRouter.onGenerateRoute,
      debugShowCheckedModeBanner: false,
      title: 'Bookshelf',
      theme: ThemeData.light().copyWith(
        primaryColor: kLightBlue,
        textTheme: TextTheme(
          bodyText1: TextStyle(fontFamily: 'Lato', color: Colors.black),
        ),
      ),
    );
  }
}
