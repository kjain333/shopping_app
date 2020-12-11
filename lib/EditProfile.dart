import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shoppingapp/components/themes.dart';
import 'package:shoppingapp/database.dart';
import 'package:toast/toast.dart';

import 'components/rounded_button.dart';

class EditProfile extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
     return _EditProfile();
  }
}
bool loading = true;
class _EditProfile extends State<EditProfile>{
  String contact,address,name,email;
  GlobalKey<FormState> formkey = GlobalKey<FormState>();
  void validate() async {
    if (formkey.currentState.validate()) {
      FirebaseAuth auth = FirebaseAuth.instance;
      DatabaseService(uid: auth.currentUser.uid).updateUserData(name, contact, address, email);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('mobile',contact);
      prefs.setString('address',address);
      prefs.setString('name',name);
      Toast.show("Data Updated Successfully", context,backgroundColor: Colors.green,textColor: Colors.white,gravity: Toast.BOTTOM,duration: Toast.LENGTH_LONG);
    }
  }
  void initialize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    contact = prefs.getString('mobile');
    address = prefs.getString('address');
    name = prefs.getString('name');
    email = prefs.getString('email');
    print(email);
    setState(() {
      loading = false;
    });
  }
  @override
  void initState() {
    loading=true;
    initialize();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
    appBar: AppBar(
      title: Text("Khati Khuwa",style: headStyle,),
      leading: GestureDetector(
        child: Icon(Icons.arrow_back,color: Colors.white,),
        onTap: (){
          Navigator.pop(context);
        },
      ),
    ),
     body: (loading==true)?Center(
       child: CircularProgressIndicator(),
     ):SingleChildScrollView(
       child: Column(
         children: [
           SizedBox(
             height: 30,
           ),
           Container(
             height: 120,
             width: 120,
             decoration: BoxDecoration(
               image: DecorationImage(
                 image: AssetImage('Assets/icons/userProfile.png'),
                 fit: BoxFit.fill
               )
             ),
           ),
           SizedBox(
             height: 40,
           ),
           Center(
             child: Form(
               key: formkey,
               child: Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 40.0),
                 child: Column(
                   children: <Widget>[
                     TextFormField(
                       initialValue: name??"",
                       decoration: InputDecoration(
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
                         vertical: 10.0,
                         horizontal: 50.0,
                       ),
                     ),
                     TextFormField(
                       initialValue: contact??"",
                       decoration: InputDecoration(
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
                         vertical: 10.0,
                         horizontal: 20.0,
                       ),
                     ),
                     TextFormField(
                       initialValue: address??"",
                       decoration: InputDecoration(
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
                       validator: RequiredValidator(errorText: "Address is Required"),
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
             text: "UPDATE",
             press: () {
               validate();
             },
           ),
         ],
       ),
     ),
   );
  }
}