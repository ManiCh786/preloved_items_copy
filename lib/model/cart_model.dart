import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {
  final String? pId;
  final String? userId;
  final Map<String, dynamic>? pInfo;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;

  CartModel({
    this.pId,
    this.userId,
    this.pInfo,
    this.createdAt,
    this.updatedAt,
  });

  factory CartModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return CartModel(
      pId: data['pId'],
      userId: data['userId'],
      pInfo: data['pInfo'],
      updatedAt: data['createdAt'],
      createdAt: data['updatedAt'],
    );
  }
}
