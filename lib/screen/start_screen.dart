import 'package:flutter_svg/flutter_svg.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/main.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/repository/db_connection.dart';
import 'package:many_vendor_app/screen/home_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  redirectScreen() async {
    try {
      /*here the update the database*/
      DatabaseConnection _databaseConnection = DatabaseConnection();
      var setting = await _databaseConnection.fetchSetting();
      if (setting.length == 0) {
        runApp(
            ChangeNotifierProvider(create: (_) => CartCount(), child: MyApp()));
      } else {
        if (setting[0].value == 'off') {
          runApp(Provider<CartCount>(
              create: (_) => CartCount(), child: HomeScreen()));
        } else {
          runApp(ChangeNotifierProvider(
              create: (_) => CartCount(), child: MyApp()));
        }
      }
    } catch (e) {
      runApp(
          ChangeNotifierProvider(create: (_) => CartCount(), child: MyApp()));
    }
  }

  @override
  Widget build(BuildContext context) {
    Timer(Duration(seconds: 3), () {
      redirectScreen();
    });
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      home: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  'assets/2.png',
                  fit: BoxFit.fill,
                ),
              ),
            )),
      ),
    );
  }
}
