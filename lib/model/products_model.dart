import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsModel {
  final String? pName;
  final String? pDesc;
  final String? pImage;
  final bool? isBulk;
  final String? forGender;
  final String? forSeason;
  final Timestamp? createdAt;
  final Timestamp? updatedAt;
  final List<dynamic>? category;
  final List<dynamic>? sizes;

  ProductsModel({
    this.pName,
    this.pDesc,
    this.pImage,
    this.isBulk,
    this.forGender,
    this.forSeason,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.sizes,
  });

  factory ProductsModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return ProductsModel(
      pImage: data['pImage'],
      pName: data['pName'],
      pDesc: data['pDesc'],
      sizes: data['sizes'],
      isBulk: data['isBulk'],
      category: data['category'],
      forGender: data['forGender'],
      forSeason: data['forSeason'],
      updatedAt: data['createdAt'],
      createdAt: data['updatedAt'],
    );
  }
  factory ProductsModel.fromMap(Map<String, dynamic> data) {
    return ProductsModel(
      pImage: data['pImage'],
      pName: data['pName'],
      pDesc: data['pDesc'],
      sizes: data['sizes'],
      isBulk: data['isBulk'],
      category: data['category'],
      forGender: data['forGender'],
      forSeason: data['forSeason'],
      updatedAt: data['createdAt'],
      createdAt: data['updatedAt'],
    );
  }
}
