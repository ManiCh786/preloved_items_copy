import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:preloved_cloths/model/cart_model.dart';

import '../controllers/controller.dart';
import '../utils/utils.dart';
import '../widget/widget.dart';

class CheckoutPage extends StatelessWidget {
  final List<CartModel> cartProducts;
  final double totalBill;

  CheckoutPage(
      {super.key, required this.cartProducts, required this.totalBill});
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final phoneController = TextEditingController();
  final zipCodeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final user = Get.find<AuthController>();
  final cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipping Address',
                  style: TextStyle(
                    fontSize: Dimensions.font20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Dimensions.height10),
                CheckoutDynamicTextField(
                  controller: nameController,
                  label: "Name",
                ),
                SizedBox(height: Dimensions.height15),
                CheckoutDynamicTextField(
                  controller: addressController,
                  label: "Address",
                ),
                SizedBox(height: Dimensions.height15),
                CheckoutDynamicTextField(
                  controller: cityController,
                  label: "City",
                ),
                SizedBox(height: Dimensions.height15),
                TextFormField(
                  validator: validateMobile,
                  controller: phoneController,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: const InputDecoration(
                    labelText: "Phone No.",
                    labelStyle: const TextStyle(color: Colors.black),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                CheckoutDynamicTextField(
                  controller: zipCodeController,
                  label: "Zip Code",
                ),
                SizedBox(height: Dimensions.height30),
                const Text(
                  'Payment Information',
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: Dimensions.height15),
                SmallText(text: "Cash On Delivery"),
                SizedBox(height: Dimensions.height15),
                BigText(text: "Total Bill    $totalBill PKR"),
                SizedBox(height: Dimensions.height30),
                SizedBox(
                  width: double.infinity,
                  child: ReuseableButton(
                      text: "Place Order",
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          final userId = FirebaseAuth.instance.currentUser!.uid;
                          final name = nameController.text.trim();
                          final address = addressController.text.trim();
                          final city = cityController.text.trim();

                          final phoneNumber = phoneController.text.trim();
                          final zipCode = zipCodeController.text.trim();

                          final checkOutData = {
                            'customerName': name,
                            'address': address,
                            'city': city,
                            'phoneNumber': phoneNumber,
                            'zipCode': zipCode,
                            'userId': userId,
                            "orderAt": FieldValue.serverTimestamp(),
                            "products": cartProducts,
                            "totalBill": totalBill,
                          };
                          cartController.checkout(checkOutData);
                        } else {
                          Fluttertoast.showToast(
                              msg: "All the Fielda are Required ! ",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              timeInSecForIosWeb: 2,
                              backgroundColor: Colors.red,
                              textColor: Colors.white,
                              fontSize: Dimensions.font16);
                        }
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CheckoutDynamicTextField extends StatelessWidget {
  const CheckoutDynamicTextField({
    super.key,
    required this.label,
    required this.controller,
  });
  final String label;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validateAField,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    );
  }
}
