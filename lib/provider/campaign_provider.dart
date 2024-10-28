
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/campaign.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_app/screen/server_error_screen.dart';


class CampaignProvider extends ChangeNotifier{
  bool isLoading = true;
    CampaignClass _campaign = new CampaignClass();


    setData(CampaignClass campaign){
      _campaign = campaign;
      isLoading = false;
      notifyListeners();
    }

    getData(){
      return _campaign.data;
    }

    Future<CampaignClass?> campaignHitApi(context) async{
      CampaignClass? campaign;
      try{
        var response = await http.get(
            Uri.parse(
            baseUrl+'campaigns'));

        if(response.statusCode == 200){
          final Map parsed  = jsonDecode(response.body.toString());
          campaign = CampaignClass.fromJson(parsed);

        }else{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
        }
      }catch (e){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
      }
      return campaign;
    }

}