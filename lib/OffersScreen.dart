import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/HomePage.dart';
import 'package:shoppingapp/models/OfferModel.dart';
import 'package:shoppingapp/models/SharedPreferences.dart';

import 'CompleteOffer.dart';
import 'MyDrawer.dart';
import 'PlaceOrder.dart';
import 'components/themes.dart';

class OffersScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _OffersScreen();
  }
}

List<QueryDocumentSnapshot> data = new List();
List<String> categories = [
  "All",
  "Traditional Clothes",
  "Jewellery",
  "Pickles",
  "Spices",
  "Hand Craft",
  "Food Items",
  "Daily Needs"
];
List<String> desc = [
  "Get all what you need from groceries to Latest Tech",
  "Style up your game with latest designs from traditional market",
  "Ethnic Jewellery wear at amazing prices",
  "Pickle up your bland food with home-made pickles",
  "Spice up your taste with straight from kitchen fresh spices",
  "Revamp your house with latest ethnic collection of hand crafts",
  "Healthy food for a healthy lifestyle",
  "Cooking essentials, groceries and other goods all for you"
];

class _OffersScreen extends State<OffersScreen> {
  final databaseReference = Firestore.instance;
  SharedPreferences prefs;
  Future<void> getSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<OfferModel> offers = new List();
    for (int i = 0; i < data.length; i++) offers.add(OfferModel(data[i]));
    prefs.setString('offers', jsonEncode(offers));
  }

  Future getOfferImg() async {
    var firestore = Firestore.instance;
    QuerySnapshot query =
        await firestore.collection("offer_greeting").getDocuments();
    return query.documents;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Khati Khuwa',
            style: headStyle,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.shopping_cart),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => PlaceOrder()));
          },
        ),
        drawer: buildDrawer(context),
        body: FutureBuilder(
            future: databaseReference.collection("offer_greeting").get(),
            builder:
                (BuildContext content, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                data = snapshot.data.docs;
                getSharedPref();
                print(data.length);
                return SingleChildScrollView(
                  child: Column(
                    children: [
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Wrap(
                          children: categories.map((e) {
                            return GestureDetector(
                              child: Container(
                                margin: EdgeInsets.all(10),
                                width: 100,
                                color: Colors.white,
                                child: Column(
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.all(10),
                                        child: Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: AssetImage(
                                                      'Assets/icons/' +
                                                          e +
                                                          '.png'),
                                                  fit: BoxFit.fill)),
                                        )),
                                    Text(e, style: subStyle),
                                  ],
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(e)));
                              },
                            );
                          }).toList(),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 300,
                        child: FutureBuilder(
                          future: getOfferImg(),
                          builder: (_, snapshot) {
                            return CarouselSlider.builder(
                              slideBuilder: (index) {
                                DocumentSnapshot sliderimage =
                                    snapshot.data[index];
                                return GestureDetector(
                                  child: Container(
                                    height: 300,
                                    width: MediaQuery.of(context).size.width,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                      image: NetworkImage(sliderimage['url']),
                                      fit: BoxFit.fill,
                                    )),
                                  ),
                                );
                              },
                              slideIndicator: CircularSlideIndicator(
                                  indicatorBackgroundColor: Colors.white,
                                  currentIndicatorColor:
                                      Colors.lightBlueAccent),
                              itemCount: snapshot.data.length,
                            );
                          },
                        ),
                      ),
                      Column(
                        children: categories.map((e) {
                          int index = categories.indexOf(e);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => HomePage(e)));
                            },
                            child: Padding(
                              padding: EdgeInsets.all(20),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 40,
                                decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                60,
                                        child: Text(
                                          desc[index],
                                          style: headStyle1,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(30),
                                      child: Container(
                                        height:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                100,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    'Assets/icons/' +
                                                        e +
                                                        '2' +
                                                        '.png'),
                                                fit: BoxFit.fill)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Center(
                                        child: Text(
                                          "View More",
                                          style: subStyle1,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                );
              }
            }));
  }
}
