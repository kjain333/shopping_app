import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;
  DatabaseService({this.uid});

  // collection reference
  final CollectionReference userData =
      Firestore.instance.collection('userData');

  Future<void> updateUserData(
      String name, String phoneNumber, String address, String email) async {
    return await userData.document(uid).setData({
      'address': address,
      'name': name,
      'PhoneNumber': phoneNumber,
      'email': email
    });
  }
}
