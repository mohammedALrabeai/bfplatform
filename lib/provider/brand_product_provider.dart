
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/shop_product.dart';
import 'package:many_vendor_app/screen/server_error_screen.dart';

class BrandProductProvider extends ChangeNotifier{
  ShopProductHub _shopProductHub = new ShopProductHub();
  List<ShopProductData> list = [];

  BrandProductProvider(){
    _shopProductHub.data = list;
  }

  setData(ShopProductHub shopProductHub){
    _shopProductHub = shopProductHub;
    notifyListeners();
  }

  getData(){
    return _shopProductHub.data;
  }

  Future<ShopProductHub?> hitApi(id,context) async{
    ShopProductHub? shopProductHub;
    try{
      var response = await http.get(Uri.parse(baseUrl+'brand/$id'));

      if(response.statusCode ==200){
        final Map parsed = jsonDecode(response.body.toString());
        shopProductHub =ShopProductHub.fromJson(parsed);

      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
      }

    }catch (e){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
    }
    return shopProductHub;
  }
}