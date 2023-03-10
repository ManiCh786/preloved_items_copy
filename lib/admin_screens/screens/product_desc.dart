import 'dart:io';

import 'package:animate_do/animate_do.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controllers/controller.dart';
import '../../model/models.dart';
import '../../utils/utils.dart';
import '../../widget/dialogs/dialogs.dart';
import '../../widget/widget.dart';

class ProductsDetailsPage extends StatefulWidget {
  ProductsDetailsPage({
    required this.data,
    super.key,
    required this.isCameFromMostPopularPart,
    required this.pId,
  });

  final ProductsModel data;
  final String pId;
  final bool isCameFromMostPopularPart;

  @override
  State<ProductsDetailsPage> createState() => _ProductsDetailsPage();
}

class _ProductsDetailsPage extends State<ProductsDetailsPage> {
  int selectedSize = 3;
  int selectedColor = 0;
  final categoryController = Get.find<CategoryController>();
  final productController = Get.find<ProductController>();
  final _formKey = GlobalKey<FormState>();
  final _productController = TextEditingController();
  final _productDescController = TextEditingController();

  final _sizes = ['S', 'M', 'L', 'XL', 'XXL'];
  String _currentGender = 'men';
  String _currentSeason = 'summer';

  bool _isBulk = false;
  File? _imageFile;
  String? fileName;
  final picker = ImagePicker();
  List<String> selectedCategories = [];

  List<DropdownMenuItem<Color>> _colorOptions = const [
    DropdownMenuItem(
      value: Colors.red,
      child: Text('Red'),
    ),
    DropdownMenuItem(
      value: Colors.blue,
      child: Text('Blue'),
    ),
    DropdownMenuItem(
      value: Colors.green,
      child: Text('Green'),
    ),
    DropdownMenuItem(
      value: Colors.black,
      child: Text('Black'),
    ),
    DropdownMenuItem(
      value: Colors.yellow,
      child: Text('Yellow'),
    ),
    DropdownMenuItem(
      value: Colors.orange,
      child: Text('Orange'),
    ),
    DropdownMenuItem(
      value: Colors.white,
      child: Text('White'),
    ),
  ];
  final List<DropdownMenuItem<String>> _forGender = const [
    DropdownMenuItem(
      value: "men",
      child: Text('Men'),
    ),
    DropdownMenuItem(
      value: "women",
      child: Text('Women'),
    ),
  ];
  final List<DropdownMenuItem<String>> _forSeason = const [
    DropdownMenuItem(
      value: "summer",
      child: Text('Summer'),
    ),
    DropdownMenuItem(
      value: "winter",
      child: Text('Winter'),
    ),
  ];
  List<CategoriesModel> _selectedCategories = [];
  final _multiSelectKey = GlobalKey<FormFieldState>();
  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await picker.pickImage(source: source);

    setState(() {
      _imageFile = File(pickedFile!.path);
      fileName = pickedFile.name;
    });
  }

  List<Map<String, dynamic>> _selectedSizes = [];
  void _submitForm() {
    if (_imageFile == null) {
    } else {
      if (_formKey.currentState!.validate()) {
        _formKey.currentState!.save();
        if (_selectedSizes.isEmpty || selectedCategories.isEmpty) {
          Fluttertoast.showToast(
              msg: "Select a size && Category a first",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIosWeb: 2,
              backgroundColor: Colors.red,
              textColor: Colors.white,
              fontSize: Dimensions.font16);
        } else {
          _saveProductDataToFirebase(_imageFile!, fileName!);
        }
      }
    }
  }

  void _removeSize(int index) {
    setState(() {
      _selectedSizes.removeAt(index);
    });
  }

  void _addSize(String size) {
    setState(() {
      _selectedSizes.add({
        'size': size,
        'quantity': '',
        'price': '',
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;

    ProductsModel current = widget.data;
    final pId = widget.pId;

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SizedBox(
        width: size.width * 0.90,
        height: size.height * 0.30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
          
              child: Stack(
                children: [
                  Hero(
                    tag: widget.isCameFromMostPopularPart
                        ? current.pImage!
                        : pId,
                    child: Container(
                      width: size.width,
                      height: size.height * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(current.pImage!),
                            fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Padding(
                      padding: EdgeInsets.all(Dimensions.width15),
                      child: Form(
                        key: _formKey,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              DynamicTextField(
                                textFieldController: _productController,
                                validators: validateAField,
                                icon: Icons.text_fields_outlined,
                                iconColor: AppColors.yellowColor,
                                hintText: "Enter Product Name",
                              ),
                              SizedBox(height: Dimensions.height15),
                              DynamicTextField(
                                textFieldController: _productDescController,
                                minLines: 3,
                                validators: validateAField,
                                icon: Icons.description,
                                iconColor: AppColors.yellowColor,
                                hintText: "Enter Product Description",
                              ),
                              SizedBox(height: Dimensions.height15),
                              GestureDetector(
                                child: Row(
                                  children: [
                                    BigText(text: "Pick an Image"),
                                    Icon(Icons.add_a_photo,
                                        size: Dimensions.font36),
                                  ],
                                ),
                                onTap: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SafeArea(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.camera),
                                                title: const Text(
                                                    "Take a picture"),
                                                onTap: () {
                                                  _pickImage(
                                                      ImageSource.camera);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              ListTile(
                                                leading:
                                                    const Icon(Icons.image),
                                                title: const Text(
                                                    "Choose from gallery"),
                                                onTap: () {
                                                  _pickImage(
                                                      ImageSource.gallery);
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      });
                                },
                              ),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    children: [
                                      BigText(text: "Is This Bulk Product "),
                                      Checkbox(
                                        value: _isBulk,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _isBulk = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  )),
                              SizedBox(height: Dimensions.height15),
                              SmallText(
                                text: "Choose Categories",
                                color: Colors.blue,
                              ),
                              StreamBuilder(
                                stream: categoryController.readAllCategories(),
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData) {
                                    return Center(
                                        child: CircularProgressIndicator());
                                  }
                                  List<CategoriesModel> categoriesList =
                                      snapshot.data!.docs
                                          .map((document) =>
                                              CategoriesModel.fromFirestore(
                                                  document))
                                          .toList();
                                  return Container(
                                    height: 150,
                                    child: ListView.builder(
                                      itemCount: categoriesList.length,
                                      itemBuilder: (context, index) {
                                        return CheckboxListTile(
                                          title: Text(
                                              categoriesList[index].catName!),
                                          value: selectedCategories.contains(
                                              categoriesList[index]
                                                  .catName
                                                  .toString()
                                                  .toLowerCase()),
                                          onChanged: (bool? value) {
                                            if (value != null && value) {
                                              setState(() {
                                                selectedCategories.add(
                                                    categoriesList[index]
                                                        .catName
                                                        .toString()
                                                        .toLowerCase());
                                              });
                                            } else {
                                              setState(() {
                                                selectedCategories.remove(
                                                    categoriesList[index]
                                                        .catName
                                                        .toString()
                                                        .toLowerCase());
                                              });
                                            }
                                          },
                                        );
                                      },
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.all(Dimensions.width10),
                                child: DropdownButtonFormField<String>(
                                  value: _currentGender,
                                  decoration: const InputDecoration(
                                    labelText: 'For Gender',
                                  ),
                                  items: _forGender,
                                  onChanged: (gender) {
                                    setState(() {
                                      _currentGender = gender.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: Dimensions.height15),
                              Padding(
                                padding: EdgeInsets.all(Dimensions.width10),
                                child: DropdownButtonFormField<String>(
                                  value: _currentSeason,
                                  decoration: const InputDecoration(
                                    labelText: 'For Season',
                                  ),
                                  items: _forSeason,
                                  onChanged: (season) {
                                    setState(() {
                                      _currentSeason = season.toString();
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: Dimensions.height15),
                              BigText(text: "Sizes"),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8.0,
                                children: _sizes.map((size) {
                                  return FilterChip(
                                    label: Text(size),
                                    selected: _selectedSizes
                                        .any((s) => s['size'] == size),
                                    onSelected: (selected) {
                                      if (selected) {
                                        _addSize(size);
                                      } else {
                                        var index = _selectedSizes.indexWhere(
                                            (s) => s['size'] == size);
                                        _removeSize(index);
                                      }
                                    },
                                  );
                                }).toList(),
                              ),
                              SizedBox(height: Dimensions.height15),
                              SmallText(
                                  text: "Selected Sizes ", color: Colors.black),
                              SizedBox(height: Dimensions.height10),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: _selectedSizes.length,
                                itemBuilder: (context, index) {
                                  var size = _selectedSizes[index];
                                  return Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('Size: ${size['size']}'),
                                   
                                          SizedBox(height: Dimensions.height10),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Quantity',
                                            ),
                                            validator: validateAField,
                                            onSaved: (value) {
                                              size['quantity'] = value;
                                            },
                                          ),
                                          SizedBox(height: Dimensions.height10),
                                          TextFormField(
                                            decoration: const InputDecoration(
                                              labelText: 'Price',
                                            ),
                                            validator: validateAField,
                                            onSaved: (value) {
                                              size['price'] = value;
                                            },
                                          ),
                                          SizedBox(height: Dimensions.height10),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(height: Dimensions.height15),
                              ReuseableButton(
                                  text: "Add Product", onTap: _submitForm),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.favorite_border,
            color: Colors.white,
          ),
        ),
      ],
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.white,
        ),
      ),
    );
  }

  _saveProductDataToFirebase(File image, String fileName) {
    FirebaseStorage storage = FirebaseStorage.instance;
    var imageName = fileName;
    Reference reference = storage.ref().child("productsImages/$imageName");

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

    final productData = {
      'pName': _productController.text,
      'pDesc': _productDescController.text,
      'pImage': url,
      'isBulk': _isBulk,
      'category': selectedCategories,
      'forGender': _currentGender,
      'forSeason': _currentSeason,
      'sizes': _selectedSizes,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };

    productController.addProduct(productData);
  }
}
