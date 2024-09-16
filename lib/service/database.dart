import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future<void> addUserDetail(Map<String, dynamic> userInfoMap, String id) async {
    await FirebaseFirestore.instance.collection('users').doc(id).set(userInfoMap);
  }

  Future<void> UpdateUserwallet(String id, String amount) async {
    await FirebaseFirestore.instance.collection('users').doc(id).update({
      "Wallet": amount,
    });
  }

  Future<void> addFoodItem(Map<String, dynamic> userInfoMap, String name) async {
    await FirebaseFirestore.instance.collection(name).add(userInfoMap);
  }

  Stream<QuerySnapshot> getFoodItem(String name) {
    return FirebaseFirestore.instance.collection(name).snapshots();
  }

  Future<void> addFoodToCart(Map<String, dynamic> userInfoMap, String id) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(id)
        .collection("Cart")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getFoodCart(String id) async{
    return await FirebaseFirestore.instance.collection("users").doc(id).collection("Cart").snapshots();

  }

}
