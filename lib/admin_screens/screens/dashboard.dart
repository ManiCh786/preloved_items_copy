import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/controller.dart';
import '../admin_screens.dart';
import '../admin_widgets/admin_widgets.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;

    double w = MediaQuery.of(context).size.width;
    final drawerController = Get.find<DrawerHomeController>();
    final categoryController = Get.find<CategoryController>();
    final productsController = Get.find<ProductController>();
    final cartController = Get.find<CartController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: AuthController.instance.readUsersSnapshots(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs
                            .map((doc) => doc.data())
                            .toList();

                        final usersAddedToday = snapshot.data?.docs
                            .map((doc) => doc.data())
                            .where((item) => (item['createdAt'] as Timestamp)
                                .toDate()
                                .isAfter(DateTime.now()
                                    .subtract(const Duration(days: 1))))
                            .toList();
                        return GestureDetector(
                          onTap: () {
                            Future.delayed(Duration.zero).then((value) {
                              drawerController.updateNavCurrentIndex(1);
                            });
                          },
                          child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                              stream: null,
                              builder: (context, snapshot) {
                                return AdminDashboardContainer(
                                  width: w,
                                  title: "Total Users",
                                  subTitle: "New Users \nToday    ",
                                  titleValue: data?.length ?? 0,
                                  subTitleValue: usersAddedToday?.length ?? 0,
                                );
                              }),
                        );
                      }),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: categoryController.readAllCategories(),
                      builder: (context, snapshot) {
                        final categories = snapshot.data?.docs
                            .map((doc) => doc.data())
                            .toList();
                        final categoriesAddedToday = snapshot.data?.docs
                            .map((doc) => doc.data())
                            .where((item) => (item['createdAt'] as Timestamp)
                                .toDate()
                                .isAfter(
                                    DateTime.now().subtract(Duration(days: 1))))
                            .toList();

                        return GestureDetector(
                          onTap: () {
                            Future.delayed(Duration.zero).then((value) {
                              drawerController.updateNavCurrentIndex(3);
                            });
                          },
                          child: AdminDashboardContainer(
                            width: w,
                            title: "Total Categories",
                            subTitle: "Categories Added Today",
                            titleValue: categories?.length ?? 0,
                            subTitleValue: categoriesAddedToday?.length ?? 0,
                          ),
                        );
                      }),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: productsController.getAllProducts(),
                      builder: (context, snapshot) {
                        final data = snapshot.data?.docs
                            .map((doc) => doc.data())
                            .toList();

                        final productsAddedToday = snapshot.data?.docs
                            .map((doc) => doc.data())
                            .where((item) => (item['createdAt'] as Timestamp)
                                .toDate()
                                .isAfter(DateTime.now()
                                    .subtract(const Duration(days: 1))))
                            .toList();
                        return GestureDetector(
                          onTap: () {
                            Future.delayed(Duration.zero).then((value) {
                              drawerController.updateNavCurrentIndex(2);
                            });
                          },
                          child: StreamBuilder<
                                  QuerySnapshot<Map<String, dynamic>>>(
                              stream: null,
                              builder: (context, snapshot) {
                                return AdminDashboardContainer(
                                  width: w,
                                  title: "Total Products",
                                  subTitle: "New Products \nToday    ",
                                  titleValue: data?.length ?? 0,
                                  subTitleValue:
                                      productsAddedToday?.length ?? 0,
                                );
                              }),
                        );
                      }),
                  StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                      stream: cartController.getOrdersCollection(),
                      builder: (context, snapshot) {
                        final orders = snapshot.data?.docs
                            .map((doc) => doc.data())
                            .toList();
                        final ordersToday = snapshot.data?.docs
                            .map((doc) => doc.data())
                            .where((item) => (item['orderAt'] as Timestamp)
                                .toDate()
                                .isAfter(DateTime.now()
                                    .subtract(const Duration(days: 1))))
                            .where(
                                (status) => status['OrderStatus'] == "pending")
                            .toList();

                        return GestureDetector(
                          onTap: () {
                            Future.delayed(Duration.zero).then((value) {
                              drawerController.updateNavCurrentIndex(4);
                            });
                          },
                          child: AdminDashboardContainer(
                            width: w,
                            title: "Total Orders",
                            subTitle: "New Orders  \nToday",
                            titleValue: orders?.length ?? 0,
                            subTitleValue: ordersToday?.length ?? 0,
                          ),
                        );
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
