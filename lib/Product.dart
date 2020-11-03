import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/models/ProductModel.dart';
import 'package:shoppingapp/models/SharedPreferences.dart';
import 'package:toast/toast.dart';
import 'components/oval_right_clipper.dart';
import 'components/themes.dart';

class Product extends StatefulWidget{
  ProductModel document;
  Product(this.document);
  @override
  State<StatefulWidget> createState() {
    return _Product(document);
  }
}
bool Loading = false;
class _Product extends State<Product>{
  void AddtoCart(ProductModel p) async{
    final prefs = SharedPreferences.getInstance();
    SharedPref sharedPref = new SharedPref();
    await sharedPref.save('cart'+p.id,p);
    Toast.show("PRODUCT ADDED SUCCESSFULLY", context,backgroundColor: Colors.green,textColor: Colors.white,duration: Toast.LENGTH_LONG);
    setState(() {
      Loading = false;
    });
  }
  ProductModel document;
  _Product(this.document);
  List<String> categories = new List();
  @override
  void initState() {
    for(int i=0;i<document.categories.length;i++)
    categories.add(document.categories[i].toString());
    Loading = false;
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Divider _buildDivider() {
      return Divider(
        color: divider,
      );
    }

    Widget _buildRow(IconData icon, String title,int index, {bool showBadge = false}) {

      return GestureDetector(
        onTap: (){
          return null;
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Row(children: [
            Icon(
              icon,
              color: active,
            ),
            SizedBox(width: 10.0),
            Text(
              title,
              style: subStyle,
            ),
          ]),
        ),
      );
    }
    buildDrawer(){
      return ClipPath(
        clipper: OvalRightBorderClipper(),
        child: Drawer(
          child: Container(
            padding: const EdgeInsets.only(left: 16.0, right: 40),
            decoration: BoxDecoration(
                color: primary, boxShadow: [BoxShadow(color: Colors.black45)]),
            width: 300,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 90,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.orangeAccent),
                      child: CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage("https://flutter.io/images/catalog-widget-placeholder.png"),//AssetImage("assets/images/app_logo.png"),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Text("@instagram_handle",style: subStyle),
                    ),
                    SizedBox(height: 5.0),
                    SizedBox(height: 70.0),
                    Center(
                      child: Column(
                        children: <Widget>[
                          _buildRow(Icons.share, "Share App",1),
                          _buildDivider(),
                          _buildRow(Icons.account_circle, "Edit Profile",2, showBadge: true),
                          _buildDivider(),
                          _buildRow(Icons.star, "Rate Us",3,showBadge: true),
                          _buildDivider(),
                          _buildRow(Icons.info_outline,"Terms and Conditions",4),
                          _buildDivider(),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Khati Khuwa',
          style: headStyle,
        ),
      ),
      drawer: buildDrawer(),
      body: (Loading)?Center(
        child: CircularProgressIndicator(),
      ):Stack(
        children: <Widget>[
          Container(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(document.url),
                          fit: BoxFit.fill,
                        )
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text(document.title,style: headStyle1,),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Wrap(
                      children: categories.map((e) => MyChip(e)).toList(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20,right: 20),
                    child: Text(document.subtitle,style: subStyle,),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text("Price: Rs. "+document.price+"/-",style: headStyle1,),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Text("Description",style: style2,),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(document.description,style: subStyle,),
                  ),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
            height: MediaQuery.of(context).size.height-80,
            width: MediaQuery.of(context).size.width,
          ),
          Positioned(
            bottom: 0,
            child: GestureDetector(
              child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight: Radius.circular(50)),
                      color: Colors.lightBlueAccent
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: SizedBox(),
                      ),
                      Text("Add to Cart",style: style3,),
                      SizedBox(
                        width: 20,
                      ),
                      Icon(Icons.add_shopping_cart,color: Colors.white,),
                      Expanded(
                        child: SizedBox(),
                      )
                    ],
                  )
              ),
              onTap: (){
                setState(() {
                  Loading = true;
                  AddtoCart(document);
                });
              },
            )
          )
        ],
      )
    );
  }
  Widget MyChip(String data){
    return Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: selected,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(data,style: style1,),
            ),
          ),
          onTap: (){
            return null;
          },
        )
    );
  }
}