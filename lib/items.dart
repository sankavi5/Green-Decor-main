import 'package:cloud_firestore/cloud_firestore.dart';

class Items{
  String? itemID;
  String? itemName;
  String? itemDescription;
  String? itemImage;
  String? itemPrice;
  String? sellerName;
  String? sellerPhone;
  Timestamp? publishedDate;
  String? status;

  Items({
    this.itemID,
    this.itemName,
    this.itemDescription,
    this.itemImage,
    this.itemPrice,
    this.sellerName,
    this.sellerPhone,
    this.publishedDate,
    this.status,
  });

  Items.fromJson(Map<String, dynamic> json)
  {
    itemID = json["itemID"];
    itemName = json["itemName"];
    itemDescription = json["itemDescription"];
    itemImage = json["itemImage"];
    itemPrice = json["itemPrice"];
    sellerName = json["sellerName"];
    sellerPhone = json["sellerPhone"];
    publishedDate = json["publishedDate"];
    status = json["status"];
  }
}