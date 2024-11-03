import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_app/model/slider.dart';
import 'package:many_vendor_app/model/user.dart';
import 'package:many_vendor_app/provider/slider_provider.dart';
import 'package:many_vendor_app/screen/exception_screen.dart';
import 'package:many_vendor_app/screen/home_screen.dart';
import 'package:many_vendor_app/screen/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String appName = "Beautiful Flowers";
String fontFamily = 'Lama';
String one = "مرحبا بك"; //first screen
String two = "ابحث عن ماتحتاج"; //second screen
String url = 'https://bfplatform.com'; //todo::this is base_url

List<SliderImage> getSlider() {
  List<SliderImage> sliders = [];
  var slide1 = new SliderImage(
      logo: 'assets/2.png',
      desc:
          'نحن متحمسون لانضمامك إلينا. اكتشف أجمل الورود والهدايا بنقرة واحدة واستمتع بتجربة تسوق فريدة.',
      imgPath: 'assets/screen_one.svg',
      background: 'assets/screen_background.svg',
      topTitle: 'أهلًا وسهلًا بك في الوردة الجميلة!');
  sliders.add(slide1);
  var slide2 = new SliderImage(
      logo: 'assets/2.png',
      desc:
          'ابحث عن ما تحب واختر من بين أجمل الورود والهدايا التي تناسب كل مناسباتك الخاصة.',
      imgPath: 'assets/screen_tow.svg',
      background: 'assets/screen_background.svg',
      topTitle: 'ابحث عن ماتُحب');
  sliders.add(slide2);
  var slide3 = new SliderImage(
      logo: 'assets/2.png',
      desc: 'ستعد لبدء رحلة تسوق مميزة حيث الجمال والأناقة في كل تفصيلة.',
      background: 'assets/screen_background.svg',
      imgPath: 'assets/screen_three.svg',
      topTitle: 'ابدأ رحلتك');
  sliders.add(slide3);
  return sliders;
}

final textBlackColor = Colors.black;
final textWhiteColor = Colors.white;
final iconWhiteColor = Colors.white;
final screenWhiteBackground = Colors.white;
final drawerTextStyle = TextStyle(
    color: textBlackColor,
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500);
String code = '#93283a';

colorConvert(code) {
  return Color(int.parse(code.replaceAll('#', '0xff')));
}

final primaryColor = colorConvert('#93283a');
final primaryColor1 = colorConvert('#93283a');
final secondaryColor = primaryColor;
final iconColor = Colors.black;
final inputBorderColor = Colors.black;
final double elevation = 0.5;
final Duration barDuration = Duration(milliseconds: 800);
final double snackBarPadding = 10;
final cartBtnStyle =
    TextStyle(fontSize: 16, fontFamily: fontFamily, color: textWhiteColor);
final logo = 'assets/1.png';
final inputStyle =
    TextStyle(fontFamily: fontFamily, color: Colors.grey, fontSize: 12);

class SliderImage {
  String logo;
  String imgPath;
  String topTitle;
  String desc;
  String background;

  SliderImage(
      {
       required this.logo,
        required this.imgPath,
        required this.topTitle,required this.desc,
        required this.background});
}

logout(token, context) async {
  try {
    // final String url = 'https://doors-windowsbackend.onrender.com/api/products';
    // final response = await http.get(
    //     Uri.parse('${baseUrl}/api/products'),
    //
    // '${baseUrl}/api/products'
    final url = baseUrl + 'logout';
    await http.post( Uri.parse("${url}") , headers: {
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

void statusCheck(context) async {
  bool result = await DataConnectionChecker().hasConnection;
  if (result == true) {
    var response = await http.get(
        Uri.parse(baseUrl + 'status'));
    var value = jsonDecode(response.body.toString());
    print('status ${value['status']}');
    if (value['status'] != 'vendor') {
      /*this is vendor app*/
      if (value['status'] == null) {
      } else {
        //pushNewScreen(context, screen: ExceptionScreen(), withNavBar: false);
      }
    }
  } else {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(
                'لا يوجد اتصال بالانترنت \nتحقق من اتصالك',
                textAlign: TextAlign.center,
              ),
              actions: [
                MaterialButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: Text(
                      'EXIT',
                      style: TextStyle(color: Colors.red),
                    )),
              ],
            ));
  }
}

Widget empty() {
  return Center(
    child: Container(
      height: 200,
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage('assets/empty.png'), fit: BoxFit.cover)),
    ),
  );
}

final String baseUrl = url + "/api/";

final menuStyle =
    TextStyle(fontFamily: fontFamily, color: textBlackColor, fontSize: 12);
final signInUpTextStyle = TextStyle(
    color: secondaryColor, fontFamily: fontFamily, fontWeight: FontWeight.bold);

class CustomCarousel extends StatefulWidget {
  @override
  _CustomCarouselState createState() => _CustomCarouselState();
}

removeSharedPreferences() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  /*if have remove first*/
  _prefs.remove('name');
  _prefs.remove('email');
  _prefs.remove('avatar');
  _prefs.remove('token');
}

setUserDataLoginSharedPreferences(data) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  /*if have remove first*/
  if (_prefs.containsKey('token') &&
      _prefs.containsKey('name') &&
      _prefs.containsKey('avatar') &&
      _prefs.containsKey('email')) {
    _prefs.remove('name');
    _prefs.remove('email');
    _prefs.remove('avatar');
    _prefs.remove('token');
  } else {
    /*set new data*/
    _prefs.setString('name', data['name']);
    _prefs.setString('email', data['email']);
    _prefs.setString('avatar', data['avatar']);
    _prefs.setString('token', data['token']);
  }
}

Future<Auth> getAuthUserData(context) async {
  var user = new Auth();
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  if (_prefs.containsKey('token') &&
      _prefs.containsKey('name') &&
      _prefs.containsKey('avatar') &&
      _prefs.containsKey('email')) {
    /// need to explain
    // user.email = _prefs.getString('email');
    // user.name = _prefs.getString('name');
    // user.avatar = _prefs.getString('avatar');
    // user.token = _prefs.getString('token');
  } else {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignInScreen()));
  }
  return user;
}

Future<String?> authCheck() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (prefs.containsKey('token') &&
      prefs.containsKey('name') &&
      prefs.containsKey('avatar') &&
      prefs.containsKey('email')) {
    return prefs.getString('token');
  } else {
    return null;
  }
}

Future<String> getToken() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  return _prefs.getString('token').toString();
}

getStringValuesSF() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  //Return String
  String? stringValue = prefs.getString('stringValue');
  return stringValue;
}

class _CustomCarouselState extends State<CustomCarousel>
    with SingleTickerProviderStateMixin {
  List<Widget> img = [];
  int currentIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  Timer? timer;

  @override
  void initState() {
    super.initState();
    getSliderData();
    timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      setState(() {
        if (currentIndex < img.length - 1) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }
        if (pageController.hasClients) {
          pageController.animateToPage(
            currentIndex,
            duration: Duration(milliseconds: 300),
            curve: Curves.easeInOut,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    pageController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Future<void> getSliderData() async {
    SliderClass? slider =
        await Provider.of<SliderProvider>(context, listen: false).hitApi();
    //set data
    Provider.of<SliderProvider>(context, listen: false).setData(slider);
    img.clear();
    Provider.of<SliderProvider>(context, listen: false)
        .getData()
        .forEach((element) {
      if (element.appActivate == 'ecommerce') {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ExceptionScreen()));
      } else {
        setState(() {
          img.add(
            Container(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CachedNetworkImage(
                    imageUrl: element.image,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                            child: CircularProgressIndicator(
                                value: downloadProgress.progress)),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ],
              ),
            ),
          );
        });
      }
    });
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.only(top: 4, bottom: 4),
      height: size.height / 4,
      width: size.width,
      child: img.length > 0
          ? PageView.builder(
              onPageChanged: (val) {
                setState(() {
                  currentIndex = val;
                });
              },
              controller: pageController,
              itemCount: img.length,
              itemBuilder: (context, index) {
                return Stack(
                  fit: StackFit.loose,
                  clipBehavior:
                      Clip.none, // Updated from overflow to clipBehavior
                  children: [
                    Container(width: size.width, child: img[index]),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            for (int i = 0; i < img.length; i++)
                              currentIndex == i
                                  ? pageIndexIndicator(true)
                                  : pageIndexIndicator(false)
                          ]),
                        ),
                      ),
                    ),
                  ],
                );
              })
          : Container(),
    );
  }
}
