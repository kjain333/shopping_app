import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shoppingapp/MainPage.dart';
import './background.dart';
import 'package:shoppingapp/Screens/Signup/signup_screen.dart';
import 'package:shoppingapp/components/already_have_an_account_acheck.dart';
import 'package:shoppingapp/components/rounded_button.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}
class _BodyState extends State<Body> {

  String email, password;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final emailValidator = MultiValidator([
    RequiredValidator(errorText: 'E-mail is required'),
    EmailValidator(errorText: 'Enter valid email address')
  ]);
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  final passwordValidator = MultiValidator([
    RequiredValidator(errorText: 'password is required'),
    MinLengthValidator(8, errorText: 'password must be at least 8 digits long'),
    PatternValidator(r'(?=.*?[#?!@$%^&*-])',
        errorText: 'passwords must have at least one special character')
  ]);

  void _signIn({String email,String pass}){
    _auth.signInWithEmailAndPassword(email: email, password:pass).then((authResult){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
    }).catchError((err){
      print(err.code);
      if(err.code == 'wrong-password'||err.code=='user-not-found'){
        showCupertinoDialog(context: context, builder: (context){
          return CupertinoAlertDialog(
            title: Text(
                'Incorrect credentials'
            ),
            actions: <Widget>[
              CupertinoDialogAction(child: Text('OK'),
                onPressed: (){
                  Navigator.pop(context);
                },)
            ],
          );
        });
      }
    });
  }
  void validate() {
    if (formkey.currentState.validate()) {
      formkey.currentState.save();
      _signIn(email: email,pass: password);
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
              "LOGIN",
              style: TextStyle(fontSize: 80.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            Center(
              child: Form(
                key: formkey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
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
                        validator: emailValidator,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 50.0,
                        ),
                      ),
                      TextFormField(
                        decoration: InputDecoration(
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
                          vertical: 10.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            RoundedButton(
              text: "LOGIN",
              press: () {
                validate();
              },
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
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
