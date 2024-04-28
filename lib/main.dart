import 'package:flutter/material.dart';
import 'package:excelmap/screens/upload_screen.dart';
import 'package:excelmap/screens/login.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:excelmap/screens/errorPage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:html';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy(); //oauth configuration for login page in gcp does not support # in the url
  await dotenv.load(fileName: ".env");
  runApp(
    MaterialApp(
      initialRoute: '/',
      debugShowCheckedModeBanner: false,// Set the initial route (usually the login screen)
      routes: {
        '/error': (context) => SignInErrorWidget(),
        '/': (context) => LoginPage(),
        // Home route
      },

    ),
  );
}


