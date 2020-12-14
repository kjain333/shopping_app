import 'package:flutter/material.dart';
import 'package:shoppingapp/Screens/Login/login_screen.dart';
import 'package:shoppingapp/Screens/Signup/signup_screen.dart';
import 'package:shoppingapp/Screens/Welcome/components/background.dart';
import 'package:shoppingapp/components/rounded_button.dart';
import 'package:shoppingapp/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // This size provide us total height and width of our screen
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 60, 30, 30),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 60, 0, 0),
                child: Text(
                  "Welcome!",
                  style: TextStyle(
                    fontSize: 60.0,
                  ),
                ),
              ),
            ),
            SvgPicture.asset(
              "Assets/icons/welcome_logo.svg",
              height: size.height * 0.2,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedButton(
              text: "LOGIN",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
            RoundedButton(
              text: "SIGN UP",
              color: kPrimaryLightColor,
              textColor: Colors.black,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return SignUpScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
