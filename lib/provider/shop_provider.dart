
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/shop.dart';
import 'package:many_vendor_app/screen/server_error_screen.dart';

class ShopProvider extends ChangeNotifier{
  bool isLoading = true;
  ShopHub _shopHub = new ShopHub();
  List<ShopData> list = new List();

  ShopProvider(){
    _shopHub.data = list;
  }

  setData(ShopHub shopHub){
    _shopHub = shopHub;
    isLoading = false;
    notifyListeners();
  }

  getData(){
    return _shopHub.data;
  }

  Future<ShopHub> hitApi(context) async{
    ShopHub shopHub;
    try{
      var response = await http.get(baseUrl+'shops');

      if(response.statusCode == 200){
        final Map parsed = jsonDecode(response.body.toString());
        shopHub = ShopHub.fromJson(parsed);
      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
      }

    }catch (e){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
    }
    return shopHub;
  }
}