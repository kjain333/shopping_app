import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/PlaceOrder.dart';
import 'package:shoppingapp/components/themes.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shoppingapp/models/ProductModel.dart';
import 'package:shoppingapp/models/SharedPreferences.dart';
import 'MyDrawer.dart';
import 'Product.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}
int selectedIndex = 0;
List<String> categories = ["All","Traditional Clothes","Jewellery","Pickles","Spices","Hand Craft","Food Items","Daily Needs"];
List<QueryDocumentSnapshot> data;
bool expanded = false;
List<bool> bookmark;
List<bool> cart;
class _HomePageState extends State<HomePage>{
  SharedPref sharedPref = new SharedPref();
  final databaseReference = Firestore.instance;
  @override
  void initState() {
    data = new List();
    bookmark = new List();
    cart = new List();
    Loading = true;
    super.initState();
  }
  void GetBookMarks() async {
    bookmark = new List();
    cart = new List();
    Set<String> set = new Set<String>();
    final prefs = await SharedPreferences.getInstance();
    set = prefs.getKeys();
    for(int i=0;i<data.length;i++) {
      if (set.contains('bookmark'+data[i]['id'])) {
        bookmark.add(true);
      }
      else
        bookmark.add(false);
      if(set.contains('cart'+data[i]['id'])){
        cart.add(true);
      }
      else
        cart.add(false);
    }
    setState(() {
      Loading = false;
    });
  }
  void ChangeBookMark(QueryDocumentSnapshot querydata) async {
    ProductModel saved = new ProductModel(querydata);
    if(bookmark[data.indexOf(querydata)]==false)
      await sharedPref.save('bookmark'+querydata['id'], saved);
    else
      await sharedPref.remove('bookmark'+querydata['id']);
  }
  void ChangeCart(QueryDocumentSnapshot querydata) async {
    ProductModel saved = new ProductModel(querydata);
    if(cart[data.indexOf(querydata)]==false)
      await sharedPref.save('cart'+querydata['id'], saved);
    else
      await sharedPref.remove('cart'+querydata['id']);
  }
  bool Loading = true;
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
      drawer: buildDrawer(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.shopping_cart),
        onPressed: () async{
          Navigator.push(context, MaterialPageRoute(builder: (context)=>PlaceOrder())).whenComplete((){
            setState(() {
              Loading = true;
              GetBookMarks();
            });
          });
        },
      ),
      body: FutureBuilder(
        future: databaseReference.collection("products").get(),
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
          if((snapshot.connectionState==ConnectionState.done))
            {
              if(Loading==true)
                {
                  data = (snapshot.data.docs);
                  GetBookMarks();
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

              return Stack(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    color: active,
                    child: Column(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.all(30),
                            child: Container(
                              height: 60,
                              width: MediaQuery.of(context).size.width-60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: selected,
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
                                      children: data.map((e) => MyData(e)).toList(),
                                    ),
                                  )
                              )
                            ],
                          )
                      )
                  )
                ],
              );
            }
          else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      )
    );
  }
  Widget MyData(QueryDocumentSnapshot querydata){
      int flag=0;
      for(int i=0;i<querydata['categories'].length;i++)
        {
          if(querydata['categories'][i]==categories[selectedIndex])
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
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10,top: 10),
                    child: (bookmark[data.indexOf(querydata)])?Icon(Icons.bookmark):Icon(Icons.bookmark_border),
                  ),
                  onTap: () {
                    setState((){
                      Loading = true;
                      ChangeBookMark(querydata);
                    });
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(20),
                child: Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(querydata['url']),
                        fit: BoxFit.fill,
                      )
                  ),
                ),
              ),
              ListTile(
                title: Text(querydata['title'],style: style2,),
                subtitle: Text("Price: Rs. "+querydata['price']+"/-",style: subStyle,),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10,bottom: 10),
                    child: (cart[data.indexOf(querydata)])?Icon(Icons.remove):Icon(Icons.add),
                  ),
                  onTap: (){
                    setState((){
                      Loading = true;
                      ChangeCart(querydata);
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Product(ProductModel(querydata)))).whenComplete((){
            setState(() {
              Loading = true;
              GetBookMarks();
            });
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
            color: (selectedIndex==index)?selected:active,
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