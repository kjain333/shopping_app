import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/components/themes.dart';

import 'components/oval_right_clipper.dart';

class PlaceOrder extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _PlaceOrder();
  }
}
List<String> orderlist = ["Traditional Assamese Jewellery","Traditional Assamese Jewellery"];
List<int> quantity = [1,1];
List<String> addresstype = ["Home Address","Office Address"];
List<String> address = ["Street, City 110000\nXYZ State, India","Street, City 220000\nABC State, India"];
String selectedaddress = addresstype[0];
String addressdetail = address[0];
List<DropdownMenuItem<String>> addressDropDown;
List<int> index = [0,1];
class _PlaceOrder extends State<PlaceOrder>{
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
  @override
  void initState() {
    addressDropDown = buildDropDownMenuItems(addresstype);
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
                children: <Widget>[
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child:  Text("CHECKOUT ITEMS",style: style2,),
                  ),
                  Column(
                    children: index.map((e) => MyTile(e)).toList(),
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
                    child:  Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.lightBlueAccent,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: Wrap(
                            children: <Widget>[
                              Text("Place Order:\nRs. 1700",style: style3,),
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
                  )
                ),
              ),
            )
          ],
        )
    );
  }
  Widget MyTile(int index)
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
                      image: AssetImage("Assets/Images/jewellery.png"),
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
                    Text("Traditional Assamese Jewellery",style: style2,),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Price: Rs. 800/-",style: subStyle,),
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
                                if(quantity[index]!=1)
                                quantity[index]--;
                              });
                            },
                          ),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Quantity: "+quantity[index].toString(),style: subStyle,),
                        SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          child: Icon(Icons.add),
                          onTap: (){
                            setState(() {
                              quantity[index]++;
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
            Padding(
              child: Container(
                width: 20,
                child: GestureDetector(
                  child: Icon(Icons.delete,size: 20,),
                  onTap: (){
                    setState(() {
                      orderlist.removeAt(0);
                    });
                  },
                ),
              ),
              padding: EdgeInsets.all(10),
            )
          ],
        ),
      ),
    );
  }
}