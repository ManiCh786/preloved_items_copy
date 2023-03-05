import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:preloved_cloths/model/products_model.dart';

class OrderStatus {
  String? status;
  String? address;
  String? city;
  String? customerName;
  Timestamp? orderAt;
  String? phoneNumber;
  Map<String, dynamic>? products;
  String? userId;
  double? totalBill;
  String? zipCode;

  OrderStatus({
    this.status,
    this.address,
    this.city,
    this.customerName,
    this.orderAt,
    this.phoneNumber,
    this.products,
    this.userId,
    this.totalBill,
    this.zipCode,
  });

  factory OrderStatus.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return OrderStatus(
      address: data['address'],
      city: data['city'],
      customerName: data['customerName'],
      orderAt: data['orderAt'],
      phoneNumber: data['phoneNumber'],
      products: data['products'],
      status: data['OrderStatus'],

      totalBill: data['totalBill'],
      userId: data['userId'],
      zipCode: data['zipCode'],
    );
  }

 
}
