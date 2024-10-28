import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/screen/home_screen.dart';
import 'package:many_vendor_app/screen/signin_screen.dart';
import 'package:many_vendor_app/screen/signup_screen.dart';
import 'package:many_vendor_app/screen/start_screen.dart';
import 'package:provider/provider.dart';
import 'helper/helper.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(StartScreen());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    statusCheck(context);
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      color: Colors.white,
      theme: ThemeData(
        iconTheme: IconThemeData(
          color: iconColor,
        ),
        indicatorColor: secondaryColor,
        brightness: Brightness.light,
        fontFamily: fontFamily,
       // textSelectionColor: secondaryColor,
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.light,
        fontFamily: fontFamily,
        iconTheme: IconThemeData(
          color: iconColor,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Directionality(
        textDirection: TextDirection.rtl, // Force RTL text direction
        child: PageScreen(),
      ),
    );
  }
}

class PageScreen extends StatefulWidget {
  @override
  _PageScreenState createState() => _PageScreenState();
}

class _PageScreenState extends State<PageScreen> {
  List<SliderImage> pageSlider = [];
  //new List<SliderImage>();
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? Colors.blue : Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    pageSlider = getSlider();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: PageView.builder(
            onPageChanged: (val) {
              setState(() {
                currentIndex = val;
              });
            },
            controller: pageController,
            itemCount: pageSlider.length,
            itemBuilder: (context, index) {
              return SliderTile(sliderImage: pageSlider[index]);
            }),
      ),
      bottomSheet: currentIndex != pageSlider.length - 1
          ? Container(
              height: 100,
              color: Colors.white,
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    height: 25,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(color: Colors.black)),
                    textColor: textBlackColor,
                    onPressed: () {
                      pageController.animateToPage(pageSlider.length - 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: Text(
                      'تخطي',
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        for (int i = 0; i < pageSlider.length; i++)
                          currentIndex == i
                              ? pageIndexIndicator(true)
                              : pageIndexIndicator(false)
                      ]),
                  MaterialButton(
                    height: 25,
                    color: primaryColor,
                    textColor: Colors.white,
                    onPressed: () {
                      pageController.animateToPage(currentIndex + 1,
                          duration: Duration(milliseconds: 400),
                          curve: Curves.linear);
                    },
                    child: Text(
                      'التالي',
                      style: TextStyle(
                          fontFamily: fontFamily,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            )
          : Container(
              height: size.height - (size.height - 200),
              color: Colors.white,
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(),
                        ), //MaterialPageRoute
                      );
                    },
                    minWidth: size.width,
                    height: 30,
                    color: primaryColor,
                    textColor: Colors.white,
                    child: Text(
                      'ابدا التسوق',
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                        height: 25,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: BorderSide(color: Colors.black)),
                        textColor: textBlackColor,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MultiProvider(providers: [
                                        ChangeNotifierProvider<CartCount>.value(
                                            value: CartCount()),
                                      ], child: SignInScreen())));
                        },
                        child: Text(
                          'تسجيل الدخول',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      MaterialButton(
                        height: 25,
                        color: primaryColor,
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      MultiProvider(providers: [
                                        ChangeNotifierProvider<CartCount>.value(
                                            value: CartCount()),
                                      ], child: SignUpScreen())));
                        },
                        child: Text(
                          'إنشاء حساب',
                          style: TextStyle(
                              fontFamily: fontFamily,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      for (int i = 0; i < pageSlider.length; i++)
                        currentIndex == i
                            ? pageIndexIndicator(true)
                            : pageIndexIndicator(false),
                    ]),
                  ),
                ],
              ),
            ),
    );
  }
}

// ignore: must_be_immutable
class SliderTile extends StatelessWidget {
 final SliderImage sliderImage;
  //= new SliderImage();

  SliderTile({required this.sliderImage});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      color: Colors.white,
      height: size.height - 200,
      width: size.width,
      padding: EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          sliderImage.logo != null
              ? Expanded(
                  child: Padding(
                      padding: EdgeInsets.all(5),
                      child: SvgPicture.asset(
                        sliderImage.logo,
                        height: 70,
                      )),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          sliderImage.topTitle != null
              ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    sliderImage.topTitle,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: fontFamily,
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          sliderImage.imgPath != null
              ? Expanded(
                  child: Container(
                    height: 250,
                    child: SvgPicture.asset(
                      sliderImage.imgPath,
                      fit: BoxFit.contain,
                    ),
                  ),
                )
              : Container(),
          SizedBox(
            height: 20,
          ),
          sliderImage.desc != null
              ? Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      sliderImage.desc,
                      style: TextStyle(fontFamily: fontFamily, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
