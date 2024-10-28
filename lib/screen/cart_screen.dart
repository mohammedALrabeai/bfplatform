import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/return_cart.dart';
import 'package:many_vendor_app/provider/cart.calculate.provider.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/provider/district_provider.dart';
import 'package:many_vendor_app/provider/logistic_provider.dart';
import 'package:many_vendor_app/provider/return.cart.provider.dart';
import 'package:many_vendor_app/provider/thana_provider.dart';
import 'package:many_vendor_app/screen/loader_screen.dart';
import 'package:many_vendor_app/screen/signin_screen.dart';
//import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'checkout.stepper.screen.dart';
import 'drawer_screen.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  var keyScaffold = GlobalKey<ScaffoldState>();
  CartData _cartData = CartData();
  bool isLoading = true;
  dynamic subTotalPrice = 0;
  dynamic totalTax = 0;
  dynamic totalPrice = 0;
  ReturnCart? returnCart;

  fetchData() async {
    returnCart =
        await Provider.of<ReturnCartProvider>(context, listen: false).hitApi();
    if (returnCart != null) {
      setState(() {
        subTotalPrice = returnCart?.data?.subTotalPrice ?? 0;
        totalPrice = returnCart?.data?.totalPrice ?? 0;
        totalTax = returnCart?.data?.totalTax ?? 0;
        _cartData = returnCart?.data ?? CartData();
        isLoading = false;
      });
    }
  }

  _removeCart(int index) async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('تمت إزالته من العربة'),
      duration: Duration(seconds: 2),
    ));
    Provider.of<CartCalculationProvider>(context, listen: false)
        .remove(_cartData.products![index], context);
    setState(() {
      _cartData.products?.removeAt(index);
    });
    fetchData();
  }

  _checkout(context) async {
    if (await authCheck() != null) {
      // Logic to navigate to checkout screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('عليك تسجيل الدخول لرؤية العربة'),
        duration: Duration(seconds: 2),
      ));
      Timer(Duration(seconds: 1), () {
        // Navigate to SignInScreen
      });
    }
  }

  @override
  void initState() {
    statusCheck(context);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      key: keyScaffold,
      drawer: Drawer(child: DrawerScreen()),
      body: isLoading
          ? LoaderScreen()
          : _cartData.products!.isEmpty
              ? empty()
              : RefreshIndicator(
                  onRefresh: () async {
                    return await fetchData();
                  },
                  child: Container(
                    color: Colors.white,
                    height: size.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: size.height - (size.height / 2.7),
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage('assets/background.png'),
                                  fit: BoxFit.cover)),
                          child: ListView.builder(
                              itemCount: _cartData.products!.length,
                              itemBuilder: (BuildContext context, int index) {
                                final item = _cartData.products![index];
                                Provider.of<CartCalculationProvider>(context,
                                        listen: false)
                                    .show(item);
                                return Card(
                                  color: Colors.white,
                                  elevation: 2,
                                  margin: EdgeInsets.all(12),
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: item.img!,
                                              fit: BoxFit.cover,
                                              progressIndicatorBuilder: (context,
                                                      url, downloadProgress) =>
                                                  Center(
                                                      child: CircularProgressIndicator(
                                                          value:
                                                              downloadProgress
                                                                  .progress)),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(item.name!,
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w700)),
                                              SizedBox(height: 8),
                                              Text(
                                                  'السعر : ${item.price.toStringAsFixed(2)}',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              SizedBox(height: 8),
                                              Text(
                                                  'السعر الفرعي : ${context.watch<CartCalculationProvider>().subPrice}',
                                                  style:
                                                      TextStyle(fontSize: 12)),
                                              SizedBox(height: 10),
                                              GestureDetector(
                                                onTap: () => _removeCart(index),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Icons
                                                            .remove_circle_outline,
                                                        color: Colors.red),
                                                    SizedBox(width: 10),
                                                    Text('إزالة',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12)),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.white,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                    'السعر الكلّي : ${subTotalPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                                ElevatedButton(
                                  onPressed: () => _checkout(context),
                                  child: Row(
                                    children: [
                                      Text('الدفع'),
                                      SizedBox(width: 10),
                                      Icon(CupertinoIcons.cart_fill),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
    ));
  }
}
