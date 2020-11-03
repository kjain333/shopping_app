import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/PlaceOrder.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:shoppingapp/components/themes.dart';
import 'HomePage.dart';
import 'SavedPage.dart';
import 'components/oval_right_clipper.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  //For bottom nav
  int _selectedPage = 0;
  var _pageOptions = [
      HomePage(),
      SavedPage()
  ];
  var _pageController = new PageController(initialPage: 0);

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
                          color: Colors.orangeAccent),
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

        body: PageView(
          children: _pageOptions,
          onPageChanged: (index) {
            setState(() {
              _selectedPage = index;
            });
          },
          controller: _pageController,
        ),
        bottomNavigationBar: TitledBottomNavigationBar(
            reverse: true,
            currentIndex:
            _selectedPage, // Use this to update the Bar giving a position
            onTap: (index) {
              setState(() {
                _selectedPage = index;
                _pageController.animateToPage(index,
                    duration: Duration(milliseconds: 300), curve: Curves.ease);
              });
            },
            items: [
              TitledNavigationBarItem(title: Text('Home',style: subStyle), icon: Icons.home),
              TitledNavigationBarItem(title: Text('Saved',style: subStyle), icon: Icons.save),
            ])

    );
  }
}