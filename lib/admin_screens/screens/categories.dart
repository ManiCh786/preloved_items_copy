import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/controller.dart';
import '../../model/models.dart';
import '../../utils/utils.dart';
import '../../widget/dialogs/dialogs.dart';
import '../../widget/widget.dart';

class Categories extends StatelessWidget {
  Categories({super.key});
  final categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10, vertical: Dimensions.height10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Categories",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font20,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    Get.dialog(AddCategoryDialog());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: Dimensions.iconSize24,
                      ),
                      Text("Add Category",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.font20,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream: categoryController.readAllCategories(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                        child: CircularProgressIndicator(
                      color: AppColors.deepPink,
                    ));
                  } else if (snapshot.data!.docs.isEmpty) {
                    return Center(
                        child: BigText(
                      text: "No Record Found !",
                      color: Colors.black,
                    ));
                  } else if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        List<CategoriesModel> categoriesList = snapshot
                            .data!.docs
                            .map((document) =>
                                CategoriesModel.fromFirestore(document))
                            .toList();

                        final current = categoriesList[index];

                        return SizedBox(
                          height: Dimensions.height80,
                          width: width * 0.90,
                          child: Card(
                            elevation: 2.0,
                            margin: EdgeInsets.only(
                                right: Dimensions.width10,
                                bottom: 4.0,
                                top: 4.0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              side: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(
                                //   builder: (context) {
                                //     return ProductsDetailsPage(
                                //       data: current,
                                //       isCameFromMostPopularPart: false,
                                //     );
                                //   },
                                // ));
                              },
                              leading: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(current.catImageUrl!),
                                radius: Dimensions.radius30,
                              ),
                              title: Text(current.catName.toString()),
                              trailing: SizedBox(
                                  width:
                                      Dimensions.width100 + Dimensions.width30,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          size: Dimensions.iconSize30,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          final catId =
                                              snapshot.data!.docs[index].id;
                                          final imageUrl = current.catImageUrl;
                                          ConfirmationDialog
                                              .showConfirmationDialog(
                                            'Confirm Action',
                                            'Are you sure you want to delete this Category ?',
                                            () => categoryController
                                                .deleteCategory(
                                                    catId, imageUrl!),
                                            Colors.red,
                                            Colors.grey,
                                            Colors.white,
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          Icons.edit,
                                          size: Dimensions.iconSize30,
                                          color: Colors.green,
                                        ),
                                        onPressed: () {
                                          final catId =
                                              snapshot.data!.docs[index].id;
                                          final imageUrl = current.catImageUrl;
                                          Get.dialog(UpdateCategoryDialog(
                                              catId: catId,
                                              catName: current.catName!,
                                              imageUrl: imageUrl!));
                                        },
                                      ),
                                    ],
                                  )),

                              tileColor: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("");
                  }
                }),
          ),
        ],
      ),
    );
  }
}

class UpdateCategoryDialog extends StatefulWidget {
  const UpdateCategoryDialog(
      {super.key,
      required this.imageUrl,
      required this.catName,
      required this.catId});
  final String imageUrl;
  final String catName;
  final String catId;
  @override
  State<UpdateCategoryDialog> createState() => _UpdateCategoryDialogState();
}

class _UpdateCategoryDialogState extends State<UpdateCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _categoryController = TextEditingController();
  File? _imageFile;
  String? fileName;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        fileName = pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    _categoryController.text = widget.catName;
    return AlertDialog(
      title: BigText(text: "Update Category "),
      content: Container(
        width: width,
        height: height * 0.40,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: getImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(75),
                    color: Colors.grey[200],
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                      : widget.imageUrl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.network(
                                widget.imageUrl,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt,
                              size: Dimensions.font50,
                              color: Colors.grey[800],
                            ),
                ),
              ),
              DynamicTextField(
                textFieldController: _categoryController,
                validators: validateAField,
                hintText: "Enter Category Name",
                isObscure: false,
                keyoardtype: TextInputType.text,
                icon: Icons.category,
                iconColor: AppColors.yellowColor,
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Update Category',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_imageFile == null) {
                  _updateData(widget.imageUrl, widget.catId);
                } else {
                  _updateCatImage(_imageFile!, fileName!);
                }
              }
            },
          ),
        ])
      ],
    );
  }

  _updateCatImage(File image, String fileName) {
    FirebaseStorage storage = FirebaseStorage.instance;
    var imageName = fileName;
    Reference reference = storage.ref().child("categoryImages/$imageName");

    UploadTask uploadTask = reference.putFile(image);
    Get.dialog(
      const UploadinImageDialog(),
      barrierDismissible: false,
    );
    uploadTask.whenComplete(() async {
      Get.back();
      final url = await reference.getDownloadURL();
      _updateData(url, widget.catId);
      });

    uploadTask.printError();
    uploadTask.printError(
      info: "Error Uploading Image",
    );
  }

  _updateData(String url, String catId) async {

    final catController = Get.find<CategoryController>();

    final catName = _categoryController.text.trim();
    final categoryData = {
      'catName': catName,
      'catImageUrl': url,
      'updatedAt': DateTime.now(),
    };
    catController.updateCategory(categoryData, catId);
  }
}

class AddCategoryDialog extends StatefulWidget {
  final String? oldImageurl;
  AddCategoryDialog({
    super.key,
    this.oldImageurl,
  });

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _categoryController = TextEditingController();
  File? _imageFile;
  String? fileName;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
        fileName = pickedFile.name;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;

    return AlertDialog(
      title: BigText(text: "Add Category "),
      content: Container(
        width: width,
        height: height * 0.40,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: getImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(75),
                    color: Colors.grey[200],
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(75),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: 150,
                            height: 150,
                          ),
                        )
                      : widget.oldImageurl != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(75),
                              child: Image.network(
                                widget.oldImageurl!,
                                fit: BoxFit.cover,
                                width: 150,
                                height: 150,
                              ),
                            )
                          : Icon(
                              Icons.camera_alt,
                              size: Dimensions.font50,
                              color: Colors.grey[800],
                            ),
                ),
              ),
              DynamicTextField(
                textFieldController: _categoryController,
                validators: validateAField,
                hintText: "Enter Category Name",
                isObscure: false,
                keyoardtype: TextInputType.text,
                icon: Icons.category,
                iconColor: AppColors.yellowColor,
              ),
              SizedBox(height: height * 0.02),
            ],
          ),
        ),
      ),
      actions: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          TextButton(
            onPressed: () => Get.back(),
            style: TextButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text('Cancel', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Add Category',
                style: TextStyle(color: Colors.white)),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (_imageFile == null) {
                  _onNoImageIsSelected();
                  return;
                } else {
                  _saveProductDataToFirebase(_imageFile!, fileName!);
                }
              }
            },
          ),
        ])
      ],
    );
  }

  _saveProductDataToFirebase(File image, String fileName) {
    FirebaseStorage storage = FirebaseStorage.instance;
    var imageName = fileName;
    Reference reference = storage.ref().child("categoryImages/$imageName");

    UploadTask uploadTask = reference.putFile(image);
    Get.dialog(
      const UploadinImageDialog(),
      barrierDismissible: false,
    );
    uploadTask.whenComplete(() async {
      Get.back();
      final url = await reference.getDownloadURL();
      _insertData(url);
    });

    uploadTask.printError();
    uploadTask.printError(
      info: "Error Uploading Image",
    );
  }

  _insertData(String url) async {
    final catController = Get.find<CategoryController>();

    final catName = _categoryController.text.trim();
    final categoryData = {
      'catName': catName,
      'catImageUrl': url,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
    catController.addCategory(categoryData);
  }

  _onNoImageIsSelected() {
    Get.dialog(
      const NoImageSelectedDialog(),
      barrierDismissible: false,
    );
  }
}
