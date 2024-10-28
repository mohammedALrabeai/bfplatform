
class Cart{
  int id;
  int vendorStockId;
  int campaignId;
  int quantity;

  Cart({
     this.id=0,
     this.vendorStockId=0,
     this.quantity=0,
     this.campaignId=0});

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'id':id,
       'vendorStockId' : vendorStockId,
       'campaignId' : campaignId,
      'quantity':quantity
    };
  }

}


class Wishlist{
  int id;
  int productId;

  Wishlist({
     this.id=0,
     this.productId=0});

  Map<String, dynamic> toMap(){
    return <String, dynamic>{
      'id':id,
      'productId':productId
    };
  }
}