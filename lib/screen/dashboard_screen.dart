import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/provider/order_provider.dart';
import 'package:many_vendor_app/screen/edit.profile.screen.dart';
import 'package:many_vendor_app/screen/orders_screen.dart';
import 'package:many_vendor_app/screen/password.screen.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  bool isLoading = true;
  String email="";
  String name="";
  String avatar="";
  String token="";

  checkAuth() async {
    if (await authCheck() != null) {
      setState(() {
        getAuthUserData(context).then((value) => {
              email = value.email,
              name = value.name,
              avatar = value.avatar,
              token = value.token,
            });
        isLoading = false;
      });
    } else {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    }
  }

  @override
  void initState() {
    statusCheck(context);
    checkAuth();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      //appBar: customSingleAppBar(context, 'لوحة التحكم', textWhiteColor),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              child: ListView(
                children: [
                  UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    accountName: Text(
                      name.toString(),
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: textBlackColor,
                          fontSize: 24),
                    ),
                    accountEmail: Text(
                      email.toString(),
                      style: TextStyle(
                          fontFamily: fontFamily, color: textBlackColor),
                    ),
                    currentAccountPicture: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: CircleAvatar(
                        maxRadius: 35,
                        backgroundImage: NetworkImage(avatar),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MultiProvider(providers: [
                                    ChangeNotifierProvider<OrderProvider>.value(
                                        value: OrderProvider()),
                                  ], child: OrdersScreen())));
                    },
                    child: Container(
                      height: 80,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.opencart,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'الطلبات',
                            style: TextStyle(
                                color: textBlackColor,
                                fontSize: 18,
                                fontFamily: fontFamily),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditProfileScreen()));
                    },
                    child: Container(
                      height: 80,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.user,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'تعديل المعلومات الشخصية',
                            style: TextStyle(
                                color: textBlackColor,
                                fontSize: 18,
                                fontFamily: fontFamily),
                          )
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PasswordChange()));
                    },
                    child: Container(
                      height: 80,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            FontAwesomeIcons.userLock,
                            color: primaryColor,
                          ),
                          SizedBox(
                            width: 30,
                          ),
                          Text(
                            'تغيير كلمة المرور',
                            style: TextStyle(
                                color: textBlackColor,
                                fontSize: 18,
                                fontFamily: fontFamily),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    ));
  }
}
