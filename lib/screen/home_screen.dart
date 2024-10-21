import 'dart:io';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/provider/brand_product_provider.dart';
import 'package:many_vendor_app/provider/brand_provider.dart';
import 'package:many_vendor_app/provider/campaign.item.provider.dart';
import 'package:many_vendor_app/provider/campaign_provider.dart';
import 'package:many_vendor_app/provider/cart.calculate.provider.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/provider/category_provider.dart';
import 'package:many_vendor_app/provider/district_provider.dart';
import 'package:many_vendor_app/provider/logistic_provider.dart';
import 'package:many_vendor_app/provider/order_provider.dart';
import 'package:many_vendor_app/provider/product.details.provider.dart';
import 'package:many_vendor_app/provider/return.cart.provider.dart';
import 'package:many_vendor_app/provider/shop_product_provider.dart';
import 'package:many_vendor_app/provider/shop_provider.dart';
import 'package:many_vendor_app/provider/slider_provider.dart';
import 'package:many_vendor_app/provider/thana_provider.dart';
import 'package:many_vendor_app/provider/trading_provider.dart';
import 'package:many_vendor_app/provider/trending_cat_provider.dart';
import 'package:many_vendor_app/provider/wishlist.provider.dart';
import 'package:many_vendor_app/screen/categories_screen.dart';

import 'package:many_vendor_app/screen/main_screen.dart';
import 'package:many_vendor_app/screen/search_screen.dart';
import 'package:many_vendor_app/screen/shop_screen.dart';
import 'package:many_vendor_app/screen/wishlist_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PersistentTabController _controller;
  String email;
  String name;
  String avatar;
  String token;

  @override
  void initState() {
    statusCheck(context);
    super.initState();
    _controller = PersistentTabController(initialIndex: 2);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('هل تريد إغلاق التطبيق؟'),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop(false);
                        },
                        child: Text('لا')),
                    FlatButton(
                        onPressed: () {
                          exit(0);
                        },
                        child: Text('نعم')),
                  ],
                ));
      },
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<ShopProductProvider>.value(
              value: ShopProductProvider()),
          ChangeNotifierProvider<SliderProvider>.value(value: SliderProvider()),
          ChangeNotifierProvider<TradingProductProvider>.value(
              value: TradingProductProvider()),
          ChangeNotifierProvider<TrendingCategoryProvider>.value(
              value: TrendingCategoryProvider()),
          ChangeNotifierProvider<CampaignProvider>.value(
              value: CampaignProvider()),
          ChangeNotifierProvider<BrandProvider>.value(value: BrandProvider()),
          ChangeNotifierProvider<ShopProvider>.value(value: ShopProvider()),
          ChangeNotifierProvider<BrandProductProvider>.value(
              value: BrandProductProvider()),
          ChangeNotifierProvider<CategoryProvider>.value(
              value: CategoryProvider()),
          ChangeNotifierProvider<ProductDetailsProvider>.value(
              value: ProductDetailsProvider()),
          ChangeNotifierProvider<WishlistProvider>.value(
              value: WishlistProvider()),
          ChangeNotifierProvider<CampaignItemProvider>.value(
              value: CampaignItemProvider()),
          ChangeNotifierProvider<ReturnCartProvider>.value(
              value: ReturnCartProvider()),
          ChangeNotifierProvider<CartCalculationProvider>.value(
              value: CartCalculationProvider()),
          ChangeNotifierProvider<DistrictProvider>.value(
              value: DistrictProvider()),
          ChangeNotifierProvider<ThanaProvider>.value(value: ThanaProvider()),
          ChangeNotifierProvider<LogisticProvider>.value(
              value: LogisticProvider()),
          ChangeNotifierProvider<CartCount>.value(value: CartCount()),
          ChangeNotifierProvider<OrderProvider>.value(value: OrderProvider()),
          ChangeNotifierProvider<TotalPayment>.value(value: TotalPayment()),
        ],
        child: MaterialApp(
            title: appName,
            debugShowCheckedModeBanner: false,
            color: Colors.white,
            darkTheme: ThemeData(
              brightness: Brightness.light,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            theme: ThemeData(
              iconTheme: IconThemeData(
                color: iconColor,
              ),
              fontFamily: fontFamily,
              brightness: Brightness.light,
              primaryColor: primaryColor,
              accentColor: primaryColor1,
              primaryIconTheme: IconThemeData(
                color: iconColor,
              ),
              indicatorColor: secondaryColor,
              textSelectionColor: secondaryColor,
              primarySwatch: Colors.purple,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: PersistentTabView(
              navBarHeight: 70,
              itemCount: 5,
              controller: _controller,
              screens: [
                ShopScreen(false),
                CategoriesScreen(),
                MainScreen(),
                WishListScreen(),
                SearchScreen(),
              ],
              items: [
                PersistentBottomNavBarItem(
                  icon: Icon(
                    FontAwesomeIcons.storeAlt,
                    size: 16,
                  ),
                  title: ("المتاجر"),
                  activeColor: Colors.white,
                  inactiveColor: CupertinoColors.systemYellow,
                ),
                PersistentBottomNavBarItem(
                  icon: Icon(
                    FontAwesomeIcons.list,
                    size: 16,
                  ),
                  title: ("الفئات"),
                  activeColor: Colors.white,
                  inactiveColor: CupertinoColors.systemYellow,
                ),
                PersistentBottomNavBarItem(
                  icon: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(7.0),
                      child: Image.asset(logo),
                    ),
                  ),
                  activeColor: Colors.white,
                  inactiveColor: CupertinoColors.systemGrey,
                ),
                PersistentBottomNavBarItem(
                  icon: Icon(CupertinoIcons.suit_heart),
                  title: ("قائمة الامنيات"),
                  activeColor: Colors.white,
                  inactiveColor: CupertinoColors.systemYellow,
                ),
                PersistentBottomNavBarItem(
                  icon: Icon(CupertinoIcons.search),
                  title: ("البحث"),
                  activeColor: Colors.white,
                  inactiveColor: CupertinoColors.systemYellow,
                ),
              ],
              confineInSafeArea: true,
              backgroundColor: colorConvert('#93283a'),
              handleAndroidBackButtonPress: true,
              resizeToAvoidBottomInset: true,
              // This needs to be true if you want to move up the screen when keyboard appears.
              stateManagement: true,
              hideNavigationBarWhenKeyboardShows: true,
              // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument.
              decoration: NavBarDecoration(
                borderRadius: BorderRadius.circular(0),
                colorBehindNavBar: primaryColor,
              ),
              popAllScreensOnTapOfSelectedTab: true,
              popActionScreens: PopActionScreensType.all,
              itemAnimationProperties: ItemAnimationProperties(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimation(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                curve: Curves.ease,
                duration: Duration(milliseconds: 200),
              ),
              navBarStyle: NavBarStyle.style6,
            )),
      ),
    );
  }
}
