import 'package:cloud_firestore/cloud_firestore.dart';

class OfferModel{
  String title;
  String url;
  String description;
  String price;
  String coupon_code;
  String id;
  OfferModel(QueryDocumentSnapshot d){
    this.title = d['title'];
    this.description = d['description'];
    this.url = d['url'];
    this.price = d['price'];
    this.id = d['id'];
    this.coupon_code = d['coupon'];
  }
  OfferModel.fromJson(Map<String,dynamic> json)
      :title=json['title'],
        url=json['url'],
        description=json['description'],
        coupon_code=json['coupon'],
        id=json['id'],
        price=json['price'];

  Map<String,dynamic> toJson(){
    return {
      "title": this.title,
      "url": this.url,
      "description": this.description,
      "coupon": this.coupon_code,
      "price": this.price,
      "id": this.id
    };
  }
}