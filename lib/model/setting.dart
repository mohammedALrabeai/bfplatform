
class AppSetting{
   int id;
  final String type;
  final String value;

  AppSetting({this.id=0,
    required this.type,
    required this.value});

  Map<String, dynamic> toMap(){
    return <String,dynamic>{
      "id":id,
      'type':type,
      'value':value,
    };
  }

}