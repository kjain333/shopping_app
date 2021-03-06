import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shoppingapp/components/themes.dart';

class FullImage extends StatelessWidget {
  final String image;
  FullImage(this.image);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar1(context),
      body: Container(
        child: GestureDetector(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                image: DecorationImage(
              image: NetworkImage(this.image),
              fit: BoxFit.fill,
            )),
          ),
        ),
      ),
    );
  }
}
