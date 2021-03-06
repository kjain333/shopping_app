import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/MainPage.dart';
import 'package:shoppingapp/Screens/Login/login_screen.dart';
import 'package:shoppingapp/Screens/Signup/components/background.dart';
import 'package:shoppingapp/Screens/Signup/components/or_divider.dart';
import 'package:shoppingapp/Screens/Signup/components/social_icon.dart';
import 'package:shoppingapp/components/already_have_an_account_acheck.dart';
import 'package:shoppingapp/components/rounded_button.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shoppingapp/database.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String email, password, contact, name, address;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final dataReference = Firestore.instance;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'E-mail is required'),
    EmailValidator(errorText: 'Enter valid email address')
  ]);
  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  void _createUser({String email, String pass}) async {
    _auth
        .createUserWithEmailAndPassword(email: email, password: pass)
        .then((authResult) async {
      DatabaseService(uid: authResult.user.uid)
          .updateUserData(name, contact, address, email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('name', name);
      prefs.setString('mobile', contact);
      prefs.setString('address', address);
      prefs.setString('email', email);
      prefs.setString('uid', authResult.user.uid);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MainPage()));
    }).catchError((err) {
      print(err.code);
      if (err.code == 'email-already-in-use') {
        showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: Text(
                    'This email already has an account associated with it'),
                actions: <Widget>[
                  CupertinoDialogAction(
                    child: Text('OK'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ],
              );
            });
      }
    });
  }

  void validate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      _createUser(email: email, pass: password);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(
                fontFamily: 'Pacifico',
                fontSize: 40.0,
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Center(
              child: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          labelText: 'Name',
                        ),
                        onChanged: (textValue) {
                          setState(() {
                            name = textValue;
                          });
                        },
                        validator:
                            RequiredValidator(errorText: 'Name is required'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 20.0,
                        ),
                      ),
                      TextFormField(
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 5.0),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            labelText: 'E-mail',
                          ),
                          onChanged: (textValue) {
                            setState(() {
                              email = textValue;
                            });
                          },
                          validator: emailValidator),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 20.0,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          labelText: 'Password',
                        ),
                        onChanged: (textValue) {
                          setState(() {
                            password = textValue;
                          });
                        },
                        validator: passwordValidator,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 20.0,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          labelText: 'Contact Number',
                        ),
                        onChanged: (textValue) {
                          setState(() {
                            contact = textValue;
                          });
                        },
                        validator: LengthRangeValidator(
                            min: 10,
                            max: 10,
                            errorText: 'Enter correct mobile number'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 20.0,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 5.0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          labelText: 'Address',
                        ),
                        onChanged: (textValue) {
                          setState(() {
                            address = textValue;
                          });
                        },
                        validator:
                            RequiredValidator(errorText: "Address is Required"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RoundedButton(
              text: "SIGNUP",
              press: () {
                validate();
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
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
          ],
        ),
      ),
    );
  }
}
