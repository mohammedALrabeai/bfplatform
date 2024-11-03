
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/brand.dart';
import 'package:many_vendor_app/screen/server_error_screen.dart';

class BrandProvider extends ChangeNotifier{
  bool isLoading = true;
  BrandClass? _brand ;

  setData(BrandClass brand){
    _brand = brand;
    isLoading = false;
    notifyListeners();
  }

  getData(){
    return _brand!.data;
  }

 Future<BrandClass>  brandHitApi(context) async{
   late BrandClass brand;
    try{

      var response = await http.get(

          Uri.parse(
          baseUrl+'brands'));

      if(response.statusCode == 200){
        final Map<String, dynamic> parsed = jsonDecode(response.body.toString());
        brand = (BrandClass.fromJson(parsed
        ));

      }else{
        Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
      }

    }catch (e){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ServerError()));
    }
   return brand;
  }
}