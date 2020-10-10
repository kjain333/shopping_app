import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/components/themes.dart';

import 'Product.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}
int selectedIndex = 0;
List<String> categories = ["All","Traditional Clothes","Jewellery","Pickles","Spices","Hand Craft","Food Items","Daily Needs"];
List<bool> bookmarked;
List<bool> cart;
List<int> items;
class _HomePageState extends State<HomePage>{
  @override
  void initState() {
    bookmarked = new List(50);
    items = new List(50);
    cart = new List(50);
    for(int i=0;i<50;i++)
      {
        bookmarked[i]=false;
        cart[i]=false;
        items[i]=i;
      }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            top: 200,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height-250,
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    height: MediaQuery.of(context).size.height-360,
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
  Widget MyData(int i){
      return GestureDetector(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              color: Colors.white
          ),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10,top: 10),
                    child: (bookmarked[i])?Icon(Icons.bookmark):Icon(Icons.bookmark_border),
                  ),
                  onTap: (){
                    setState(() {
                      bookmarked[i]=!bookmarked[i];
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
                        image: AssetImage("Assets/Images/jewellery.png"),
                        fit: BoxFit.fill,
                      )
                  ),
                ),
              ),
              ListTile(
                title: Text("Assamese Traditional Jewellery",style: style2,),
                subtitle: Text("Price: Rs. 800/-",style: subStyle,),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(right: 10,bottom: 10),
                    child: (cart[i])?Icon(Icons.remove):Icon(Icons.add),
                  ),
                  onTap: (){
                    setState(() {
                      cart[i]=!cart[i];
                    });
                  },
                ),
              ),
            ],
          ),
        ),
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Product()));
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