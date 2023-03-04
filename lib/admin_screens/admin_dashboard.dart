import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preloved_cloths/controllers/auth_controller.dart';

import '../controllers/controller.dart';
import '../data/app_data.dart';
import '../model/models.dart';
import '../utils/utils.dart';
import '../widget/confirmation_dialog.dart';
import '../widget/widget.dart';
import 'screens/screens.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<DrawerControllerState> _drawerKey = GlobalKey();
  List<Widget> _pages = [
    Dashboard(),
    UsersManagement(),
    Products(),
    Categories(),
    Orders(),
  ];
  @override
  Widget build(BuildContext context) {
    return GetX<DrawerHomeController>(
        init: DrawerHomeController(),
        initState: (_) {},
        builder: (logic) {
          return Scaffold(
              key: _scaffoldKey,
              appBar: AppBar(
                leading: IconButton(
                    icon: Icon(
                      Icons.menu,
                      color: Colors.white,
                      size: Dimensions.iconSize24,
                    ),
                    onPressed: () {
                      _scaffoldKey.currentState!.openDrawer();
                    }),
                backgroundColor: Colors.blue,
                elevation: 1.0,
                title: Text(
                  "Preloved Cloths Dasboard",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font20,
                  ),
                ),
              ),
              drawer: Drawer(
                key: _drawerKey,
                child: ListView(
                  padding: EdgeInsets.zero,
                  children: <Widget>[
                    DrawerHeader(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.blue[300]!,
                              Colors.red[400]!,
                            ],
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Admin Panel" ,
                              style:  TextStyle(
                                color: AppColors.textColor,
                                fontSize: Dimensions.font20,
                              ),
                            ),
                          ],
                        )),
                    DrawerListTile(
                      title: "Dashboard",
                      onTap: () {
                        Navigator.pop(context);
                        logic.updateNavCurrentIndex(0);
                      },
                      icon: Icons.dashboard,
                    ),
                    DrawerListTile(
                      title: "Users",
                      onTap: () {
                        Navigator.pop(context);
                        logic.updateNavCurrentIndex(1);
                      },
                      icon: Icons.person_3_outlined,
                    ),
                    DrawerListTile(
                      title: "Products",
                      onTap: () {
                        Navigator.pop(context);
                        logic.updateNavCurrentIndex(2);
                      },
                      icon: Icons.shopping_bag_rounded,
                    ),
                    DrawerListTile(
                      title: "Categories",
                      onTap: () {
                        Navigator.pop(context);
                        logic.updateNavCurrentIndex(3);
                      },
                      icon: Icons.integration_instructions,
                    ),
                    DrawerListTile(
                      title: "Orders",
                      onTap: () {
                        Navigator.pop(context);
                        logic.updateNavCurrentIndex(4);
                      },
                      icon: Icons.integration_instructions,
                    ),
                    DrawerListTile(
                      title: "Logout",
                      onTap: () {
                        AuthController.instance.logout();
                      },
                      icon: Icons.logout,
                    ),
                  ],
                ),
              ),
              body: _pages[logic.drawerCurrentIndex.value]);
        });
  }
}
