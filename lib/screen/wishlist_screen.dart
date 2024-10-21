import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/shop_product.dart';
import 'package:many_vendor_app/provider/product.details.provider.dart';
import 'package:many_vendor_app/provider/variant_satus.dart';
import 'package:many_vendor_app/provider/wishlist.provider.dart';
import 'package:many_vendor_app/repository/db_connection.dart';
import 'package:many_vendor_app/screen/drawer_screen.dart';
import 'package:many_vendor_app/screen/loader_screen.dart';
import 'package:many_vendor_app/screen/single_product_screen.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatefulWidget {
  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  List<ShopProductData> list = List();
  bool isLoading = true;

  fetchData() async {
    /*get data form database*/
    ShopProductHub wishlistProductHub;
    wishlistProductHub =
        await Provider.of<WishlistProvider>(context, listen: false).hitApi();
    Provider.of<WishlistProvider>(context, listen: false)
        .setData(wishlistProductHub);
    setState(() {
      list = Provider.of<WishlistProvider>(context, listen: false).getData();
      isLoading = false;
    });
  }

  _removeFormDb(id) async {
    DatabaseConnection _connection = DatabaseConnection();
    _connection.removeWishlist(id);
  }

  @override
  void initState() {
    statusCheck(context);
    fetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? LoaderScreen()
        : SafeArea(
            child: Scaffold(
            backgroundColor: Colors.white,
            appBar: customAppBar(context),
            drawer: Drawer(child: DrawerScreen()),
            body: list.length == 0
                ? empty()
                : Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/background.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: ListView.builder(
                      itemCount: list.length,
                      itemBuilder: (context, int index) {
                        final item = list[index];
                        return Card(
                          color: Colors.white,
                          elevation: elevation,
                          margin: EdgeInsets.all(8),
                          child: Container(
                            decoration: BoxDecoration(
                              border:
                                  Border.all(color: Colors.grey, width: 0.5),
                            ),
                            padding: EdgeInsets.all(8),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  width:
                                      100, // Ensure the width is set to avoid infinite width error
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: CachedNetworkImage(
                                      imageUrl: item.image,
                                      fit: BoxFit.cover,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                GestureDetector(
                                  onTap: () {
                                    pushNewScreen(
                                      context,
                                      screen: MultiProvider(
                                        providers: [
                                          ChangeNotifierProvider<
                                                  ProductDetailsProvider>.value(
                                              value: ProductDetailsProvider()),
                                          ChangeNotifierProvider<
                                                  VariantStatus>.value(
                                              value: VariantStatus()),
                                        ],
                                        child: SingleProductScreen(
                                          shopProductData: item,
                                        ),
                                      ),
                                    );
                                  },
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        item.name,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: textBlackColor,
                                        ),
                                      ),
                                      Divider(height: 10),
                                      Text(
                                        item.price,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: textBlackColor,
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Divider(height: 10),
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            list.removeAt(index);
                                          });
                                          _removeFormDb(item.productId);
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              padding: EdgeInsets.all(
                                                  snackBarPadding),
                                              content: Text('تمت إزالته'),
                                              duration: barDuration,
                                            ),
                                          );
                                        },
                                        child: Container(
                                          child: Row(
                                            children: [
                                              Container(
                                                child: Icon(
                                                  Icons.add,
                                                  color: Colors.red,
                                                  size: 14,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                      color: Colors.red,
                                                      width: 0.5),
                                                ),
                                                height: 30,
                                              ),
                                              SizedBox(width: 10),
                                              Text(
                                                'إزالة',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                  fontFamily: fontFamily,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ));
  }
}
