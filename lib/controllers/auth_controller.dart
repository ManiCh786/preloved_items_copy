import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:preloved_cloths/model/models.dart';
import '../utils/utils.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();

  FirebaseAuth auth = FirebaseAuth.instance;

  final RxList<UsersModel> usersListStream = RxList<UsersModel>();

  bool _isLoading = false;
  get isLoading => _isLoading;
  UsersModel? user;
  final userCollectionRef = FirebaseFirestore.instance.collection("users");

  RxList<DocumentSnapshot> usersRecord = RxList<DocumentSnapshot>();

  @override
  void onReady() {
    super.onReady();
  }

  Future readUsers() async {
    _isLoading = true;

    userCollectionRef.snapshots().listen((querySnapshot) {
      final List<UsersModel> data = querySnapshot.docs.map((doc) {
        final data = doc.data();
        return UsersModel(
            fName: data['fName'],
            lName: data['lName'],
            email: data['email'],
            accountType: data['accountType'],
            phone: data['phone'],
            status: data['status'],
            profileImageUrl: data['profileImageUrl'],
            userId: doc.id);
      }).toList();
      usersListStream.assignAll(data);
    });

    _isLoading = false;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> readUsersSnapshots() {
    return userCollectionRef.snapshots();
  }

  Future readCurrentUser() async {
    var userData = await userCollectionRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    user = UsersModel.fromJson(userData.data()!, userData.id);
    return true;
  }

  Future<String?> checkUserRole() async {
    String? userRole;
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;

    await userCollectionRef.doc(currentUserId).get().then((doc) {
      if (doc.exists) {
        userRole = doc.data()!['accountType'];
      } else {
        userRole = "";
      }
    });
    return userRole;
  }

  void blockOrunblockUser(String accountType, String userId) async {
    final userData = {
      'status': accountType,
    };
    try {
      await userCollectionRef.doc(userId).update(userData);
      Fluttertoast.showToast(
          msg: "Sucess !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
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

  void storeUserData(Map<String, dynamic> usersData) async {
    var currentUserId = FirebaseAuth.instance.currentUser!.uid;
    try {
      await userCollectionRef.doc(currentUserId).update(usersData);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Error Occured while saving data !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    }
  }

  void register(String email, String password) async {
    try {
      await auth
          .createUserWithEmailAndPassword(email: email, password: password)
          .then((value) async {
        UsersModel userRole = UsersModel(
            profileImageUrl: "",
            fName: "",
            lName: "",
            email: email,
            phone: "",
            status: "active",
            accountType: "user");
        var currentUserId = FirebaseAuth.instance.currentUser!.uid;
        await userCollectionRef.doc(currentUserId).set(userRole.toJson());
        Get.offAllNamed("/splash");
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    }
  }

  void login(String email, String password) async {
    try {
      await auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((value) {
        Get.offAllNamed("/splash");
      });
    } catch (e) {
      Fluttertoast.showToast(
          msg: e.toString().replaceAll(RegExp(r'\[.*?\]'), ''),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 3,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: Dimensions.font16);
    }
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed("/splash");
  }
}
