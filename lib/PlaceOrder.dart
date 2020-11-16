import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/SavedPage.dart';
import 'package:shoppingapp/components/themes.dart';
import 'package:shoppingapp/models/ProductModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:toast/toast.dart';

import 'components/oval_right_clipper.dart';
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
List<String> addresstype = ["Home Address","Office Address"];
List<String> address = ["Street, City 110000\nXYZ State, India","Street, City 220000\nABC State, India"];
String selectedaddress = addresstype[0];
String addressdetail = address[0];
var total =100;
bool Loading = true;
List<DropdownMenuItem<String>> addressDropDown;
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
    var user = {
      'name': 'My Name',
      'email': 'abcd@gmail.com',
      'phone': '9876543210'
    };
    DocumentReference ref = await databaseReference.collection("orders").add({'products': orderedlist,'quantities': quantity,'address': addressdetail,'user': user}).then((value){
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
  SharedPref sharedPref = new SharedPref();
  loadSharedPref() async {
    try{
      final prefs = await SharedPreferences.getInstance();
      myitems.clear();
      Set<String> set;
      set = prefs.getKeys();
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
                          color: Colors.orangeAccent
                      ),
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
    return WillPopScope(
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Khati Khuwa',
              style: headStyle,
            ),
          ),
          drawer: buildDrawer(),
          body: (Loading==true)?Center(
            child: CircularProgressIndicator(),
          ):(myitems.length==0)?Center(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text("Get Started with your shopping crate by adding products to your cart",style: headStyle1,),
            ),
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
                    Text(addressdetail,style: subStyle,),
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
                  height: 80,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.white,
                  child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: EdgeInsets.only(right: 20),
                        child:  GestureDetector(
                          child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.lightBlueAccent,
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