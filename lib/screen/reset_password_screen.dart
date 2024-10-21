import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final newpassword = TextEditingController();
  final confirmpassword = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoadingModal = false;

  String email = '';
  String code = '';

  _changePassword(String newPassword, String cpassword) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    email = _prefs.getString('femail');
    code = _prefs.getString('code');
    setState(() {
      _isLoadingModal = true;
    });

    if (newPassword == cpassword) {
      try {
        String url = baseUrl + '3/forget/password';
        final _result = await http.post(url,
            body: jsonEncode({
              'password': newPassword,
              'email': email,
              'code': code,
            }),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            });

        if (_result.statusCode == 200 && _result.body != null) {
          final data = json.decode(_result.body);

          if (data['error'] == true) {
            setState(() {
              _isLoadingModal = false;
            });
            _showFailedMessage(context, data['message']);
          } else {
            setState(() {
              _isLoadingModal = false;
            });
            _showSuccessMessage(context, data['message']);
            Timer(Duration(seconds: 2), () {
              Navigator.pop(context);
              pushNewScreen(context, screen: HomeScreen(), withNavBar: false);
            });
          }
        }
      } catch (e) {
        _showFailedMessage(context, 'معلومات خاطئة');
      }
    } else {
      _showFailedMessage(context, 'تأكيد كلمة المرور خاطئ');
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      padding: EdgeInsets.all(snackBarPadding),
      content: Text(value),
      duration: barDuration,
    ));
  }

  _showFailedMessage(BuildContext context, title) {
    setState(() {
      _isLoadingModal = false;
    });
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 360.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        FontAwesomeIcons.exclamationTriangle,
                        size: 30,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0,
                          fontFamily: fontFamily,
                          color: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  _showSuccessMessage(BuildContext context, message) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              height: 360.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  IconButton(
                      icon: Icon(
                        CupertinoIcons.checkmark,
                        size: 30,
                        color: Colors.green,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      message.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14.0, fontFamily: fontFamily),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          key: _scaffoldKey,
          appBar: customSingleAppBar(
              context, 'إستعادة كلمة المرور', textWhiteColor),
          body: SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              margin: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: SvgPicture.asset(
                        'assets/logo.svg',
                        height: 70,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'تغيير كلمة المرور',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Divider(
                    height: 20,
                    color: screenWhiteBackground,
                  ),
                  TextField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      labelText: "New Password",
                      fillColor: inputBorderColor,
                      prefixIcon: Icon(
                        Icons.security,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: fontFamily,
                    ),
                    controller: newpassword,
                  ),
                  Divider(
                    height: 20,
                    color: screenWhiteBackground,
                  ),
                  TextField(
                    obscureText: !_passwordVisible,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      labelText: "Confirm Password",
                      fillColor: inputBorderColor,
                      prefixIcon: Icon(
                        Icons.security,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                    ),
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontFamily: fontFamily,
                    ),
                    controller: confirmpassword,
                  ),
                  Divider(
                    height: 20,
                    color: screenWhiteBackground,
                  ),
                  FlatButton(
                    color: primaryColor,
                    child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: secondaryColor,
                        ),
                        child: _isLoadingModal == false
                            ? Center(
                                child: Text(
                                'تغيير كلمة المرور',
                                style: TextStyle(
                                    color: textWhiteColor,
                                    fontFamily: fontFamily,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12),
                              ))
                            : Center(
                                child: Text(
                                'تتم المعالجة....',
                                style: TextStyle(
                                    color: textWhiteColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ))),
                    onPressed: () {
                      _changePassword(newpassword.text, confirmpassword.text);
                    },
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
