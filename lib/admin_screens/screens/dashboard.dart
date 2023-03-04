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
    return Scaffold(
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: AuthController.instance.readUsersSnapshots(),
                  builder: (context, snapshot) {
                    final data =
                        snapshot.data?.docs.map((doc) => doc.data()).toList();

                    final usersAddedToday = snapshot.data?.docs
                        .map((doc) => doc.data())
                        .where((item) => (item['createdAt'] as Timestamp)
                            .toDate()
                            .isAfter(
                                DateTime.now().subtract(Duration(days: 1))))
                        .toList();
                    return GestureDetector(
                      onTap: () {
                        Future.delayed(Duration.zero).then((value) {
                          drawerController.updateNavCurrentIndex(1);
                        });
                      },
                      child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
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
                    final categories =
                        snapshot.data?.docs.map((doc) => doc.data()).toList();
                    final categoriesAddedToday = snapshot.data?.docs
                        .map((doc) => doc.data())
                        .where((item) => (item['createdAt'] as Timestamp)
                            .toDate()
                            .isAfter(
                                DateTime.now().subtract(Duration(days: 1))))
                        .toList();

                    return AdminDashboardContainer(
                      width: w,
                      title: "Total Categories",
                      subTitle: "Categories Added Today",
                      titleValue: categories?.length ?? 0,
                      subTitleValue: categoriesAddedToday?.length ?? 0,
                    );
                  }),
            ],
          )
        ],
      ),
    );
  }
}
