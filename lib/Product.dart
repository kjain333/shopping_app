import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/oval_right_clipper.dart';
import 'components/themes.dart';

class Product extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _Product();
  }
}
List<String> categories = ["Jewellery","Traditional","Clothing"];
class _Product extends State<Product>{
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
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("Assets/Images/jewellery.png"),
                        fit: BoxFit.fill,
                      )
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Traditional Assamese Jewellery",style: headStyle1,),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Wrap(
                      children: categories.map((e) => MyChip(e)).toList(),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20,right: 20),
                  child: Text("Traditional Assamese jewelery is in great demand. Designed in Jaapi and plated with gold this is one of the best sellers in north-east market",style: subStyle,),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Price: Rs. 800/-",style: headStyle1,),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text("Description",style: style2,),
                ),
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("1) Easy to wear\n\n2) Gold-Plated\n\n3) Jaapi Design\n\n",style: subStyle,),
                ),
              ],
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height-130,
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