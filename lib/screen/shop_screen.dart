import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/shop.dart';
import 'package:many_vendor_app/provider/shop_provider.dart';
import 'package:many_vendor_app/screen/drawer_screen.dart';
import 'package:many_vendor_app/screen/loader_screen.dart';
import 'package:many_vendor_app/screen/single_shop_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ShopScreen extends StatefulWidget {
  bool single;

  ShopScreen(this.single);

  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<ShopData> shop = [];
  bool isLoading = false;

  fetchShop() async {
    /*set shop data tab shop*/
    ShopHub shopHub =
        await Provider.of<ShopProvider>(context, listen: false).hitApi(context);
    Provider.of<ShopProvider>(context, listen: false).setData(shopHub);
    setState(() {
      shop = Provider.of<ShopProvider>(context, listen: false).getData();
      isLoading = true;
    });
  }

  @override
  void initState() {
    statusCheck(context);
    fetchShop();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double cellWidth =
        ((size.width - 29) / ((shop.length <= 0 ? 0 : shop.length) / 2));
    double desiredCellHeight = 250;
    double childAspectRatio = cellWidth / desiredCellHeight;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      drawer: Drawer(
        child: DrawerScreen(),
      ),
      body: !isLoading
          ? LoaderScreen()
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              child: RefreshIndicator(
                onRefresh: () async {
                  return await fetchShop();
                },
                child: GridView.builder(
                    itemCount: shop.length <= 0 ? 0 : shop.length,
                    physics:
                        !widget.single ? null : NeverScrollableScrollPhysics(),
                    //this is for not scrollable
                    primary: widget.single,
                    shrinkWrap: widget.single,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: childAspectRatio,
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (BuildContext context, int index) => Container(
                          margin: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: () {
                              pushNewScreenWithRouteSettings(
                                context,
                                screen: SingleShopScreen(shopData: shop[index]),
                                withNavBar: true,
                                pageTransitionAnimation:
                                    PageTransitionAnimation.cupertino,
                                settings: null,
                              );
                            },
                            child: Card(
                              color: Colors.white,
                              margin: EdgeInsets.all(8),
                              elevation: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                      height: 80,
                                      margin: EdgeInsets.all(10),
                                      width: size.width / 2.2,
                                      // height: 80,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(0.5),
                                      ),
                                      child: shop[index].shopLogo == null
                                          ? Container()
                                          : CachedNetworkImage(
                                              imageUrl: shop[index].shopLogo,
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
                                            )),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    shop[index].shopName ?? '',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: fontFamily,
                                        color: textBlackColor,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    'اجمالي المنتجات : ' +
                                            shop[index]
                                                .totalProduct
                                                .toString() ??
                                        '',
                                    style: TextStyle(
                                        fontFamily: fontFamily,
                                        color: textBlackColor,
                                        fontSize: 12),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  RatingBar.builder(
                                    initialRating:
                                        shop[index].rating.toDouble(),
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: false,
                                    itemCount: 5,
                                    itemSize: 12.0,
                                    itemPadding:
                                        EdgeInsets.symmetric(horizontal: 1.0),
                                    itemBuilder: (context, _) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (rating) {
                                      print(rating);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
              ),
            ),
    ));
  }
}
