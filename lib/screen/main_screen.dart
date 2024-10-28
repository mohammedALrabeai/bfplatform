import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/brand.dart';
import 'package:many_vendor_app/model/campaign.dart';
import 'package:many_vendor_app/model/setting.dart';
import 'package:many_vendor_app/model/shop.dart';
import 'package:many_vendor_app/model/shop_product.dart';
import 'package:many_vendor_app/model/trending_category.dart';
import 'package:many_vendor_app/provider/brand_provider.dart';
import 'package:many_vendor_app/provider/campaign_provider.dart';
import 'package:many_vendor_app/provider/shop_provider.dart';
import 'package:many_vendor_app/provider/trading_provider.dart';
import 'package:many_vendor_app/provider/trending_cat_provider.dart';
import 'package:many_vendor_app/repository/db_connection.dart';
import 'package:many_vendor_app/screen/campaign_screen.dart';
import 'package:many_vendor_app/screen/drawer_screen.dart';
import 'package:many_vendor_app/screen/loader_screen.dart';
import 'package:many_vendor_app/screen/product_screen.dart';
import 'package:many_vendor_app/screen/single.campaign.screen.dart';
import 'package:many_vendor_app/screen/single_brand.dart';
import 'package:many_vendor_app/screen/single_category_screen.dart';
import 'package:many_vendor_app/screen/single_shop_screen.dart';
import 'package:provider/provider.dart';
import 'package:many_vendor_app/provider/shop_product_provider.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  List<ShopProductData> shopProductData = [];
  List<ShopProductData> shopProductData2 = [];

  List<BrandData> brand = [];
  bool isLoading = true;
  List<CampaignData> _campaignData = [];
  List<ShopData> shop=[];

  String search = "";
  bool hasSearched = false;

  List<TrendingCategoryData> list = [];
  bool isLoadingForCat = true;
  TabController? _tabController;
  int tabIndex = 0;

  hitCampaignApi() async {
    /*set campaign data*/
    CampaignClass? campaign =
        await Provider.of<CampaignProvider>(context, listen: false)
            .campaignHitApi(context);
    //  set data
    Provider.of<CampaignProvider>(context, listen: false).setData(campaign!);

    /*category for tab*/
    TrendingCategoryHub? trendingCategoryHub =
        await Provider.of<TrendingCategoryProvider>(context, listen: false)
            .hitApi();
    Provider.of<TrendingCategoryProvider>(context, listen: false)
        .setData(trendingCategoryHub!);

    /*trading product*/
    ShopProductHub? shopProduct =
        await Provider.of<TradingProductProvider>(context, listen: false)
            .hitApi();
    /*set data*/
    Provider.of<TradingProductProvider>(context, listen: false)
        .setData(shopProduct!);

    /*set brand data tab brand*/
    BrandClass? brandClass =
        await Provider.of<BrandProvider>(context, listen: false)
            .brandHitApi(context);
    Provider.of<BrandProvider>(context, listen: false).setData(brandClass!);

    /*set shop data tab shop*/
    ShopHub? shopHub =
        await Provider.of<ShopProvider>(context, listen: false).hitApi(context);
    Provider.of<ShopProvider>(context, listen: false).setData(shopHub!);

    setState(() {
      /*campaign*/
      _campaignData =
          Provider.of<CampaignProvider>(context, listen: false).getData();

      /*trending product list update*/
      list = Provider.of<TrendingCategoryProvider>(context, listen: false)
          .getData();
      shopProductData =
          Provider.of<TradingProductProvider>(context, listen: false).getData();
      brand = Provider.of<BrandProvider>(context, listen: false).getData();

      shop = Provider.of<ShopProvider>(context, listen: false).getData();
      isLoading = false;
    });
  }

  fetchData(query) async {
    ShopProductHub? shopProductHub =
        await Provider.of<ShopProductProvider>(context, listen: false)
            .allProduct(query);

    /*set data*/
    Provider.of<ShopProductProvider>(context, listen: false)
        .setData(shopProductHub!);
    setState(() {
      shopProductData2 =
          Provider.of<ShopProductProvider>(context, listen: false).getData() ??
              [];

      isLoading = false;
      hasSearched = true;
    });
  }

  final List<Widget> myTabs = [
    Tab(child: Text('الفئات الرائجة')),
    Tab(child: Text('البراندات')),
    Tab(child: Text('المتاجر')),
  ];

  @override
  void dispose() {
    _tabController!.dispose();
    super.dispose();
  }

  _setupSetting() async {
    /*here the update the database*/
    DatabaseConnection _databaseConnection = DatabaseConnection();
    final appSetting = AppSetting(
      type: 'slid_screen'.toString(),
      value: 'off'.toString(),
    );
    await _databaseConnection.addSystemItem(appSetting);
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabSelection);
    statusCheck(context);
    // fetchData('all');
    hitCampaignApi();
    _setupSetting();
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController!.indexIsChanging) {
      setState(() {
        tabIndex = _tabController!.index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _tabController= TabController(length: 3, vsync: this);
    List<Widget> campaignWidget = [];
    Size size = MediaQuery.of(context).size;
    try {
      if (isLoading == false) {
        campaignWidget.clear();
        _campaignData.forEach((element) {
          campaignWidget.add(GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SingleCampaignScreen(
                            campaignData: element,
                          )));
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              padding: EdgeInsets.all(0),
              margin: EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: CachedNetworkImage(
                  width: size.width / 2.8,
                  height: size.height / 4,
                  imageUrl: element.banner,
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                          child: CircularProgressIndicator(
                              value: downloadProgress.progress)),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
              ),
            ),
          ));
        });
      }
    } catch (e) {
      campaignWidget.add(Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Center(
              child: Text(
            'لا يوجد حملة حاليًا',
            textAlign: TextAlign.center,
            style: TextStyle(
                color: textBlackColor,
                fontFamily: fontFamily,
                fontWeight: FontWeight.bold),
          )),
        ),
      ));
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
       // appBar: customAppBar(context),
        drawer: Drawer(
          child: DrawerScreen(),
        ),
        body: isLoading
            ? LoaderScreen()
            : Container(
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/background.png'),
                        fit: BoxFit.cover)),
                child: RefreshIndicator(
                  onRefresh: () async {
                    return await hitCampaignApi();
                  },
                  child: ListView(shrinkWrap: true, children: [
                    CustomCarousel(),
                    /*tab screen*/
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: EdgeInsets.all(8.0),
                          color: Colors.white,
                          child: Container(
                            child: TextField(
                              textAlign: TextAlign.right,
                              style:
                                  TextStyle(), // Replace with your inputStyle
                              onChanged: (value) {
                                setState(() {
                                  search = value;
                                });
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 12.0),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide(
                                      color: Colors.grey, width: 0.5),
                                ),
                                hintText: 'ابحث عن منتج',
                                hintStyle: TextStyle(
                                  color: Colors
                                      .black, // Replace with your textBlackColor
                                  fontFamily:
                                      'Lama', // Replace with your fontFamily
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    Icons.search,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    fetchData(search);
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        hasSearched
                            ? Column(
                                children: [
                                  ProductScreen(
                                      shopProductData: shopProductData2),
                                ],
                              )
                            : Container(),
                        Container(
                          padding: EdgeInsets.only(
                              right: size.width - (size.width - 10),
                              left: size.width - (size.width - 10)),
                          child: TabBar(
                            labelStyle: TextStyle(
                                fontStyle: FontStyle.normal,
                                fontFamily: fontFamily,
                                fontSize: 12,
                                color: textBlackColor,
                                fontWeight: FontWeight.bold),
                            controller: _tabController,
                            labelColor: textBlackColor,
                            indicatorColor: primaryColor,
                            tabs: myTabs,
                          ),
                        ),
                        Center(
                          child: [
                            /*category*/
                            GridView.builder(
                                itemCount: list.length == 0 ? 0 : list.length,
                                physics: NeverScrollableScrollPhysics(),
                                //this is for not scrollable
                                primary: true,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleCategoryScreen(
                                                      trendingCategoryData:
                                                          list[index],
                                                      id: 0,
                                                    )));
                                      },
                                      child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin: EdgeInsets.all(4),
                                          child: Card(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin: EdgeInsets.all(8),
                                                      decoration:
                                                          BoxDecoration(),
                                                      child:
                                                          list[index].image ==
                                                                  null
                                                              ? Container()
                                                              : Stack(
                                                                  fit: StackFit
                                                                      .expand,
                                                                  children: [
                                                                    ClipRRect(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              8.0),
                                                                      child:
                                                                          CachedNetworkImage(
                                                                        imageUrl:
                                                                            list[index].image,
                                                                        fit: BoxFit
                                                                            .cover,
                                                                        progressIndicatorBuilder: (context,
                                                                                url,
                                                                                downloadProgress) =>
                                                                            Center(child: CircularProgressIndicator(value: downloadProgress.progress)),
                                                                        errorWidget: (context,
                                                                                url,
                                                                                error) =>
                                                                            Icon(Icons.error),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    list[index].name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: textBlackColor,
                                                        fontFamily: fontFamily),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    )),
                            /*brand*/
                            GridView.builder(
                                itemCount: brand.length <= 0 ? 0 : brand.length,
                                physics: NeverScrollableScrollPhysics(),
                                //this is for not scrollable
                                primary: true,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                ),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    SingleBrandProductScreen(
                                                      brandData: brand[index],
                                                      id: 0,
                                                    )));
                                      },
                                      child: Container(
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: Card(
                                            elevation: 1,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                      margin:
                                                          EdgeInsets.all(4.0),
                                                      child: brand[index]
                                                                  .logo ==
                                                              null
                                                          ? Container()
                                                          : CachedNetworkImage(
                                                              imageUrl:
                                                                  brand[index]
                                                                      .logo,
                                                              fit: BoxFit.cover,
                                                              progressIndicatorBuilder: (context,
                                                                      url,
                                                                      downloadProgress) =>
                                                                  Center(
                                                                      child: CircularProgressIndicator(
                                                                          value:
                                                                              downloadProgress.progress)),
                                                              errorWidget: (context,
                                                                      url,
                                                                      error) =>
                                                                  Icon(Icons
                                                                      .error),
                                                            )),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(8.0),
                                                  child: Text(
                                                    brand[index].name,
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        color: textBlackColor,
                                                        fontFamily: fontFamily,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )),
                                    )),
                            /*shop*/
                            GridView.builder(
                                itemCount: shop.length <= 0
                                    ? 0
                                    : shop.length > 10
                                        ? 10
                                        : shop.length,
                                physics: NeverScrollableScrollPhysics(),
                                //this is for not scrollable
                                primary: true,
                                shrinkWrap: true,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemBuilder: (BuildContext context,
                                        int index) =>
                                    GestureDetector(
                                      onTap: () {
                                        // pushNewScreenWithRouteSettings(
                                        //   context,
                                        //   screen: SingleShopScreen(
                                        //       shopData: shop[index]),
                                        //   withNavBar: true,
                                        //   pageTransitionAnimation:
                                        //       PageTransitionAnimation.cupertino,
                                        //   settings: null,
                                        // );
                                      },
                                      child: Card(
                                        elevation: 1,
                                        color: Colors.white,
                                        margin: EdgeInsets.all(8),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Container(
                                                height: 70,
                                                margin: EdgeInsets.all(8),
                                                width: size.width / 2.2,
                                                // height: 80,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: shop[index].shopLogo ==
                                                        null
                                                    ? Container()
                                                    : CachedNetworkImage(
                                                        imageUrl: shop[index]
                                                            .shopLogo,
                                                        fit: BoxFit.fitHeight,
                                                        progressIndicatorBuilder: (context,
                                                                url,
                                                                downloadProgress) =>
                                                            Center(
                                                                child: CircularProgressIndicator(
                                                                    value: downloadProgress
                                                                        .progress)),
                                                        errorWidget: (context,
                                                                url, error) =>
                                                            Icon(Icons.error),
                                                      )),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            Text(
                                              shop[index].shopName ?? '',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: fontFamily),
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
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontFamily: fontFamily,
                                                  color: textBlackColor),
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
                                              itemSize: 14.0,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 1.0),
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
                                    ))
                          ][tabIndex],
                        ),
                      ],
                    ),
                    Container(
                      height: 130,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        campaignWidget.length > 0
                            ? Container(
                                height: 40,
                                padding: EdgeInsets.all(8),
                                margin: EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _campaignData.length == 0
                                        ? Container()
                                        : MaterialButton(
                                            child: Text(
                                              'رؤية الكل',
                                              style: TextStyle(
                                                  color: secondaryColor,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: fontFamily),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CampaignScreen()));
                                            },
                                          ),
                                    Text(
                                      'كل الحملات',
                                      style: TextStyle(
                                          fontFamily: fontFamily,
                                          fontWeight: FontWeight.bold,
                                          color: textBlackColor),
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                        /*campaign scroll*/
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: campaignWidget,
                          ),
                        ),
                      ],
                    ),
                    /*here the product grid*/
                    //todo:there are grid view
                    Container(
                        height: 60,
                        padding: EdgeInsets.all(14),
                        child: Directionality(
                          textDirection: TextDirection.rtl,
                          child: Text(
                            'المنتجات الرائجة',
                            style: TextStyle(
                                fontFamily: fontFamily,
                                fontWeight: FontWeight.bold,
                                color: textBlackColor),
                          ),
                        )),
                    ProductScreen(shopProductData: shopProductData),
                    Container(
                      height: 130,
                    ),
                  ]),
                ),
              ),
      ),
    );
  }
}
