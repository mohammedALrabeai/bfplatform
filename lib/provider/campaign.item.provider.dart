
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/campaign_item.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_app/screen/server_error_screen.dart';

class CampaignItemProvider extends ChangeNotifier{
  CampaignItem _campaignItem = new CampaignItem();

  setData(CampaignItem item){
    _campaignItem = item;
    notifyListeners();
  }

  getData(){
    return _campaignItem.data;
  }

  Future<CampaignItem?> hitApi(id,context) async{
    CampaignItem? campaignItem;
    try{
      var response = await http.get(
          Uri.parse(
          baseUrl+'campaign/'+id.toString()));

      if(response.statusCode == 200){
        final Map parsed = jsonDecode(response.body.toString());
        campaignItem = CampaignItem.fromJson(parsed);

      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
      }

    }catch(e){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
    }
    return campaignItem;
  }

}