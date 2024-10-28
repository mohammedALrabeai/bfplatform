import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/campaign.dart';
import 'package:many_vendor_app/model/campaign_item.dart';
import 'package:many_vendor_app/model/cart.dart';
import 'package:many_vendor_app/provider/campaign.item.provider.dart';
import 'package:many_vendor_app/provider/cart_count_provider.dart';
import 'package:many_vendor_app/repository/db_connection.dart';
import 'package:many_vendor_app/screen/loader_screen.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class SingleCampaignScreen extends StatefulWidget {
  CampaignData campaignData;

  SingleCampaignScreen({required this.campaignData});

  @override
  _SingleCampaignScreenState createState() => _SingleCampaignScreenState();
}

class _SingleCampaignScreenState extends State<SingleCampaignScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Data> _data=[];
  bool isLoading = true;

  fetchData() async {
    CampaignItem? campaignItem =
        await Provider.of<CampaignItemProvider>(context, listen: false)
            .hitApi(widget.campaignData.id, context);
    Provider.of<CampaignItemProvider>(context, listen: false)
        .setData(campaignItem!);
    setState(() {
      _data =
          Provider.of<CampaignItemProvider>(context, listen: false).getData();
      isLoading = false;
    });
  }

  DatabaseConnection _databaseConnection = new DatabaseConnection();

  _addToCart(stockId, campaignId, context) async {
    final cart = Cart(vendorStockId: stockId, campaignId: campaignId);
    await _databaseConnection.addToCartWithIncrement(cart);
    Provider.of<CartCount>(context, listen: false).totalQuantity();
    showInSnackBar('تمت الاضافة لعربة التسوق');
  }

  void showInSnackBar(String value) {
    Fluttertoast.showToast(
      msg: value,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
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
    double cellWidth = ((size.width - 29) / (9 / 2));
    double desiredCellHeight = 140;
    double childAspectRatio = cellWidth / desiredCellHeight;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        key: _scaffoldKey,
       // appBar: customAppBar(context),
        body: isLoading
            ? LoaderScreen()
            : _data.length == 0
                ? empty()
                : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('assets/background.png'),
                            fit: BoxFit.cover)),
                    child: RefreshIndicator(
                      onRefresh: () async {
                        return await fetchData();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 20),
                        child: GridView.builder(
                            physics: ScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: _data.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: childAspectRatio,
                              crossAxisCount: 3,
                            ),
                            itemBuilder: (BuildContext context, int index) =>
                                Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    margin: EdgeInsets.only(
                                        left: 8, right: 8, bottom: 20),
                                    child: Card(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                              child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            child: CachedNetworkImage(
                                              imageUrl: _data[index].image,
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
                                          )),
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 4.0, bottom: 6.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  _data[index].name,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      fontFamily: fontFamily,
                                                      color: textBlackColor),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  'المتجر : ' +
                                                      _data[index].shopName,
                                                  textAlign: TextAlign.right,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: textBlackColor,
                                                      fontFamily: fontFamily,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  _data[index].price,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      fontSize: 10,
                                                      color: textBlackColor,
                                                      fontFamily: fontFamily,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ),
                                          /*here are the natok man*/
                                          GestureDetector(
                                            child: Container(
                                              padding: EdgeInsets.all(8),
                                              margin:
                                                  EdgeInsets.only(bottom: 8),
                                              decoration: BoxDecoration(
                                                  color: primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: Text(
                                                'اضافة للسلة',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    fontFamily: fontFamily,
                                                    color: textWhiteColor),
                                              ),
                                            ),
                                            onTap: () {
                                              if (_data[index].vendorStockId ==
                                                  0) {
                                                showModalBottomSheet(
                                                    elevation: elevation,
                                                    backgroundColor:
                                                        Colors.white,
                                                    context: context,
                                                    isScrollControlled: true,
                                                    builder:
                                                        (BuildContext context) {
                                                      var item =
                                                          _data[index].shops;
                                                      return GridView.builder(
                                                          itemCount:
                                                              item.length,
                                                          physics:
                                                              ScrollPhysics(),
                                                          shrinkWrap: true,
                                                          gridDelegate:
                                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                            crossAxisCount: 3,
                                                          ),
                                                          itemBuilder:
                                                              (BuildContext
                                                                      context,
                                                                  int i) {
                                                            return Card(
                                                              margin: EdgeInsets
                                                                  .only(
                                                                      bottom:
                                                                          20,
                                                                      top: 5),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              0.5)),
                                                                  side: BorderSide(
                                                                      width: 2,
                                                                      color: Colors
                                                                          .black45)),
                                                              elevation:
                                                                  elevation,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                children: [
                                                                  Text(
                                                                    item[i]
                                                                        .variant,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        fontFamily:
                                                                            fontFamily,
                                                                        color:
                                                                            textBlackColor),
                                                                  ),
                                                                  Text(
                                                                    item[i]
                                                                        .extraPriceFormat,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            textBlackColor,
                                                                        fontFamily:
                                                                            fontFamily,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  Text(
                                                                    item[i]
                                                                        .totalPriceFormat,
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            12,
                                                                        color:
                                                                            textBlackColor,
                                                                        fontFamily:
                                                                            fontFamily,
                                                                        fontWeight:
                                                                            FontWeight.bold),
                                                                  ),
                                                                  !item[i].stockOut
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            _addToCart(
                                                                                item[i].vendorStockId,
                                                                                _data[index].campaignId,
                                                                                context);
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                EdgeInsets.all(8),
                                                                            margin:
                                                                                EdgeInsets.only(bottom: 8),
                                                                            decoration:
                                                                                BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                                                                            child:
                                                                                Text(
                                                                              'اضافة للسلة',
                                                                              style: TextStyle(fontFamily: fontFamily, color: textWhiteColor),
                                                                            ),
                                                                          ),
                                                                        )
                                                                      : Container(
                                                                          child:
                                                                              Text('Out Off Stock'),
                                                                        ),
                                                                ],
                                                              ),
                                                            );
                                                          });
                                                    });
                                              } else {
                                                _data[index].stockOut
                                                    ? showInSnackBar(
                                                        'انتهت الكمية')
                                                    : _addToCart(
                                                        _data[index]
                                                            .vendorStockId,
                                                        _data[index].campaignId,
                                                        context);
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ))),
                      ),
                    ),
                  ),
      ),
    );
  }
}
