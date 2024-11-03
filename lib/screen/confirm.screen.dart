import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/repository/db_connection.dart';
import 'package:many_vendor_app/screen/home_screen.dart';

// ignore: must_be_immutable
class ConfirmScreen extends StatefulWidget {
  String title;
  ConfirmScreen({
    required this.title});
  @override
  _ConfirmScreenState createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends State<ConfirmScreen> {
  deleteCarts() async {
    DatabaseConnection _databaseConnection = new DatabaseConnection();
    var carts = await _databaseConnection.fetchCart();
    carts.forEach((element) {
      _databaseConnection.removeCart(element.vendorStockId);
    });
  }

  @override
  void initState() {
    statusCheck(context);
    deleteCarts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          padding: EdgeInsets.all(20),
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/background.png'),
                  fit: BoxFit.cover)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Container(
                  child: SvgPicture.asset('assets/success.svg'),
                ),
              ),
              Text(
                widget.title,
                style: TextStyle(
                    fontFamily: fontFamily, fontSize: 14, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              Divider(
                height: 30,
              ),
              MaterialButton(
                color: primaryColor,
                child: Text(
                  'عد للتسوق',
                  style:
                      TextStyle(fontFamily: fontFamily, color: textWhiteColor),
                ),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomeScreen()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
