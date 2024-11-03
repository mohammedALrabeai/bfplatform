import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/screen/cart_screen.dart';
import 'package:many_vendor_app/screen/categories_screen.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_app/screen/dashboard_screen.dart';
import 'package:many_vendor_app/screen/shop_screen.dart';
import 'package:many_vendor_app/screen/signin_screen.dart';
import 'package:many_vendor_app/screen/signup_screen.dart';
import 'package:many_vendor_app/screen/wishlist_screen.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  _DrawerScreenState createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  bool auth = false;
  String email="";
  String name="";
  String avatar="";
  String token="";

  checkAuth() async {
    if (await authCheck() != null) {
      setState(() {
        getAuthUserData(context).then((value) => {
              email = value.email!,
              name = value.name!,
              avatar = value.avatar!,
              token = value.token!,
            });
        auth = true;
      });
    }
  }

  _logout() async {
    try {
      final url = baseUrl + 'logout';
      await http.post(
          Uri.parse(
          url), headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      removeSharedPreferences();
     // pushNewScreen(context, screen: HomeScreen(), withNavBar: false);
    } catch (e) {
      removeSharedPreferences();
     // pushNewScreen(context, screen: HomeScreen(), withNavBar: false);
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
        body: ListView(
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: [
                  auth
                      ? UserAccountsDrawerHeader(
                          accountName: Text(
                            name.toString(),
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                          accountEmail: Text(
                            email.toString(),
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                          currentAccountPicture: CircleAvatar(
                            child: CircleAvatar(
                              maxRadius: 80,
                              backgroundImage: NetworkImage(avatar),
                            ),
                          ),
                        )
                      : UserAccountsDrawerHeader(
                          decoration: BoxDecoration(
                            color: Color(
                                0xFF93283A), // Set your desired color here
                          ),
                          accountName: Text(
                            'قم بتسجيل الدخول',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                          accountEmail: Text(
                            '',
                            style: TextStyle(fontFamily: fontFamily),
                          ),
                        ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.home,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      "الصفحة الرئيسية",
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      // pushNewScreen(context,
                      //     screen: HomeScreen(),
                      //     withNavBar: false,
                      //     pageTransitionAnimation:
                      //         PageTransitionAnimation.cupertino);
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.list,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      "الفئات",
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CategoriesScreen()));
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.storeAlt,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      "المتاجر",
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShopScreen(false)));
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.solidHeart,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      "قائمة الامنيات",
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WishListScreen()));
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  ListTile(
                    leading: Icon(
                      FontAwesomeIcons.shoppingBag,
                      color: primaryColor,
                      size: 18,
                    ),
                    title: Text(
                      "عربة التسوق",
                      style: drawerTextStyle,
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CartScreen()));
                    },
                    trailing: Icon(
                      Icons.arrow_forward,
                      color: textBlackColor,
                      size: 18,
                    ),
                  ),
                  /*this ok*/
                  auth
                      ? Container(
                          child: Column(
                            children: [
                              ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.tachometerAlt,
                                  color: primaryColor,
                                  size: 18,
                                ),
                                title: Text(
                                  "لوحة التحكم",
                                  style: drawerTextStyle,
                                ),
                                onTap: () {
                                  // pushNewScreen(context,
                                  //     screen: DashboardScreen(),
                                  //     withNavBar: false);
                                },
                              ),
                              ListTile(
                                leading: Icon(
                                  FontAwesomeIcons.signOutAlt,
                                  color: primaryColor,
                                  size: 18,
                                ),
                                title: Text(
                                  "تسجيل خروج",
                                  style: drawerTextStyle,
                                ),
                                onTap: () {
                                  _logout();
                                },
                              )
                            ],
                          ),
                        )
                      : Column(
                          children: [
                            ListTile(
                              leading: Icon(
                                FontAwesomeIcons.signInAlt,
                                color: primaryColor,
                                size: 18,
                              ),
                              title: Text(
                                "تسجيل دخول",
                                style: drawerTextStyle,
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            MultiProvider(providers: [
                                              ChangeNotifierProvider<
                                                      CartCount>.value(
                                                  value: CartCount()),
                                            ], child: SignInScreen())));
                              },
                            ),
                            ListTile(
                              leading: Icon(
                                FontAwesomeIcons.signInAlt,
                                color: primaryColor,
                                size: 18,
                              ),
                              title: Text(
                                "انشاء حساب",
                                style: drawerTextStyle,
                              ),
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
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
