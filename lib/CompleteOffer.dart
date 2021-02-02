import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/themes.dart';

class CompleteOffer extends StatelessWidget{
  QueryDocumentSnapshot e;
  CompleteOffer(this.e);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 300,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(e.get('url')),
                    fit: BoxFit.fill,
                  )
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Discount: Rs. "+e.get('price')+"/-",style: headStyle1,),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Description",style: style2,),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(e.get('description'),style: subStyle,),
            ),
            SizedBox(
              height: 20,
            ),
            Center(
              child: Text("Promo Code",style: style2,),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(e.get('coupon'),style: subStyle,),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }

}