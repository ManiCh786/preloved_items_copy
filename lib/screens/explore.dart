
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controller.dart';
import '../model/models.dart';
import '../utils/utils.dart';
import '../widget/widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreen();
}

class _ExploreScreen extends State<ExploreScreen>
    with TickerProviderStateMixin {
  late TextEditingController controller;
  late final TabController _tabController;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
    if (FirebaseAuth.instance.currentUser!.uid.isNotEmpty) {
      _tabController = TabController(length: 2, vsync: this);
    }
  }

  final cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          width: size.width,
          height: size.height,
          child: Column(
            children: [
              Container(
                width: Get.width,
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: AppColors.yellowColor,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                          child: BigText(
                        text: "Current",
                        color: Colors.black,
                      )),
                      Tab(
                          child: BigText(
                        text: "History",
                        color: Colors.black,
                      )),
                    ]),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: cartController.allOrders(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator(
                            color: AppColors.deepPink,
                          ));
                        } else {
                          List<OrderStatus> orderList = snapshot.data!.docs
                              .where((status) =>
                                  status['OrderStatus']
                                      .toString()
                                      .toLowerCase() ==
                                  "pending")
                              .map((document) =>
                                  OrderStatus.fromFirestore(document))
                              .toList();

                          List<OrderStatus> shippedOrderList = snapshot
                              .data!.docs
                              .where((status) =>
                                  status['OrderStatus']
                                      .toString()
                                      .toLowerCase() !=
                                  "pending")
                              .map((document) =>
                                  OrderStatus.fromFirestore(document))
                              .toList();

                          return TabBarView(
                            controller: _tabController,
                            children: [
                              orderList.isEmpty
                                  ? Center(
                                      child: BigText(
                                          text: "Nothing to Show Here !"),
                                    )
                                  : PendingOrdersWidget(
                                      orderList: orderList,
                                      snapshot: snapshot,
                                    ),
                              shippedOrderList.isEmpty
                                  ? Center(
                                      child: BigText(
                                          text: "Nothing to Show Here !"),
                                    )
                                  : ShippedOrdersWidget(
                                      snapshot: snapshot,
                                      shippedOrderList: shippedOrderList),
                            ],
                          );
                        }
                      }))
            ],
          ),
        ),
      ),
    );
  }
}

class ShippedOrdersWidget extends StatelessWidget {
  const ShippedOrdersWidget({
    super.key,
    required this.shippedOrderList,
    required this.snapshot,
  });

  final List<OrderStatus> shippedOrderList;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: shippedOrderList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.dialog(ViewOrderProductDetailDialog(
                    index: index, shippedOrderList: shippedOrderList));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Id  #${snapshot.data!.docs[index].id}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.font16,
                          ),
                        ),
                        Text(
                          "${shippedOrderList[index].status}",
                          style: TextStyle(
                            color:  shippedOrderList[index].status== "shipped" ? Colors.green :Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.font16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                      'Ordered on ${shippedOrderList[index].orderAt!.toDate()} ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimensions.font16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class ViewOrderProductDetailDialog extends StatelessWidget {
  const ViewOrderProductDetailDialog({
    super.key,
    required this.shippedOrderList,
    required this.index,
  });

  final List<OrderStatus> shippedOrderList;
  final int index;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: SizedBox(
          height: Get.height * 0.4,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BigText(
                  text: 'Product Details',
                ),
                SizedBox(height: Dimensions.height15),
                const Divider(
                  height: 2,
                  color: Colors.black,
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text:
                      'Product Name ::   ${shippedOrderList[index].products!['pInfo']['pName']}',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text:
                      'Price ::   ${shippedOrderList[index].products!['pInfo']['price']} PKR',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text:
                      'Quantity ::   ${shippedOrderList[index].products!['pInfo']['quantity']}',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text:
                      'Size ::   ${shippedOrderList[index].products!['pInfo']['size']}',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'Total Bill ::   ${shippedOrderList[index].totalBill}',
                ),
                SizedBox(height: Dimensions.height15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Get.back(),
                      child: SmallText(
                          text: 'Close',
                          size: Dimensions.font16,
                          color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PendingOrdersWidget extends StatelessWidget {
  const PendingOrdersWidget({
    super.key,
    required this.orderList,
    required this.snapshot,
  });

  final List<OrderStatus> orderList;
  final AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: orderList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.dialog(Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(Dimensions.width15),
                    child: SizedBox(
                      height: Get.height * 0.4,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            BigText(
                              text: 'Product Details',
                            ),
                            SizedBox(height: Dimensions.height15),
                            const Divider(
                              height: 2,
                              color: Colors.black,
                            ),
                            SizedBox(height: Dimensions.height15),
                            BigText(
                              size: Dimensions.font20,
                              color: Colors.black,
                              text:
                                  'Product Name ::   ${orderList[index].products!['pInfo']['pName']}',
                            ),
                            SizedBox(height: Dimensions.height15),
                            BigText(
                              size: Dimensions.font20,
                              color: Colors.black,
                              text:
                                  'Price ::   ${orderList[index].products!['pInfo']['price']} PKR',
                            ),
                            SizedBox(height: Dimensions.height15),
                            BigText(
                              size: Dimensions.font20,
                              color: Colors.black,
                              text:
                                  'Quantity ::   ${orderList[index].products!['pInfo']['quantity']}',
                            ),
                            SizedBox(height: Dimensions.height15),
                            BigText(
                              size: Dimensions.font20,
                              color: Colors.black,
                              text:
                                  'Size ::   ${orderList[index].products!['pInfo']['size']}',
                            ),
                            SizedBox(height: Dimensions.height15),
                            BigText(
                              size: Dimensions.font20,
                              color: Colors.black,
                              text:
                                  'Total Bill ::   ${orderList[index].totalBill}',
                            ),
                            SizedBox(height: Dimensions.height15),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () => Get.back(),
                                  child: SmallText(
                                      text: 'Close',
                                      size: Dimensions.font16,
                                      color: Colors.red),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ));
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 2,
                      offset: const Offset(0, 1), // changes position of shadow
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(
                    horizontal: Dimensions.width15,
                    vertical: Dimensions.height10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Order Id  #${snapshot.data!.docs[index].id}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.font16,
                          ),
                        ),
                        Text(
                          " ${orderList[index].status}",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: Dimensions.font16,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: Dimensions.height10),
                    Text(
                      'Ordered on ${orderList[index].orderAt!.toDate()} ',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: Dimensions.font16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}
