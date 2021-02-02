import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/HomePage.dart';
import 'package:shoppingapp/Product.dart';
import 'package:shoppingapp/components/themes.dart';
import 'package:shoppingapp/models/ProductModel.dart';
import 'package:shoppingapp/models/SharedPreferences.dart';

import 'MyDrawer.dart';
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
bool loading = true;
class _SavedPageState extends State<SavedPage>{
  SharedPref sharedPref = new SharedPref();
  loadSharedPref() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      items.clear();
      Set<String> set;
      set = prefs.getKeys();
      CollectionReference snapshot = FirebaseFirestore.instance.collection("products");
      for(String value in set)
      {
        print(value);
        if(value!='freshInstall'&&value.startsWith('bookmark'))
        {
          DocumentSnapshot data = await snapshot.doc(value.substring(8)).get();
          if(data!=null&&data.exists)
            {
              print(value);
              print(value.substring(8));
              ProductModel s = ProductModel(data);
              if(!items.contains(s))
                items.add(s);
            }
        }
      }
    } catch (e){
      print(e);
    }
    setState(() {
      loading = false;
    });
  }
  @override
  void initState() {
    items = new List();
    loading = true;
    loadSharedPref();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar,
        drawer: buildDrawer(context),
        body: (loading==true)?Center(
          child: CircularProgressIndicator(),
        ):(items.length==0)?Center(
          child:GestureDetector(
             child:  Padding(
               padding: EdgeInsets.all(10),
               child: Text("Get Started with adding your products to your wish-list as we provide you with more offers and products",style: headStyle1,),
             ),
              onTap: (){
               Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage("All")));
              },
          )
        ):Stack(
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
      onTap: () async {
        bool cart;
        SharedPref pref = new SharedPref();
        dynamic value = await pref.read("cart"+productModel.uniqueId);
        print(value.toString());
        if(value==null||value!=true)
          {
            cart = false;
          }
        else
          {
            cart = true;
          }
        await Navigator.push(context, MaterialPageRoute(builder: (context)=>Product(productModel,cart)));
        setState(() {
        });
      },
    );
  }
  Widget MyChip(String data){
    int index = categories.indexOf(data);
    return Padding(
        padding: EdgeInsets.all(10),
        child: GestureDetector(
          child: Container(
            height: 50,
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