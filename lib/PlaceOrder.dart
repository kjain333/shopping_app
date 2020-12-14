import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/EditProfile.dart';
import 'package:shoppingapp/HomePage.dart';
import 'package:shoppingapp/components/themes.dart';
import 'package:shoppingapp/constants.dart';
import 'package:shoppingapp/models/OfferModel.dart';
import 'package:shoppingapp/models/ProductModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:toast/toast.dart';
import 'models/SharedPreferences.dart';

class PlaceOrder extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _PlaceOrder();
  }
}
//List<String> orderlist = ["Traditional Assamese Jewellery","Traditional Assamese Jewellery"];
List<int> quantity;
List<ProductModel> myitems;
List<String> addresstype = ["Home Address"];
List<String> address = ["Street, City 110000\nXYZ State, India"];
String selectedaddress = addresstype[0];
String addressdetail = address[0];
var total =100;
bool Loading = true;
List<DropdownMenuItem<String>> addressDropDown;
List<DropdownMenuItem<String>> offersDropDown;
List<OfferModel> offers = new List();
List<String> offerNames = new List();
OfferModel selectedoffer;
String selectedoffername = "";
class _PlaceOrder extends State<PlaceOrder>{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final databaseReference = Firestore.instance;
  List<DropdownMenuItem<String>> buildDropDownMenuItems(categoryList) {
    List<DropdownMenuItem<String>> items = List();
    for (String category in categoryList) {
      items.add(DropdownMenuItem(
        value: category,
        child: Text(category),
      ));
    }
    return items;
  }
  void DeleteProduct(String id) async {
    final prefs = SharedPreferences.getInstance();
    await sharedPref.remove(id);
    setState(() {
      Loading = false;
    });
  }
  void createOrder() async {
    List orderedlist = new List();
    for(int i=0;i<myitems.length;i++)
      {
        orderedlist.add(myitems[i].toJson());
      }
    final prefs = await SharedPreferences.getInstance();
    var user = {
      'name': prefs.get('name'),
      'email': prefs.get('email'),
      'phone': prefs.get('mobile'),
    };
    DocumentReference ref = await databaseReference.collection("orders").add({'products': orderedlist,'quantities': quantity,'address': addressdetail,'user': user,'coupon': selectedoffer.coupon_code}).then((value){
      Toast.show("Order Placed Successfully", context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM,textColor: Colors.white,backgroundColor: Colors.green,);
      setState(() {
        Loading = false;
      });
      return null;
    },onError: (error){
      setState(() {
        Loading = false;
      });
      Toast.show(error.toString(), context,duration: Toast.LENGTH_LONG,gravity: Toast.BOTTOM,textColor: Colors.white,backgroundColor: Colors.red,);
    });
  }
  onChangeDropDownItem(String item) {
    setState(() {
      selectedaddress = item;
      for(int i=0;i<addresstype.length;i++)
        {
          if(item==addresstype[i])
            {
              addressdetail=address[i];
              break;
            }
        }
    });
  }
  onChangeDropDownItem1(String item) {
    total+=int.parse(selectedoffer.price);
    setState(() {
      selectedoffername = item;
      selectedoffer = offers[offerNames.indexOf(item)];
      total-=int.parse(selectedoffer.price);
    });
  }
  SharedPref sharedPref = new SharedPref();
  loadSharedPref() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      address[0] = await prefs.get('address');
      addressdetail = address[0];
      myitems.clear();
      Set<String> set;
      set = prefs.getKeys();
      offers.clear();
      List<dynamic> json = jsonDecode(prefs.getString('offers'));
      for(int i=0;i<json.length;i++)
        {
          offers.add(OfferModel.fromJson(json[i]));
        }
      OfferModel defaultOffer = OfferModel.fromJson({
        'title': 'None',
        'price': '0',
        'description': 'None',
        'url': 'none',
        'id': 'none',
        'coupon': 'none',
      });
      offers.insert(0, defaultOffer);
      offerNames.clear();
      for(int i=0;i<offers.length;i++)
      {
        offerNames.add(offers[i].title);
      }
      offersDropDown = buildDropDownMenuItems(offerNames);
      selectedoffer = offers[0];
      selectedoffername = selectedoffer.title;

      total-=int.parse(selectedoffer.price);
      for(String value in set)
      {
        if(value!='freshInstall'&&value.startsWith('cart'))
        {
          ProductModel s = ProductModel.fromJson(await sharedPref.read(value));
          if(!myitems.contains(s))
            {
              myitems.add(s);
              quantity.add(1);
              total+=int.parse(s.price);
            }
        }
      }
    } catch (e){
      print(e);
    }
    setState(() {
      Loading = false;
    });
  }
  @override
  void initState() {
    addressDropDown = buildDropDownMenuItems(addresstype);
    myitems = new List();
    quantity = new List();
    loadSharedPref();
    total=100;
    print(_auth.currentUser);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 20,
              color: Colors.white,
              onPressed: (){
                Navigator.pop(context,(){
                  setState(() {
                  });
                });
              },
            ),
            title: Text(
              'Khati Khuwa',
              style: headStyle,
            ),
          ),
          body: (Loading==true)?Center(
            child: CircularProgressIndicator(),
          ):(myitems.length==0)?Center(
            child: GestureDetector(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Text("Get Started with your shopping crate by adding products to your cart",style: headStyle1,),
              ),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage("All")));
              },
            )
          ):Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child:  Text("CHECKOUT ITEMS",style: style2,),
                    ),
                    Column(
                      children: myitems.map((e) => MyTile(e)).toList(),
                    ),
                    Center(
                      child:  Text("SHIPPING",style: style2,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Colors.grey),
                        ),
                        child: Padding(
                          padding:
                          EdgeInsets.only(left: 40, right: 40,top: 10,bottom: 10),
                          child: DropdownButton(
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            hint: Text("Select Category"),
                            isExpanded: true,
                            value: selectedaddress,
                            items: addressDropDown,
                            onChanged: onChangeDropDownItem,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        width: MediaQuery.of(context).size.width-50,
                        child:  Text(addressdetail,style: subStyle,),
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        iconSize: 20,
                        onPressed: () async {
                          await Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProfile()));
                          loadSharedPref();
                          setState(() {
                          });
                        },
                      ),
                    ),
                    Center(
                      child:  Text("Offers",style: style2,),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20, vertical: 20),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                              color: Colors.grey),
                        ),
                        child: Padding(
                          padding:
                          EdgeInsets.only(left: 40, right: 40,top: 10,bottom: 10),
                          child: DropdownButton(
                            iconEnabledColor: Colors.black,
                            iconDisabledColor: Colors.black,
                            hint: Text("Select Offer"),
                            isExpanded: true,
                            value: selectedoffername,
                            items: offersDropDown,
                            onChanged: onChangeDropDownItem1,
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        width: MediaQuery.of(context).size.width-50,
                        child:  Text("Selected Offer Code: "+selectedoffer.coupon_code,style: subStyle,),
                      ),
                    ),
                    ListTile(
                      title: Container(
                        width: MediaQuery.of(context).size.width-50,
                        child:  Text("Selected Discount amount: Rs. "+selectedoffer.price+"/-",style: subStyle,),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child:  Text("COURIER",style: style2,),
                    ),
                    Padding(
                      padding: EdgeInsets.all(20),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey)
                        ),
                        child: ListTile(
                          title: Text("Regular Service(10 days)",style: style2,),
                          trailing: Text("Rs. 100",style: subStyle,),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 100,
                    )
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 100,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child:  GestureDetector(
                          child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: kPrimaryColor,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(10),
                                child: Wrap(
                                  children: <Widget>[
                                    Text("Place Order:\nRs. "+total.toString(),style: style3,),
                                    SizedBox(
                                      width: 30,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 10,bottom: 10),
                                      child: Icon(Icons.arrow_forward_ios,color: Colors.white,size: 20,),
                                    )
                                  ],
                                ),
                              )
                          ),
                          onTap: (){
                              setState(() {
                                Loading = true;
                                createOrder();
                              });
                          },
                        ),
                      )
                  ),
                ),
              )
            ],
          )
      ),
      onWillPop: () async{
        Navigator.pop(context,(){
          setState(() {
          });
        });
        return true;
      },
    );
  }
  Widget MyTile(ProductModel productModel)
  {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Container(
        width: MediaQuery.of(context).size.width-40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: <Widget>[
            Padding(
              child: Container(
                height: 70,
                width: 70,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    image: DecorationImage(
                      image: NetworkImage(productModel.url),
                      fit: BoxFit.fill,
                    )
                ),
              ),
              padding: EdgeInsets.all(10),
            ),
            Padding(
              child: Container(
                width: MediaQuery.of(context).size.width-180,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(productModel.title,style: style2,),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Price: Rs. "+productModel.price+"/-",style: subStyle,),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                          GestureDetector(
                            child: Icon(Icons.remove),
                            onTap: (){
                              setState(() {
                                if(quantity[myitems.indexOf(productModel)]!=1)
                                {
                                  quantity[myitems.indexOf(productModel)]--;
                                  total-=int.parse(productModel.price);
                                }

                              });
                            },
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Quantity: "+quantity[myitems.indexOf(productModel)].toString(),style: subStyle,),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: Icon(Icons.add),
                          onTap: (){
                            setState(() {
                              quantity[myitems.indexOf(productModel)]++;
                              total+=int.parse(productModel.price);
                            });
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
              padding: EdgeInsets.all(0),
            ),
            IconButton(icon: Icon(Icons.delete), onPressed: (){
              setState(() {
                Loading = true;
                total-=int.parse(productModel.price)*quantity[myitems.indexOf(productModel)];
                DeleteProduct('cart'+productModel.id);
                quantity.removeAt(myitems.indexOf(productModel));
                myitems.remove(productModel);
              });
            })
          ],
        ),
      ),
    );
  }
}