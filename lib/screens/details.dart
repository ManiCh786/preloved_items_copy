import 'package:animate_do/animate_do.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';
import '../model/base_model.dart';
import '../model/models.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../widget/expandealble_text_widget.dart';
import '../widget/widget.dart';

class Details extends StatefulWidget {
  const Details({
    required this.data,
    super.key,
    required this.isCameFromMostPopularPart,
    required this.isBulk,
    required this.pId,
  });

  final ProductsModel data;
  final bool isCameFromMostPopularPart;
  final bool isBulk;
  final String pId;

  @override
  State<Details> createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  int selectedSizeIndex = 0;

  int selectedColor = 0;
  double selectItemPrice = 0;

  bool isExpanded = false;
  final controller = Get.find<ProductDetailsPageController>();
  final cartController = Get.find<CartController>();

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;

    ProductsModel current = widget.data;

    if (widget.isBulk == true) {
      controller.initialQuantity = 50;
      controller.isBulk.value = true;
    } else {
      controller.initialQuantity = 1;
      controller.isBulk.value = false;
    }
    if (selectItemPrice == 0) {
      selectItemPrice =
          double.parse(current.sizes!.map((e) => e['price']).first.toString());
    }
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: _buildAppBar(context),
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: size.width,
                height: size.height * 0.5,
                child: Stack(
                  children: [
                    Hero(
                      tag: widget.isCameFromMostPopularPart
                          ? current.pImage!
                          : current.pImage!,
                      child: Container(
                        width: size.width,
                        height: size.height * 0.5,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: NetworkImage(current.pImage!),
                              fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: Container(
                        width: size.width,
                        height: size.height * 0.12,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: gradient),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// info
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: SizedBox(
                    width: size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              current.pName!,
                              style: textTheme.displaySmall
                                  ?.copyWith(fontSize: 22),
                            ),
                            ReuseableText(
                              price: double.parse(selectItemPrice.toString()),
                            )
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.006,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.add_alert_rounded,
                              color: Colors.orange,
                            ),
                            Text("Minimum Order ",
                                style: textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey)),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(current.isBulk == true ? "50" : "1",
                                style: textTheme.headlineSmall),
                            SizedBox(width: Dimensions.height10),
                            const SizedBox(
                              width: 5,
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
              //  Product Description

              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Padding(
                  padding: EdgeInsets.only(
                      left: Dimensions.width10,
                      top: Dimensions.height15,
                      bottom: Dimensions.width10),
                  child: Text(
                    "Description ",
                    style: textTheme.displaySmall,
                  ),
                ),
              ),
              const SizedBox(height: 2),

              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10.0),
                    child: ExpandableTextWidget(
                      firstHalfLength: 100,
                      text: current.pDesc!,
                      style: textTheme.bodyLarge!,
                    ),
                  ),
                ),
              ),

              /// Select size
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10.0,
                  ),
                  child: Text(
                    "Quantity",
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  padding: EdgeInsets.only(
                    top: Dimensions.height20,
                    bottom: Dimensions.height20,
                    left: Dimensions.width15,
                    right: Dimensions.width15,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(Dimensions.radius20),
                      color: Colors.white),
                  child: Row(
                    children: [
                      IconButtonWidget(
                        icon: Icons.remove,
                        backgroundColor: Colors.white,
                        iconColor: AppColors.signColor,
                        onPressed: () {
                          controller.countMinus();
                        },
                      ),
                      SizedBox(
                        width: Dimensions.width10 / 2,
                      ),
                      Obx(
                        () => BigText(
                          text: controller.count.toString(),
                        ),
                      ),
                      SizedBox(
                        width: Dimensions.width10 / 2,
                      ),
                      IconButtonWidget(
                        icon: Icons.add,
                        backgroundColor: Colors.white,
                        iconColor: AppColors.signColor,
                        onPressed: () {
                          controller.countPlus();
                        },
                      ),
                    ],
                  ),
                ),
              ]),
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, top: 18.0, bottom: 10.0),
                  child: Text(
                    "Select Size",
                    style: textTheme.bodyMedium,
                  ),
                ),
              ),

              ///Sizes
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: SizedBox(
                  // color: Colors.red,
                  width: size.width * 0.9,
                  height: size.height * 0.08,
                  child: ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: current.sizes!.length,
                      itemBuilder: (ctx, index) {
                        var curr =
                            current.sizes!.map((e) => e['size']).toList();
                        var prices =
                            current.sizes!.map((e) => e['price']).toList();
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedSizeIndex = index;
                              selectItemPrice = double.parse(prices[index]);
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: AnimatedContainer(
                              width: size.width * 0.12,
                              decoration: BoxDecoration(
                                color: selectedSizeIndex == index
                                    ? primaryColor
                                    : Colors.transparent,
                                border:
                                    Border.all(color: primaryColor, width: 2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              duration: const Duration(milliseconds: 200),
                              child: Center(
                                child: Text(
                                  curr[index].toString().toUpperCase(),
                                  style: TextStyle(
                                      fontSize: Dimensions.font14,
                                      fontWeight: FontWeight.w500,
                                      color: selectedSizeIndex == index
                                          ? Colors.white
                                          : Colors.black),
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),

              // /// Select Color
              // FadeInUp(
              //   delay: const Duration(milliseconds: 600),
              //   child: Padding(
              //     padding:
              //         const EdgeInsets.only(left: 10.0, top: 18.0, bottom: 10.0),
              //     child: Text(
              //       "Select Color",
              //       style: textTheme.headline3,
              //     ),
              //   ),
              // ),

              // ///Colors
              // FadeInUp(
              //   delay: const Duration(milliseconds: 700),
              //   child: SizedBox(
              //     width: size.width,
              //     height: size.height * 0.08,
              //     child: ListView.builder(
              //         physics: const BouncingScrollPhysics(),
              //         scrollDirection: Axis.horizontal,
              //         itemCount: colors.length,
              //         itemBuilder: (ctx, index) {
              //           var current = colors[index];
              //           return GestureDetector(
              //             onTap: () {
              //               setState(() {
              //                 selectedColor = index;
              //               });
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.all(10.0),
              //               child: AnimatedContainer(
              //                 width: size.width * 0.12,
              //                 decoration: BoxDecoration(
              //                   color: current,
              //                   border: Border.all(
              //                       color: selectedColor == index
              //                           ? primaryColor
              //                           : Colors.transparent,
              //                       width: selectedColor == index ? 2 : 1),
              //                   borderRadius: BorderRadius.circular(15),
              //                 ),
              //                 duration: const Duration(milliseconds: 200),
              //               ),
              //             ),
              //           );
              //         }),
              //   ),
              // ),

              /// Add To Cart Button
              FadeInUp(
                delay: const Duration(milliseconds: 800),
                child: Padding(
                  padding: EdgeInsets.only(top: size.height * 0.03),
                  child: ReuseableButton(
                    text: "Add to cart",
                    onTap: () {
                      final pId = widget.pId;
                      String? size;
                      for (int i = 0; i < current.sizes!.length; i++) {
                        if (i == selectedSizeIndex) {
                          size = current.sizes![selectedSizeIndex]['size'];
                        }
                      }
                      final userId = FirebaseAuth.instance.currentUser!.uid;
                      Map<String, dynamic> productInfo = {
                        "pName": current.pName,
                        "price": selectItemPrice,
                        "quantity": controller.count.value,
                        "pImage": current.pImage,
                        "isBulk": current.isBulk,
                        "size": size,
                      };
                      if (productInfo.isNotEmpty) {
                        final cartData = {
                          "userId": userId,
                          "pId": pId,
                          "pInfo": productInfo,
                          "createdAt": DateTime.now(),
                          "updatedAt": DateTime.now(),
                        };
                        cartController.addToCart(cartData);
                      } else {
                        print("empty");
                      }

                      // AddToCart.addToCart(current, context);
                    },
                  ),
                ),
              ),
            ],
          ),
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
}
