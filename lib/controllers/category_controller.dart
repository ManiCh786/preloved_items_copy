import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import '../widget/dialogs/dialogs.dart';

class CategoryController extends GetxController {
  static CategoryController instance = Get.find();
  FirebaseStorage storage = FirebaseStorage.instance;

  final catCollectionRef = FirebaseFirestore.instance.collection("categories");

  void addCategory(Map<String, dynamic> category) async {
    try {
      final QuerySnapshot querySnapshot = await catCollectionRef
          .where('catName'.toLowerCase(),
              isEqualTo: category['catName'].toString().toLowerCase())
          .get();
      if (querySnapshot.docs.isEmpty) {
        await catCollectionRef.doc().set(category).then((value) {
          Fluttertoast.showToast(
              msg: "Category Added Successfully",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: Dimensions.font16);
        });
      } else {
        Fluttertoast.showToast(
            msg: "Category with this name already exits !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: Dimensions.font16);
      }

      Get.back();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error Occured while saving data !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readAllCategories() {
    return catCollectionRef.snapshots();
  }



  void updateCategory(Map<String, Object> categoryData, catId) async {
    try {
      await catCollectionRef.doc(catId).update(categoryData).then((value) {
        Fluttertoast.showToast(
            msg: "Success !",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIosWeb: 2,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: Dimensions.font16);
      });
      Get.back();
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error Occurred !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 2,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    }
  }

  void deleteCategory(String catId, String imageUrl) async {
    try {
      final Reference ref = FirebaseStorage.instance.refFromURL(imageUrl);
      await catCollectionRef.doc(catId).delete();
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
