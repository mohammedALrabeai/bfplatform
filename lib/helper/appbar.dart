import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:many_vendor_app/provider/cart.calculate.provider.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/provider/return.cart.provider.dart';
import 'package:many_vendor_app/screen/cart_screen.dart';
import 'package:provider/provider.dart';
import 'helper.dart';

Widget customAppBar(BuildContext context) {
  Provider.of<CartCount>(context, listen: false).totalQuantity();
  return AppBar(
    toolbarHeight: 100,
    elevation: 0,
    iconTheme: IconThemeData(
      color: iconColor,
    ),
    actionsIconTheme: IconThemeData(
      color: iconColor,
    ),
    backgroundColor: colorConvert('#93283a'),
    title: Center(
        child: Container(
            padding: EdgeInsets.all(14),
            height: 100,
            width: 100,
            child: Image.asset(
              'assets/2.png',
              fit: BoxFit.contain,
            ))),
    actions: <Widget>[
      Padding(
        padding: EdgeInsets.all(8.0),
        child: Container(
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => MultiProvider(providers: [
                              ChangeNotifierProvider<CartCount>.value(
                                  value: CartCount()),
                              ChangeNotifierProvider<ReturnCartProvider>.value(
                                  value: ReturnCartProvider()),
                              ChangeNotifierProvider<
                                      CartCalculationProvider>.value(
                                  value: CartCalculationProvider()),
                            ], child: CartScreen())));
              },
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 18.0),
                    child: IconButton(
                      icon: Icon(
                        CupertinoIcons.cart_fill,
                        size: 28,
                        color: iconWhiteColor,
                      ),
                      onPressed: null,
                    ),
                  ),
                  Positioned(
                      left: 21.5,
                      child: Stack(
                        children: <Widget>[
                          Icon(Icons.brightness_1_sharp,
                              size: 16, color: Colors.white),
                          Positioned(
                              top: 4.5,
                              right: 1,
                              child: Center(
                                child: Text(
                                  context.watch<CartCount>().count.toString(),
                                  style: TextStyle(
                                      color: primaryColor,
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.bold),
                                ),
                              )),
                        ],
                      )),
                ],
              ),
            )),
      )
    ],
  );
}

Widget customSingleAppBar(BuildContext context, title, colors) {
  Provider.of<CartCount>(context, listen: false).totalQuantity();
  return AppBar(
    elevation: 0,
    iconTheme: IconThemeData(
      color: iconColor,
    ),
    actionsIconTheme: IconThemeData(
      color: iconColor,
    ),
    backgroundColor: Colors.white,
    title: Text(
      title.toString(),
      style: TextStyle(fontFamily: fontFamily, color: textBlackColor),
    ),
  );
}
