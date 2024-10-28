import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/cart.dart';
import 'package:many_vendor_app/model/shop_product.dart';
import 'package:many_vendor_app/provider/product.details.provider.dart';
import 'package:many_vendor_app/provider/variant_satus.dart';
import 'package:many_vendor_app/repository/db_connection.dart';
import 'package:many_vendor_app/screen/single_product_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
//import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatefulWidget {
  final double size;
  final ShopProductData product;

  ProductCard({Key? key, required this.size, required this.product})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isLove = false;
  DatabaseConnection _databaseConnection = new DatabaseConnection();

  _addToWishList() async {
    final wish = Wishlist(productId: widget.product.productId);
    await _databaseConnection.addWishList(wish);
    setState(() {
      isLove = true;
    });
  }

  removeWishlist() async {
    await _databaseConnection.removeWishlist(widget.product.productId);
    setState(() {
      isLove = false;
    });
  }

  checkIsLove() async {
    var allData = await _databaseConnection.fetchWishList();
    allData.forEach((element) {
      if (widget.product.productId == element.productId) {
        setState(() {
          isLove = true;
        });
      }
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    checkIsLove();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        /// need to explain
        // pushNewScreen(context,
        //     screen: MultiProvider(
        //       providers: [
        //         ChangeNotifierProvider<ProductDetailsProvider>.value(
        //             value: ProductDetailsProvider()),
        //         ChangeNotifierProvider<VariantStatus>.value(
        //             value: VariantStatus()),
        //       ],
        //       child: SingleProductScreen(
        //         shopProductData: widget.product,
        //       ),
        //     ));
      },
      child: Card(
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: 150,
              child: Stack(
                children: [
                  Container(
                      padding: EdgeInsets.all(8),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: CachedNetworkImage(
                              imageUrl: widget.product.image!,
                              fit: BoxFit.cover,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) => Center(
                                      child: CircularProgressIndicator(
                                          value: downloadProgress.progress)),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                          )
                        ],
                      )),
                  Positioned(
                    right: 0,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () {
                          isLove ? removeWishlist() : _addToWishList();
                        },
                        icon: Icon(
                          isLove
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: secondaryColor,
                          size: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.product.name!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w700,
                        color: textBlackColor),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.product.price!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 12,
                        fontFamily: fontFamily,
                        color: textBlackColor,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
