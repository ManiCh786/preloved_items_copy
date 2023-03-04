import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

class ProductController extends GetxController {
  static ProductController instance = Get.find();
  FirebaseStorage storage = FirebaseStorage.instance;

  final productCollectionRef =
      FirebaseFirestore.instance.collection("products");

  Future<void> addProduct(productData) async {
    try {
      final QuerySnapshot querySnapshot = await productCollectionRef
          .where('pName'.toLowerCase(),
              isEqualTo: productData['pName'].toString().toLowerCase())
          .get();
      if (querySnapshot.docs.isEmpty) {
        await productCollectionRef.add({
          'pName': productData['pName'],
          'pDesc': productData['pDesc'],
          'pImage': productData['pImage'],
          'isBulk': productData['isBulk'],
          'category': productData['category'],
          'forGender': productData['forGender'],
          'forSeason': productData['forSeason'],
          'sizes': productData['sizes'],
        }).then((value) {
          Fluttertoast.showToast(
              msg: "Product Added Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: Dimensions.font16);
        });
        Get.back();
      } else {
        Fluttertoast.showToast(
            msg: "Product with this name already exits !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: Dimensions.font16);
      }
    } catch (error) {
      print('Error adding product: $error');
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getAllProducts() {
    
     return  productCollectionRef.snapshots();
    
  }
  void deleteProduct(String pId, String imageUrl) async {
    try {
      final Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await productCollectionRef.doc(pId).delete();
      await ref.delete();
      Fluttertoast.showToast(
          msg: "Success !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error Occured  !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    }
  }
}
