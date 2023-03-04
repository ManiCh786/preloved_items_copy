import 'dart:io';

import 'package:advance_notification/advance_notification.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/controller.dart';
import '../model/models.dart';
import '../utils/utils.dart';
import '../widget/widget.dart';

class AddProfileInfo extends StatefulWidget {
  AddProfileInfo({super.key});

  @override
  State<AddProfileInfo> createState() => _AddProfileInfoState();
}

class _AddProfileInfoState extends State<AddProfileInfo> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _fNameController = TextEditingController();

  final TextEditingController _lNameController = TextEditingController();

  final TextEditingController _phoneController = TextEditingController();

  // final TextEditingController _phoneController = TextEditingController();
  String _role = 'user';
  // default role is 'user'
  File? _image;
  String? fileName;
  // stores the selected image file
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: AppColors.sandyBrown,
        centerTitle: true,
        title: BigText(
          text: "Set up Profile",
          size: 24,
          color: Colors.white,
        ),
      ),
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: Dimensions.height20),
        child: Column(
          children: [
            // ProfileIcon
            IconButtonWidget(
              onPressed: () {
                _pickImage();
              },
              icon: Icons.photo_size_select_actual_rounded,
              backgroundColor: AppColors.sandyBrown,
              iconSize: Dimensions.height45 + Dimensions.height30,
              iconColor: Colors.white,
              size: Dimensions.height15 * 10,
            ),
            SizedBox(height: Dimensions.height30),
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Name List
                      Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        child: DynamicTextField(
                          icon: Icons.person,
                          validators: validateUserName,
                          textFieldController: _fNameController,
                          isObscure: false,
                          iconColor: AppColors.sandyBrown,
                          hintText: "Enter First Name",
                          iconSize: Dimensions.font36,
                        ),
                      ),
                      SizedBox(height: Dimensions.height30),
                      Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        child: DynamicTextField(
                          icon: Icons.person,
                          validators: validateUserName,
                          textFieldController: _lNameController,
                          isObscure: false,
                          iconColor: AppColors.sandyBrown,
                          hintText: "Enter Last  Name",
                          iconSize: Dimensions.font36,
                        ),
                      ),
                      SizedBox(height: Dimensions.height30),
                      Padding(
                        padding: EdgeInsets.only(
                          left: Dimensions.width20,
                          right: Dimensions.width20,
                        ),
                        child: DynamicTextField(
                          icon: Icons.phone,
                          validators: validateMobile,
                          textFieldController: _phoneController,
                          isObscure: false,
                          iconColor: AppColors.sandyBrown,
                          hintText: "Enter Phone Number",
                          iconSize: Dimensions.font36,
                        ),
                      ),
                      //Phone

                      SizedBox(height: Dimensions.height30),

                      SizedBox(height: Dimensions.height20 * 2),

                      ReuseableButton(
                        bgColor: AppColors.sandyBrown,
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            _saveProductDataToFirebase();
                          } else {
                            AdvanceSnackBar(
                              textSize: Dimensions.font14,
                              bgColor: Colors.red,
                              message: 'All Fields are required!',
                              mode: Mode.ADVANCE,
                              duration: Duration(seconds: 3),
                            ).show(context);
                          }
                        },
                        text: "Save Profile",
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _saveProductDataToFirebase() {
    if (_image == null) {
      _onNoImageIsSelected();
      return;
    }
    if (_formKey.currentState!.validate()) {
      FirebaseStorage storage = FirebaseStorage.instance;
      //Create a reference to the location you want to upload to in firebase
      var imageName = fileName;
      Reference reference = storage.ref().child("userProfileImages/$imageName");

      UploadTask uploadTask = reference.putFile(_image!);
      Get.dialog(
        Dialog(
          child: Container(
            padding: const EdgeInsets.all(20),
            height: Dimensions.height100 + Dimensions.height45,
            width: Dimensions.height100 + Dimensions.height45,
            child: const Center(
              child: Text(
                'Uploading Image . . .',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
      uploadTask.whenComplete(() async {
        Get.back();
        final url = await reference.getDownloadURL();
        _insertData(url);
        // print(await reference.getDownloadURL());
      });

      uploadTask.printError();
      uploadTask.printError(
        info: "Error Uploading Image",
      );
    }
  }

  _insertData(String url) {
    final fName = _fNameController.text.trim();
    final lName = _lNameController.text.trim();
    final phone = _phoneController.text.trim();

    final userProfileData = {
      'fName': fName,
      'lName': lName,
      'phone': phone,
      'profileImageUrl': url,
      'createdAt': DateTime.now(),
      'updatedAt': DateTime.now(),
    };
    AuthController.instance.storeUserData(userProfileData);

    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 150,
          width: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Profile Saved Succesfully",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () {
                      Get.offAllNamed("/splash");
                      Get.back(canPop: true);
                    },
                    child: const Text("OK"),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(80, 40),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  _onNoImageIsSelected() {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(20),
          height: 150,
          width: 150,
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                " Image Not Selected",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "You Must Provide an Image ",
                textAlign: TextAlign.center,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Ok",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600)),
                    style: TextButton.styleFrom(
                      minimumSize: const Size(50, 50),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        fileName = pickedFile.name;
      } else {
        AdvanceSnackBar(
          textSize: Dimensions.font14,
          bgColor: Colors.red,
          message: 'No image selected.',
          mode: Mode.ADVANCE,
          duration: Duration(seconds: 3),
        ).show(context);
      }
    });
  }
}
