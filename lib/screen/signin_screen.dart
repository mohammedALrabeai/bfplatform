import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/screen/reset_screen.dart';
import 'package:many_vendor_app/screen/signup_screen.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'drawer_screen.dart';
import 'home_screen.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final email = TextEditingController();
  final password = TextEditingController();

  bool _passwordVisible = true;
  bool _isInvalid = false;
  bool _isLoading = false;

  void showInSnackBar(String value) {
    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //   padding: EdgeInsets.all(snackBarPadding),
    //   content: Text(value),
    //   duration: barDuration,
   // ));
  }

  _login(String email, String password) async {
    print('login cred');
    setState(() {
      _isLoading = true;
    });
    try {
      String url = baseUrl + 'login';
      final _result =
          await http.post(
              Uri.parse(
              url), body: {'email': email, 'password': password});
      print('login cred ${_result.body.toString()}');
      if (_result.statusCode == 200 && _result.body != null) {
        final data = json.decode(_result.body);
        print('login cred $data');
        if (data['error'] == true) {
          _showFailedMessage(context, data['errorMessage']);
        } else {
          if (data['token'] != null) {
            setUserDataLoginSharedPreferences(data);
            _showSuccessMessage(context, data['errorMessage']);
            Timer(Duration(seconds: 1), () {
              Navigator.pop(context);
             // pushNewScreen(context, screen: HomeScreen(), withNavBar: false);
            });
          }
          _showSuccessMessage(context, data['errorMessage']);
        }
      }
    } catch (e) {
      _showFailedMessage(context, 'Wrong information');
    }
    setState(() {
      _isLoading = false;
    });
  }

  _showFailedMessage(BuildContext context, title) {
    setState(() {
      _isLoading = false;
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
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: 200.0,
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
                    padding: EdgeInsets.all(8.0),
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

  _showSuccessMessage(BuildContext context, title) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            contentPadding: EdgeInsets.all(0.0),
            content: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              height: 200.0,
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
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      title,
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

  bool validateEmail(String value) {
    try {
      // Pattern pattern =
      //     r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp( r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
      if (!regex.hasMatch(value))
        return false;
      else
        return true;
    } catch (e) {
      return false;
    }
  }

  @override
  void initState() {
    statusCheck(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
      //  appBar: customAppBar(context),
        drawer: Drawer(
          child: DrawerScreen(),
        ),
        body: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage('assets/background.png'),
                    fit: BoxFit.cover)),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                      padding: EdgeInsets.all(10),
                      child: Image.asset(
                        'assets/2.png',
                        height: 70,
                      )),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'أهلًا بعودتك',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          fontSize: 24),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'سجل دخولك للمتابعة',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily,
                          fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  TextField(
                    decoration: InputDecoration(
                      labelText: "ادخل البريد الالكتروني",
                      labelStyle: inputStyle,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.alternate_email,
                        color: primaryColor,
                      ),
                    ),
                    onChanged: (value) {
                      if (validateEmail(value)) {
                        setState(() {
                          _isInvalid = false;
                        });
                      } else {
                        setState(() {
                          _isInvalid = true;
                        });
                      }
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: inputStyle,
                    controller: email,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextField(
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                      labelText: "كلمة المرور",
                      labelStyle: inputStyle,
                      contentPadding: EdgeInsets.symmetric(vertical: 12.0),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey, width: 0.5),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: Icon(
                        Icons.security,
                        color: primaryColor,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          !_passwordVisible
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
                    style: inputStyle,
                    controller: password,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Visibility(
                    visible: _isInvalid,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 28.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 14.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'بريد الكتروني خاطئ.',
                                  style: TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(top: 20, bottom: 20),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ResetScreen()));
                          },
                          child: Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                                color: textBlackColor,
                                fontFamily: fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      if (!_isInvalid && !_isLoading) {
                        _login(email.text, password.text);
                      }
                    },
                    child: Container(
                        height: 30,
                        width: size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: primaryColor,
                        ),
                        child: _isLoading == false
                            ? Center(
                                child: Text(
                                'تسجيل الدخول',
                                style: TextStyle(
                                    color: textWhiteColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ))
                            : Center(
                                child: Text(
                                'Processing....',
                                style: TextStyle(
                                    color: textWhiteColor,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14),
                              ))),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ' ',
                          style: TextStyle(
                              color: textBlackColor,
                              fontFamily: fontFamily,
                              fontSize: 12),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MultiProvider(providers: [
                                          ChangeNotifierProvider<
                                                  CartCount>.value(
                                              value: CartCount()),
                                        ], child: SignUpScreen())));
                          },
                          child: Text(
                            '  إنشاء حساب',
                            style: TextStyle(
                                color: primaryColor,
                                fontFamily: fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
