import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/Product.dart';
import 'package:shoppingapp/components/themes.dart';
import 'package:shoppingapp/models/ProductModel.dart';
import 'package:shoppingapp/models/SharedPreferences.dart';

import 'components/oval_right_clipper.dart';

class SavedPage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _SavedPageState();
  }
}
int selectedIndex = 0;
List<String> categories = ["All","Traditional Clothes","Jewellery","Pickles","Spices","Hand Craft","Food Items","Daily Needs"];
List<ProductModel> items;
bool expanded = false;
class _SavedPageState extends State<SavedPage>{
  SharedPref sharedPref = new SharedPref();
  loadSharedPref() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      items.clear();
      Set<String> set;
      set = prefs.getKeys();
      for(String value in set)
      {
        if(value!='freshInstall'&&value.startsWith('bookmark'))
        {
          ProductModel s = ProductModel.fromJson(await sharedPref.read(value));
          if(!items.contains(s))
            items.add(s);
        }
      }
    } catch (e){
      print(e);
    }
    setState(() {
    });
  }
  @override
  void initState() {
    items = new List();
    loadSharedPref();
    super.initState();
  }
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Khati Khuwa',
            style: headStyle,
          ),
          actions: [
            IconButton(icon: Icon(Icons.search_rounded), onPressed: (){
              setState(() {
                expanded = !expanded;
              });
            })
          ],
        ),
        drawer: buildDrawer(),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.deepOrangeAccent,
              child: Column(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.all(30),
                      child: Container(
                        height: 60,
                        width: MediaQuery.of(context).size.width-60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.orangeAccent,
                        ),
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Icon(Icons.search,size: 30,color: Colors.white,),
                            ),
                            Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width-120,
                              child: Padding(
                                padding: EdgeInsets.all(0),
                                child: TextField(
                                  style: style1,
                                  decoration: InputDecoration(
                                    hintText: "Search",
                                    hintStyle: style1,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(color: Colors.transparent)
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      )
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 20,right: 20),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((e) => MyChip(e)).toList(),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Positioned(
                top: (expanded)?200:0,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height-((expanded)?250:0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Column(
                      children: <Widget>[
                        Container(
                            height: MediaQuery.of(context).size.height-((expanded)?360:150),
                            width: MediaQuery.of(context).size.width,
                            child: SingleChildScrollView(
                              child: Wrap(
                                children: items.map((e) => MyData(e)).toList(),
                              ),
                            )
                        )
                      ],
                    )
                )
            )
          ],
        )
    );
  }
  Widget MyData(ProductModel productModel){
    int flag=0;
    for(int i=0;i<productModel.categories.length;i++)
    {
      if(productModel.categories[i]==categories[selectedIndex])
      {
        flag=1;
        break;
      }
    }
    return (flag==0)?Container(height: 0,width: 0,):GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width/2,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            color: Colors.white
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                height: 150,
                width: 150,
                decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(productModel.url),
                      fit: BoxFit.fill,
                    )
                ),
              ),
            ),
            ListTile(
              title: Text(productModel.title,style: style2,),
              subtitle: Text("Price: Rs. "+productModel.price+"/-",style: subStyle,),
            ),
           /* Align(
              alignment: Alignment.bottomRight,
              child: GestureDetector(
                child: Padding(
                  padding: EdgeInsets.only(right: 10,bottom: 10),
                  child: (cart[items.indexOf(productModel)])?Icon(Icons.remove):Icon(Icons.add),
                ),
                onTap: (){
                  setState(() {
                    cart[items.indexOf(productModel)]=!cart[items.indexOf(productModel)];
                  });
                },
              ),
            ),*/
          ],
        ),
      ),
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>Product(productModel)));
      },
    );
  }
  Widget MyChip(String data){
    int index = categories.indexOf(data);
    return Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          child: Container(
            height: 40,
            decoration: BoxDecoration(
              color: (selectedIndex==index)?Colors.orangeAccent:Colors.deepOrangeAccent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Text(data,style: (selectedIndex==index)?style1:subStyle,),
            ),
          ),
          onTap: (){
            setState(() {
              selectedIndex=index;
            });
          },
        )
    );
  }
}