import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/brand.dart';
import 'package:many_vendor_app/model/cart.dart';
import 'package:many_vendor_app/model/product_details.dart';
import 'package:many_vendor_app/model/shop_product.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:many_vendor_app/model/trending_category.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/provider/product.details.provider.dart';
import 'package:many_vendor_app/provider/variant_satus.dart';
import 'package:many_vendor_app/repository/db_connection.dart';
import 'package:many_vendor_app/screen/loader_screen.dart';
import 'package:many_vendor_app/screen/product_screen.dart';
import 'package:many_vendor_app/screen/single_brand.dart';
import 'package:many_vendor_app/screen/single_category_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SingleProductScreen extends StatefulWidget {
  ShopProductData shopProductData;

  SingleProductScreen({@required this.shopProductData});

  @override
  _SingleProductScreenState createState() => _SingleProductScreenState();
}

class _SingleProductScreenState extends State<SingleProductScreen> {
  final _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isLoading = true;
  ProductDetails details;

  // final forCart
  Product _product;

  List<Widget> images = new List();

  List<Variants> apiVariant = [];

  String variantForSorting = "";

  void sortingForCartShop(Variant data) {
    Provider.of<VariantStatus>(context, listen: false).changeStatus(data);

    setState(() {
      _product.forCart.shuffle();
    });
  }

  fetchSingleData() async {
    details = await Provider.of<ProductDetailsProvider>(context, listen: false)
        .hitApi(widget.shopProductData.productId);
    Provider.of<ProductDetailsProvider>(context, listen: false)
        .setData(details);
    setState(() {
      apiVariant = Provider.of<ProductDetailsProvider>(context, listen: false)
          .getVariant();
      _product =
          Provider.of<ProductDetailsProvider>(context, listen: false).getData();
      _product.images.forEach((element) {
        images.add(CachedNetworkImage(
          imageUrl: element.url,
          fit: BoxFit.cover,
          progressIndicatorBuilder: (context, url, downloadProgress) => Center(
              child:
                  CircularProgressIndicator(value: downloadProgress.progress)),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ));
        isLoading = false;
      });

      /*here the variant*/
    });
  }

  DatabaseConnection _databaseConnection = new DatabaseConnection();

  _addToCart(stokid, context) async {
    final cart = Cart(vendorStockId: stokid);
    await _databaseConnection.addToCartWithIncrement(cart);
    Provider.of<CartCount>(context, listen: false).totalQuantity();
    showInSnackBar('تمت الاضافة للعربة');
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
        padding: EdgeInsets.all(snackBarPadding),
        content: Text(value),
        duration: barDuration));
  }

  @override
  void initState() {
    statusCheck(context);
    fetchSingleData();

    super.initState();
  }

  Widget _variantsData(BuildContext context) {
    List<Widget> variantWidget = [];
    List<Variant> allVariant = [];
    apiVariant.forEach((element) {
      if (element.variant.length > 0) {
        /*here setup the variant*/
        List<Widget> variants = [];
        element.variant.forEach((variant) {
          variants.add(
            variant.code == null
                ? GestureDetector(
                    onTap: () {
                      sortingForCartShop(variant);
                    },
                    child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius:
                                BorderRadius.circular(variant.active ? 10 : 1),
                            color: !variant.active
                                ? textWhiteColor
                                : textBlackColor),
                        child: Text(
                          variant.variant.toUpperCase(),
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: variant.active
                                  ? textWhiteColor
                                  : textBlackColor),
                        )),
                  )
                : GestureDetector(
                    onTap: () {
                      sortingForCartShop(variant);
                    },
                    child: Container(
                      width: 25,
                      height: 25,
                      decoration: BoxDecoration(
                        color: Color(
                            int.parse(variant.code.replaceAll('#', '0xff'))),
                        shape: BoxShape.rectangle,
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius:
                            BorderRadius.circular(variant.active ? 10 : 1),
                      ),
                    ),
                  ),
          );
          allVariant.add(variant);
        });

        /*setup the variant ways unit*/
        variantWidget.add(Container(
            padding: EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  element.unit.toString(),
                  style: TextStyle(
                      fontFamily: fontFamily,
                      fontSize: 18,
                      color: textBlackColor,
                      fontWeight: FontWeight.w700),
                ),
                Divider(
                  height: 5,
                  color: Colors.transparent,
                ),
                Wrap(
                  runSpacing: 20.0,
                  spacing: 10.0,
                  children: variants,
                )
                /*here the list*/
              ],
            )));
      }
    });
    Provider.of<VariantStatus>(context, listen: false).setVariant(allVariant);
    return Column(children: variantWidget);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return isLoading
        ? LoaderScreen()
        : Scaffold(
            backgroundColor: Colors.white,
            key: _scaffoldKey,
            appBar: customAppBar(context),
            body: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              child: ListView(
                children: <Widget>[
                  ProductSlider(
                    img: images,
                    discountHave: _product.discountHave,
                    productId: widget.shopProductData.productId,
                  ),
                  //Todo:there are product details
                  Container(
                    padding: EdgeInsets.all(10),
                    color: colorConvert('#93283a'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(_product.name,
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                                color: textBlackColor,
                                fontSize: 18)),
                        Divider(
                          color: Colors.transparent,
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'السعر : ',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamily,
                                  color: textBlackColor,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              _product.price,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: fontFamily,
                                  color: textBlackColor,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                        _product.bigDesc != null
                            ? Padding(
                                padding: EdgeInsets.all(8),
                                child: ExpandablePanel(
                                  header: Text(
                                    'وصف المنتج',
                                    style: TextStyle(
                                        color: textBlackColor,
                                        fontFamily: fontFamily,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  collapsed: Text(
                                    _product.bigDesc,
                                    softWrap: true,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  expanded: Text(
                                    _product.bigDesc,
                                    softWrap: true,
                                    style: TextStyle(color: textBlackColor),
                                  ),
                                ),
                              )
                            : Container(),
                        //todo:there are variant
                        SizedBox(
                          height: 10,
                        ),
                        /*todo:here the variant*/
                        _variantsData(context),
                        SizedBox(
                          height: 30,
                        ),
                        Wrap(
                          children: [
                            GestureDetector(
                              onTap: () {
                                TrendingCategoryData _re;
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SingleCategoryScreen(
                                              id: _product.catId,
                                              trendingCategoryData: _re,
                                            )));
                              },
                              child: Row(
                                children: [
                                  Text('الفئة : ',
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          color: textBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold)),
                                  Text(_product.catName,
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          color: textBlackColor,
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            GestureDetector(
                                onTap: () {
                                  BrandData brandData;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SingleBrandProductScreen(
                                                brandData: brandData,
                                                id: _product.brandId,
                                              )));
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'البراند : ',
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          color: textBlackColor,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      _product.brand,
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontSize: 14,
                                          color: textBlackColor,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ],
                                )),
                          ],
                        ),
                        Divider(
                          color: Colors.transparent,
                          height: 30,
                        ),
                      ],
                    ),
                  ),

                  //todo :Related Product
                  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      "متوفر في المتاجر التالية",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: textBlackColor),
                    ),
                  ),
                  _product.forCart.length > 0
                      ? Container(
                          padding: EdgeInsets.all(8),
                          child: GridView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: _product.forCart.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCountAndFixedHeight(
                                      mainAxisSpacing: 2,
                                      crossAxisSpacing: 2,
                                      height: 370,
                                      crossAxisCount: 2),
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  color: Colors.white,
                                  elevation: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          height: 100,
                                          width: size.width,
                                          margin: EdgeInsets.only(top: 5),
                                          child: _product.forCart[index]
                                                      .shopLogo ==
                                                  null
                                              ? Container()
                                              : CachedNetworkImage(
                                                  imageUrl: _product
                                                      .forCart[index].shopLogo,
                                                  fit: BoxFit.cover,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      Center(
                                                          child: CircularProgressIndicator(
                                                              value:
                                                                  downloadProgress
                                                                      .progress)),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          Icon(Icons.error),
                                                )),
                                      _product.forCart[index].stockOut
                                          ? Center(
                                              child: Container(
                                                child: Text(
                                                  'Stock Out',
                                                  style: TextStyle(
                                                      fontFamily: fontFamily,
                                                      color: secondaryColor),
                                                ),
                                              ),
                                            )
                                          : Expanded(
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    RatingBar.builder(
                                                      initialRating: _product
                                                          .forCart[index].rating
                                                          .toDouble(),
                                                      minRating: 1,
                                                      direction:
                                                          Axis.horizontal,
                                                      allowHalfRating: false,
                                                      itemCount: 5,
                                                      itemSize: 14.0,
                                                      itemPadding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: 1.0),
                                                      itemBuilder:
                                                          (context, _) => Icon(
                                                        Icons.star,
                                                        color: Colors.amber,
                                                      ),
                                                      onRatingUpdate:
                                                          (rating) {},
                                                    ),
                                                    Text(
                                                      _product.forCart[index]
                                                          .priceFormat,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                    Text(
                                                      _product.forCart[index]
                                                          .discountText,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                    Text(
                                                      _product.forCart[index]
                                                          .extraPriceFormat,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                    Text(
                                                      _product.forCart[index]
                                                          .totalPriceFormat,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          color:
                                                              secondaryColor),
                                                    ),
                                                    Text(
                                                      _product.forCart[index]
                                                          .variant,
                                                      style: TextStyle(
                                                          fontFamily:
                                                              fontFamily,
                                                          color:
                                                              textBlackColor),
                                                    ),
                                                    GestureDetector(
                                                      child: Container(
                                                        padding:
                                                            EdgeInsets.all(8),
                                                        margin: EdgeInsets.only(
                                                            bottom: 8),
                                                        decoration: BoxDecoration(
                                                            color: primaryColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        5)),
                                                        child: Text(
                                                          'اضف إلى عربة التسوق',
                                                          style: TextStyle(
                                                              fontFamily:
                                                                  fontFamily,
                                                              color:
                                                                  textWhiteColor),
                                                        ),
                                                      ),
                                                      onTap: () {
                                                        _addToCart(
                                                            _product
                                                                .forCart[index]
                                                                .vendorStockId,
                                                            context);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                );
                              }),
                        )
                      : empty(),
                  Container(
                    height: 100,
                  )
                ],
              ),
            ));
  }
}

// ignore: must_be_immutable
class ProductSlider extends StatefulWidget {
  List<Widget> img = [];
  bool discountHave;
  int productId;

  ProductSlider({this.img, this.discountHave, this.productId});

  @override
  _ProductSliderState createState() => _ProductSliderState();
}

class _ProductSliderState extends State<ProductSlider> {
  int currentIndex = 0;
  PageController pageController = new PageController(initialPage: 0);

  bool isLove = false;
  DatabaseConnection _databaseConnection = new DatabaseConnection();

  _addToWishList() async {
    final wish = Wishlist(productId: widget.productId);
    await _databaseConnection.addWishList(wish);
    setState(() {
      isLove = true;
    });
  }

  removeWishlist() async {
    await _databaseConnection.removeWishlist(widget.productId);
    setState(() {
      isLove = false;
    });
  }

  checkIsLove() async {
    var allData = await _databaseConnection.fetchWishList();
    allData.forEach((element) {
      if (widget.productId == element.productId) {
        setState(() {
          isLove = true;
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkIsLove();
    Timer.periodic(Duration(seconds: 2), (Timer timer) {
      if (currentIndex < widget.img.length) {
        currentIndex++;
      } else {
        currentIndex = 0;
      }
      pageController.animateToPage(
        currentIndex,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  Widget pageIndexIndicator(bool isCurrentPage) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 2.0),
      height: isCurrentPage ? 10.0 : 6.0,
      width: isCurrentPage ? 10.0 : 6.0,
      decoration: BoxDecoration(
        color: isCurrentPage ? primaryColor : Colors.black,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Container(
          padding: EdgeInsets.only(top: 4, bottom: 4),
          height: size.height / 2,
          width: size.width,
          child: widget.img.length > 0
              ? PageView.builder(
                  onPageChanged: (val) {
                    setState(() {
                      currentIndex = val;
                    });
                  },
                  controller: pageController,
                  itemCount: widget.img.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      fit: StackFit.expand,
                      overflow: Overflow.visible,
                      children: [
                        Container(width: size.width, child: widget.img[index]),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    for (int i = 0; i < widget.img.length; i++)
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
        ),
        Positioned(
            bottom: 40,
            right: 0,
            child: Container(
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: IconButton(
                onPressed: () {
                  isLove ? removeWishlist() : _addToWishList();
                },
                icon: isLove
                    ? Icon(
                        FontAwesomeIcons.solidHeart,
                        color: secondaryColor,
                      )
                    : Icon(
                        FontAwesomeIcons.heart,
                        color: secondaryColor,
                      ),
              ),
            )),
      ],
    );
  }
}
