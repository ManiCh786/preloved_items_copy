import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:preloved_cloths/model/models.dart';

import '../controllers/controller.dart';
import '../utils/utils.dart';
import '../widget/reuseable_row_for_cart.dart';
import '../main_wrapper.dart';
import '../widget/reuseable_button.dart';
import '../widget/widget.dart';
import 'checkout.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

double shipping = 0.0;

class _CartState extends State<Cart> {
  final cartController = Get.find<CartController>();
  final controller = Get.find<ProductDetailsPageController>();
  double totalPrice = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              StreamBuilder(
                  stream: cartController.getAllCartProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.deepPink,
                      ));
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Column(
                        children: [
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 200),
                            child: const Image(
                              image: AssetImage("assets/images/empty.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.01,
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 250),
                            child: const Text(
                              "Your cart is empty right now :(",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400, fontSize: 16),
                            ),
                          ),
                          FadeInUp(
                            delay: const Duration(milliseconds: 300),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainWrapper()));
                              },
                              icon: const Icon(
                                Icons.shopping_bag_outlined,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      );
                    } else {
                      List<CartModel> cartList = snapshot.data!.docs
                          .map((document) => CartModel.fromFirestore(document))
                          .toList();
                      cartController.calculateCartTotal(cartList);

                      return SizedBox(
                        width: size.width,
                        height: size.height * 0.6,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            itemCount: cartList.length,
                            itemBuilder: (context, index) {
                              totalPrice = 0;
                              CartModel current = cartList[index];
                              final pInfo = current.pInfo;
                              Future.delayed(Duration.zero).then((value) {
                                controller.initialQuantity =
                                    int.parse(pInfo!['quantity'].toString());
                              });
                              return FadeInUp(
                                delay: Duration(milliseconds: 100 * index + 80),
                                child: SingleChildScrollView(
                                  child: Container(
                                    margin: const EdgeInsets.all(5.0),
                                    width: size.width,
                                    height: size.height * 0.25,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(5.0),
                                          decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                offset: Offset(0, 4),
                                                blurRadius: 4,
                                                color:
                                                    Color.fromARGB(61, 0, 0, 0),
                                              )
                                            ],
                                            color: Colors.pink,
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    pInfo!['pImage']),
                                                fit: BoxFit.cover),
                                          ),
                                          width: size.width * 0.4,
                                        ),
                                        SizedBox(
                                          height: size.height * 0.01,
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: size.width * 0.52,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      pInfo['pName'],
                                                      style: TextStyle(
                                                          fontSize: Dimensions
                                                              .font20),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {
                                                          cartController
                                                              .deleteFromCart(
                                                                  current.pId!);
                                                        },
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.grey,
                                                        ))
                                                  ],
                                                ),
                                              ),
                                              RichText(
                                                  text: TextSpan(
                                                      text: "PKR",
                                                      style: textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        fontSize:
                                                            Dimensions.font20,
                                                        color: primaryColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                    TextSpan(
                                                      text: pInfo['price']
                                                          .toString(),
                                                      style: textTheme
                                                          .bodyMedium
                                                          ?.copyWith(
                                                        fontSize:
                                                            Dimensions.font16,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )
                                                  ])),
                                              SizedBox(
                                                height: size.height * 0.04,
                                              ),
                                              Text(
                                                "Size = ${pInfo['size']}",
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                  fontSize: Dimensions.font16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ),
                                              Container(
                                                padding: EdgeInsets.only(
                                                  top: Dimensions.height20,
                                                  bottom: Dimensions.height20,
                                                  left: Dimensions.width15,
                                                  right: Dimensions.width15,
                                                ),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimensions
                                                                .radius20),
                                                    color: Colors.white),
                                                child: Row(
                                                  children: [
                                                    IconButtonWidget(
                                                      icon: Icons.remove,
                                                      backgroundColor:
                                                          Colors.white,
                                                      iconColor:
                                                          AppColors.signColor,
                                                      onPressed: () {
                                                        cartController
                                                            .decreaseQuantity(
                                                          current.pId!,
                                                          pInfo['quantity'],
                                                          pInfo['isBulk'],
                                                        );
                                                      },
                                                    ),
                                                    BigText(
                                                      text: pInfo['quantity']
                                                          .toString(),
                                                      color: Colors.black,
                                                    ),
                                                    IconButtonWidget(
                                                      icon: Icons.add,
                                                      backgroundColor:
                                                          Colors.white,
                                                      iconColor:
                                                          AppColors.signColor,
                                                      onPressed: () {
                                                        cartController
                                                            .incrementQuantity(
                                                                current.pId!,
                                                                pInfo[
                                                                    'quantity']);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      );
                    }
                  }),

              /// Bottom Card

              StreamBuilder(
                  stream: cartController.getAllCartProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.deepPink,
                      ));
                    } else {
                      List<CartModel> cartList = snapshot.data!.docs
                          .map((document) => CartModel.fromFirestore(document))
                          .toList();
                      cartController.calculateCartTotal(cartList);

                      return Positioned(
                        bottom: 0,
                        child: SingleChildScrollView(
                          child: Container(
                            width: size.width,
                            height: size.height * 0.40,
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: Dimensions.width10,
                                  vertical: 12.0),
                              child: Column(
                                children: [
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 350),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "To Pay ",
                                          style: textTheme.bodyMedium?.copyWith(
                                              fontSize: Dimensions.font16),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_sharp,
                                          color: Colors.grey,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  FadeInUp(
                                    delay: Duration.zero,
                                    child: ReuseableRowForCart(
                                      price: double.parse(
                                          cartController.cartTotal.toString()),
                                      text: 'Sub Total',
                                    ),
                                  ),
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 450),
                                    child: ReuseableRowForCart(
                                      price:
                                          (cartController.cartTotal.toDouble() *
                                              0.05),
                                      text: 'Shipping',
                                    ),
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.0),
                                    child: Divider(),
                                  ),
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 500),
                                    child: ReuseableRowForCart(
                                      price: (cartController.cartTotal
                                              .toDouble() +
                                          (cartController.cartTotal.toDouble() *
                                              0.05)),
                                      text: 'Total',
                                    ),
                                  ),
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 550),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: Dimensions.height15),
                                      child: ReuseableButton(
                                          text: "Checkout",
                                          onTap: () {
                                            if (cartList.isEmpty) {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Your cart is Empty Can't Checkout",
                                                  toastLength:
                                                      Toast.LENGTH_SHORT,
                                                  gravity: ToastGravity.BOTTOM,
                                                  timeInSecForIosWeb: 2,
                                                  backgroundColor: Colors.red,
                                                  textColor: Colors.white,
                                                  fontSize: Dimensions.font16);
                                            } else {
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          CheckoutPage(
                                                            cartProducts:
                                                                cartList,
                                                            totalBill: (cartController
                                                                    .cartTotal
                                                                    .toDouble() +
                                                                (cartController
                                                                        .cartTotal
                                                                        .toDouble() *
                                                                    0.05)),
                                                          )));
                                            }
                                          }),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        "My Cart",
        style: TextStyle(
            fontSize: Dimensions.font16,
            fontWeight: FontWeight.w500,
            color: Colors.black),
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
          color: Colors.black,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            LineIcons.user,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
