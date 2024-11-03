

import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:many_vendor_app/helper/helper.dart';
import 'package:many_vendor_app/model/district.dart';
import 'package:http/http.dart' as http;
import 'package:many_vendor_app/model/logistic.dart';


class DistrictProvider extends ChangeNotifier{
  late DistrictClass _districtClass ;

  //= DistrictClass();
  List<DistrictData> list = [];

  DistrictProvider(){
    _districtClass.data = list;
  }

  setData(DistrictClass districtClass){
    _districtClass = districtClass;
    notifyListeners();
  }

  getData(){
   return _districtClass.data;
  }
  Future<LogisticClass> hitApi(d,a) async{
    var response = await http.get(
        Uri.parse(
            baseUrl+'logistic/'+d.toString()+'/'+a.toString()));
   late LogisticClass logisticClass;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      logisticClass = LogisticClass.fromJson(parsed);
    }
    return logisticClass;
  }

  Future<DistrictClass> htiApi()async {
    var response= await http.get(
        Uri.parse(

        baseUrl+'districts'));
   late DistrictClass districtClass;
    if(response.statusCode == 200){
      final Map<String, dynamic> parsed = jsonDecode(response.body.toString());
      districtClass = DistrictClass.fromJson(parsed);
    }
    return districtClass;
  }

}
///>>>>>>>>>>>>>>>


class LogisticProvider extends ChangeNotifier{
 late LogisticClass _logisticClass ;
  //// =  LogisticClass();
  List<LogisticData> list =[];

  LogisticProvider(){
    _logisticClass.data =list;
  }

  setData(LogisticClass logisticClass){
    _logisticClass = logisticClass;
  }


  getData(){
    return _logisticClass.data;
  }


  Future<LogisticClass?> hitApi(d,a) async{
    var response = await http.get(
        Uri.parse(
            baseUrl+'logistic/'+d.toString()+'/'+a.toString()));
    LogisticClass? logisticClass;
    if(response.statusCode == 200){
      final Map parsed = jsonDecode(response.body.toString());
      logisticClass = LogisticClass.fromJson(parsed);
    }
    return logisticClass;
  }
}