import 'package:cloud_firestore/cloud_firestore.dart';
class ProductModel{
  String title;
  String subtitle;
  String url;
  String description;
  List<String> categories;
  String price;
  String id;
  ProductModel(QueryDocumentSnapshot d){
    this.title = d['title'];
    this.subtitle = d['subtitle'];
    this.description = d['description'];
    this.url = d['url'];
    this.price = d['price'];
    this.id = d['id'];
    List<String> mycategories = new List();
    for(int i=0;i<d['categories'].length;i++)
    {
      mycategories.add((d['categories'][i]).toString());
    }
    this.categories = mycategories;
  }
  ProductModel.fromJson(Map<String,dynamic> json)
      :title=json['title'],
       subtitle=json['subtitle'],
       url=json['url'],
       description=json['description'],
       categories=getcategories(json['categories']),
       id=json['id'],
       price=json['price'];

  Map<String,dynamic> toJson(){
    return {
      "title": this.title,
      "subtitle": this.subtitle,
      "url": this.url,
      "description": this.description,
      "categories": this.categories,
      "price": this.price,
      "id": this.id
    };
  }
}
List<String> getcategories(List<dynamic> a){
  List<String> mycategories = new List();
  for(int i=0;i<a.length;i++)
  {
    mycategories.add((a[i]).toString());
  }
  return mycategories;
}