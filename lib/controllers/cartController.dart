import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class CartController extends GetxController {
  static CartController instance = Get.find();
  FirebaseStorage storage = FirebaseStorage.instance;
  final cartCollectionRef = FirebaseFirestore.instance.collection("cart");
  final ordersCollectionRef = FirebaseFirestore.instance.collection("orders");

  var cartTotal = 0.0.obs;
  void addToCart(Map<String, dynamic> cartData) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    try {
      final QuerySnapshot querySnapshot = await cartCollectionRef
          .where('pId', isEqualTo: cartData['pId'])
          .where('userId', isEqualTo: userId)
          .get();
      if (querySnapshot.docs.isEmpty) {
        await cartCollectionRef.doc().set(cartData).then((value) {
          Fluttertoast.showToast(
              msg: "Product Added to cart ",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: Dimensions.font16);
        });
      } else {
        Fluttertoast.showToast(
            msg: "This Products Already Exits in Cart !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: Dimensions.font16);
      }

    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllCartProducts() {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return cartCollectionRef.where('userId', isEqualTo: userId).snapshots();
  }

  void calculateCartTotal(cartList) {
    double total = 0.0;
    for (var item in cartList) {
      total += item.pInfo['price'] * item.pInfo['quantity'];
    }
    cartTotal.value = total;
  }

  void deleteFromCart(String pId) async {
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      final Query query = cartCollectionRef
          .where("pId", isEqualTo: pId)
          .where("userId", isEqualTo: currentUserId);
      final QuerySnapshot querySnapshot = await query.get();
      for (final QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.delete();
      }
    } catch (e) {
      Get.snackbar(
        "",
        "Failed to Delete Product",
      );
      e.printInfo();
    }
    printInfo();
  }

  void decreaseQuantity(String id, int qty, bool isBulk) async {
    if (isBulk == true) {
      if (qty == 50) {
        Fluttertoast.showToast(
            msg: "You can't decrease the quantity less than 50 for bulk Orders",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: Dimensions.font16);

        return;
      } else {
        qty -= 1;
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;

        final Query query = cartCollectionRef
            .where("pId", isEqualTo: id)
            .where("userId", isEqualTo: currentUserId);
        final QuerySnapshot querySnapshot = await query.get();
        for (final QueryDocumentSnapshot documentSnapshot
            in querySnapshot.docs) {
          await documentSnapshot.reference.update({'pInfo.quantity': qty});
        }
      }
    } else {
      if (qty == 1) {
        Fluttertoast.showToast(
            msg: "You can't decrease the quantity less than zero",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: Dimensions.font16);

        return;
      }

      qty -= 1;
      try {
        final currentUserId = FirebaseAuth.instance.currentUser!.uid;

        final Query query = cartCollectionRef
            .where("pId", isEqualTo: id)
            .where("userId", isEqualTo: currentUserId);
        final QuerySnapshot querySnapshot = await query.get();
        for (final QueryDocumentSnapshot documentSnapshot
            in querySnapshot.docs) {
          await documentSnapshot.reference.update({'pInfo.quantity': qty});
        }
      } catch (e) {
        Get.snackbar(
          "e",
          "Failed to decrease quantity",
        );
        e.printInfo();
      }
    }
  }

  incrementQuantity(String id, int qty) async {
    qty += 1;
    try {
      final currentUserId = FirebaseAuth.instance.currentUser!.uid;

      final Query query = cartCollectionRef
          .where("pId", isEqualTo: id)
          .where("userId", isEqualTo: currentUserId);
      final QuerySnapshot querySnapshot = await query.get();
      for (final QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
        await documentSnapshot.reference.update({'pInfo.quantity': qty});
      }
    } catch (e) {
      Get.snackbar(
        "",
        "Failed to Increase quantity",
      );
      e.printInfo();
    }
  }

  void checkout(Map<String, dynamic> orderData) async {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    QuerySnapshot sourceSnapshot =
        await cartCollectionRef.where('userId', isEqualTo: userId).get();
    List<DocumentSnapshot> documents = sourceSnapshot.docs;
    for (DocumentSnapshot doc in documents) {
      await ordersCollectionRef.add({
        'customerName': orderData['customerName'],
        'address': orderData['address'],
        'city': orderData['city'],
        'phoneNumber': orderData['phoneNumber'],
        'zipCode': orderData['zipCode'],
        'userId': orderData['userId'],
        "orderAt": FieldValue.serverTimestamp(),
        "products": doc.data(),
        "totalBill": orderData['totalBill'],
      }).then((value) {
        clearCart();
        Fluttertoast.showToast(
            msg: "Your Order is placed we will contact you shortly ! ",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: Dimensions.font16);
        Get.toNamed("/home");
      });
    }
  }

  void clearCart() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final Query query = cartCollectionRef.where("userId", isEqualTo: userId);
    final QuerySnapshot querySnapshot = await query.get();
    for (final QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      await documentSnapshot.reference.delete();
    }
  }
}
