import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_app/helper/appbar.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/campaign.dart';
import 'package:many_vendor_app/provider/campaign_provider.dart';
import 'package:many_vendor_app/screen/loader_screen.dart';
import 'package:many_vendor_app/screen/single.campaign.screen.dart';
import 'package:provider/provider.dart';

class CampaignScreen extends StatefulWidget {
  @override
  _CampaignScreenState createState() => _CampaignScreenState();
}

class _CampaignScreenState extends State<CampaignScreen> {
  List<CampaignData> campaignData = [];
  bool isLoading = true;
  @override
  void initState() {
    statusCheck(context);
    setState(() {
      campaignData =
          Provider.of<CampaignProvider>(context, listen: false).getData();
      isLoading = false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 120) / 2;
    final double itemWidth = size.width / 2;
    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white,
      appBar: customAppBar(context),
      body: isLoading
          ? LoaderScreen()
          : Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/background.png'),
                      fit: BoxFit.cover)),
              child: GridView.builder(
                  itemCount: campaignData.length == 0 ? 0 : campaignData.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: itemWidth / itemHeight,
                    crossAxisCount: 2,
                  ),
                  itemBuilder: (BuildContext context, int index) =>
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SingleCampaignScreen(
                                        campaignData: campaignData[index],
                                      )));
                        },
                        child: Card(
                          elevation: elevation,
                          child: Container(
                              color: Colors.white,
                              margin: EdgeInsets.all(8),
                              width: size.width / 3.4,
                              height: size.height / 4,
                              child: CachedNetworkImage(
                                imageUrl: campaignData[index].banner,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) => Center(
                                        child: CircularProgressIndicator(
                                            value: downloadProgress.progress)),
                                errorWidget: (context, url, error) =>
                                    Icon(Icons.error),
                              )),
                        ),
                      )),
            ),
    ));
  }
}
