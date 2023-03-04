import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesModel {
  String? catImageUrl;
  String? catName;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  CategoriesModel(
      {this.catImageUrl, this.catName, this.createdAt, this.updatedAt});

  factory CategoriesModel.fromFirestore(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    return CategoriesModel(
      catImageUrl: data['catImageUrl'],
      catName: data['catName'],
      createdAt: data['createdAt'],
      updatedAt: data['updatedAt'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['catImageUrl'] = catImageUrl;
    data['catName'] = catName;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    return data;
  }
}
