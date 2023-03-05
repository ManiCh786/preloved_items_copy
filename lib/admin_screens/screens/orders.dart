import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/controller.dart';
import '../../model/models.dart';
import '../../utils/utils.dart';
import '../../widget/widget.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _Orders();
}

class _Orders extends State<Orders> with TickerProviderStateMixin {
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
                    indicatorColor: Colors.blue,
                    indicatorWeight: 3,
                    tabs: [
                      Tab(
                          child: BigText(
                        text: "Pending",
                        color: Colors.black,
                      )),
                      Tab(
                          child: BigText(
                        text: "Shipped",
                        color: Colors.black,
                      )),
                    ]),
              ),
              Expanded(
                  child: StreamBuilder(
                      stream: cartController.getOrdersCollection(),
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
                            color: shippedOrderList[index]
                                        .status
                                        .toString()
                                        .toLowerCase() ==
                                    "rejected"
                                ? Colors.red
                                : Colors.green,
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
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text("Orders Management"),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: SizedBox(
          height: Get.height,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                BigText(
                  text: 'Order Details',
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
                      'Product Id ::   ${shippedOrderList[index].products!['pId']}',
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
                BigText(
                  size: Dimensions.font20,
                  color: shippedOrderList[index].products!['pInfo']['isBulk'] ==
                          true
                      ? Colors.red
                      : Colors.blue,
                  text: shippedOrderList[index].products!['pInfo']['isBulk'] ==
                          true
                      ? "Orders is in Bulk"
                      : "Single Product Order",
                ),
                SizedBox(height: Dimensions.height15),
                const Divider(
                  height: 2,
                  color: Colors.black,
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  text: 'Customer Details',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text:
                      'Customer Name ::   ${shippedOrderList[index].customerName}',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'Address  ::   ${shippedOrderList[index].address}',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'City ::   ${shippedOrderList[index].city}',
                ),
                SizedBox(height: Dimensions.height15),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text:
                      'Phone Number ::   ${shippedOrderList[index].phoneNumber}',
                ),
                SizedBox(height: Dimensions.height15),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'Zip Code  ::   ${shippedOrderList[index].zipCode}',
                ),
                SizedBox(height: Dimensions.height30),
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
    return Scaffold(
      body: ListView.builder(
          itemCount: orderList.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  final snapshotList = snapshot.data!.docs
                      .where((status) =>
                          status['OrderStatus'].toString().toLowerCase() ==
                          "pending")
                      .toList();

                  Get.to(() => PendingOrdersDescriptionScreen(
                        orderList: orderList,
                        index: index,
                        orderId: snapshotList[index].id,
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
                        offset:
                            const Offset(0, 1), // changes position of shadow
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
          }),
    );
  }
}

class PendingOrdersDescriptionScreen extends StatelessWidget {
  PendingOrdersDescriptionScreen({
    super.key,
    required this.orderList,
    required this.index,
    required this.orderId,
  });

  final List<OrderStatus> orderList;
  final int index;
  final String? orderId;

  final cartController = Get.find<CartController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(Icons.arrow_back)),
        title: const Text("Orders Management"),
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width15),
        child: SizedBox(
          height: Get.height,
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
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'Product Id ::   ${orderList[index].products!['pId']}',
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
                  text: 'Total Bill ::   ${orderList[index].totalBill}',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: orderList[index].products!['pInfo']['isBulk'] == true
                      ? Colors.red
                      : Colors.blue,
                  text: orderList[index].products!['pInfo']['isBulk'] == true
                      ? "Orders is in Bulk"
                      : "Single Product Order",
                ),
                SizedBox(height: Dimensions.height15),
                const Divider(
                  height: 2,
                  color: Colors.black,
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  text: 'Customer Details',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'Customer Name ::   ${orderList[index].customerName}',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'Address  ::   ${orderList[index].address}',
                ),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'City ::   ${orderList[index].city}',
                ),
                SizedBox(height: Dimensions.height15),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'Phone Number ::   ${orderList[index].phoneNumber}',
                ),
                SizedBox(height: Dimensions.height15),
                SizedBox(height: Dimensions.height15),
                BigText(
                  size: Dimensions.font20,
                  color: Colors.black,
                  text: 'Zip Code  ::   ${orderList[index].zipCode}',
                ),
                SizedBox(height: Dimensions.height30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        cartController.approveOrRjectOrder(orderId, 'shipped');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child:
                          BigText(text: "Approve Order", color: Colors.white),
                    ),
                    TextButton(
                      onPressed: () {
                        cartController.approveOrRjectOrder(orderId, 'rejected');
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: BigText(
                          text: "Reject/Delete Order", color: Colors.white),
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
