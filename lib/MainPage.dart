import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:titled_navigation_bar/titled_navigation_bar.dart';
import 'package:shoppingapp/components/themes.dart';
import 'HomePage.dart';
import 'SavedPage.dart';
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