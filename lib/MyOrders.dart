import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'components/themes.dart';

class MyOrders extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _MyOrders();
  }
}
bool loading = true;
List<QueryDocumentSnapshot> orders;
List<List<String>> products;
List<List<String>> quantities;
class _MyOrders extends State<MyOrders>{
  Future<void> fetchOrders() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("orders").get();
    List<QueryDocumentSnapshot> doc = snapshot.docs;
    products.clear();
    quantities.clear();
    for(int i=0;i<doc.length;i++)
      {
        if(doc[i].data().containsKey('user'))
          {
            if(doc[i].data()['user'].containsKey('userId'))
              {
                if(doc[i].data()['user']['userId']==auth.currentUser.uid)
                  {
                    orders.add(doc[i]);
                    products.add(new List());
                    quantities.add(new List());
                    for(int j=0;j<doc[i]['products'].length;j++)
                    {
                      products[orders.length-1].add(doc[i]['products'][j]['title'].toString());
                      quantities[orders.length-1].add(doc[i]['quantities'][j].toString());
                    }
                  }
              }
          }
      }
    setState(() {
      loading = false;
    });
  }
  @override
  void initState() {
    loading = true;
    orders = new List();
    products = new List();
    quantities = new List();
    fetchOrders();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1(context),
      body: loading?Center(
        child: CircularProgressIndicator(),
      ):(orders.length==0)?Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text("You have not placed any orders till now!\nGet Started with your shopping now by adding our unique products to your shopping crate",style: subStyle,textAlign: TextAlign.center,),
        ),
      ):SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.all(30),
              child: Text("Your Previous Orders",style: subStyle,),
            ),
            Column(
              children: orders.map((e) => MyTile(e)).toList(),
            )
          ],
        ),
      ),
    );
  }
  Widget MyTile(QueryDocumentSnapshot d){
    return Container(
      width: MediaQuery.of(context).size.width-60,
      padding: EdgeInsets.all(30),
      margin: EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        children: [
          Padding(padding: EdgeInsets.all(0),
              child: Text(d['user']['name'],style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)),
          Padding(padding: EdgeInsets.all(0),
              child: Text(d['user']['email']+"\t"+d['user']['phone'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),)),
          Padding(padding: EdgeInsets.all(0),
              child: Text(d['address'],style: TextStyle(fontSize: 13,fontWeight: FontWeight.w300),)),
          Padding(padding: EdgeInsets.all(0),
              child: Text(d['coupon'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.w300),)),
          Column(
            children: products[orders.indexOf(d)].map((e)=>DataTile(e,quantities[orders.indexOf(d)][products[orders.indexOf(d)].indexOf(e)])).toList(),
          )
        ],
      ),
    );
  }
  Widget DataTile(String a,String b){
    return ListTile(
      title: Text(a),
      trailing: Text(b),
    );
  }
}