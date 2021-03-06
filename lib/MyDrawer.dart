import 'package:flutter/material.dart';
import 'package:shoppingapp/EditProfile.dart';
import 'package:shoppingapp/MyOrders.dart';

import 'components/oval_right_clipper.dart';
import 'components/themes.dart';

Divider _buildDivider() {
  return Divider(
    color: divider,
  );
}

Widget _buildRow(BuildContext context,IconData icon, String title,int index, {bool showBadge = false}) {

  return GestureDetector(
    onTap: (){
      if(index==0)
        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrders()));
      if(index==2)
        Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfile()));
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
buildDrawer(context){
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
                Center(
                  child: Container(
                    height: 200,
                    width: 200,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('Assets/icons/welcome_logo.png')
                        )
                    ),

                  ),
                ),
                SizedBox(height: 5.0),
                SizedBox(height: 70.0),
                Center(
                  child: Column(
                    children: <Widget>[
                      _buildRow(context,Icons.shopping_bag_rounded,"Your Orders",0),
                      _buildDivider(),
                      _buildRow(context,Icons.share, "Share App",1),
                      _buildDivider(),
                      _buildRow(context,Icons.account_circle, "Edit Profile",2, showBadge: true),
                      _buildDivider(),
                      _buildRow(context,Icons.star, "Rate Us",3,showBadge: true),
                      _buildDivider(),
                      _buildRow(context,Icons.info_outline,"Terms and Conditions",4),
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