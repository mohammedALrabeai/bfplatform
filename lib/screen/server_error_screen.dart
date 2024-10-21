import 'package:flutter/material.dart';
class ServerError extends StatefulWidget {
  @override
  _ServerErrorState createState() => _ServerErrorState();
}

class _ServerErrorState extends State<ServerError> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      backgroundColor: Colors.white,
      body: Container(
      height: size.height,
      width: size.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/404.png'),
          fit: BoxFit.contain
        )
      ),
    ),));
  }
}
