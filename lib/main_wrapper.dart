import 'package:animate_do/animate_do.dart';
import 'package:bottom_bar_matu/bottom_bar_matu.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:preloved_cloths/controllers/auth_controller.dart';

import '../screens/cart.dart';
import '../screens/home.dart';
import '../screens/search.dart';
import '../utils/constants.dart';
import 'screens/explore.dart';
import 'utils/utils.dart';
import 'widget/widget.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _index = 0;
  bool isSearchActive = false;

  List<Widget> screens = [
    const Home(),
    Search(catName: ""),
    const ExploreScreen(),
    const UserProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearchActive
            ? FadeIn(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  "Search",
                  style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              )
            : FadeIn(
                delay: const Duration(milliseconds: 300),
                child: Text(
                  _index == 0
                      ? "Home"
                      : _index == 1
                          ? "Search"
                          : _index == 2
                              ? "My Orders"
                              : "Profile",
                  style: TextStyle(
                      fontSize: Dimensions.font16,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
              ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            color: Colors.black,
            size: Dimensions.font26,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isSearchActive = !isSearchActive;
              });
            },
            icon: isSearchActive
                ? Icon(
                    LineIcons.searchMinus,
                    color: Colors.black,
                    size: Dimensions.iconSize30,
                  )
                : Icon(
                    LineIcons.search,
                    color: Colors.black,
                    size: Dimensions.iconSize30,
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                LineIcons.shoppingBag,
                color: Colors.black,
                size: Dimensions.iconSize30,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Cart(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: _index == 0
          ? isSearchActive
              ? Search(
                  catName: "",
                )
              : const Home()
          : screens[_index],
      bottomNavigationBar: BottomBarBubble(
        color: primaryColor,
        selectedIndex: _index,
        items: [
          BottomBarItem(iconData: Icons.home),
          BottomBarItem(iconData: Icons.search),
          BottomBarItem(iconData: Icons.shopping_bag_rounded),
          BottomBarItem(iconData: Icons.person),
        ],
        onSelect: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.maxFinite,
        margin: EdgeInsets.only(top: Dimensions.height20),
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                    child: CircularProgressIndicator(
                  color: AppColors.deepPink,
                ));
              } else if (!snapshot.hasData) {
                return Center(
                    child: BigText(
                  text: "No Record Found !",
                ));
              } else if (snapshot.hasData) {
                return Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: AppColors.yellowColor,
                      radius: Dimensions.screenHeight * 0.10,
                      backgroundImage:
                          NetworkImage(snapshot.data!['profileImageUrl']),
                    ),
                    SizedBox(height: Dimensions.height30),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AccountWidget(
                              iconButtonWidget: IconButtonWidget(
                                icon: Icons.person,
                                onPressed: () {},
                                iconColor: Colors.white,
                                backgroundColor: AppColors.mainColor,
                                iconSize: Dimensions.height10 * 5 / 2,
                                size: Dimensions.height10 * 5,
                              ),
                              bigText: BigText(
                                text:
                                    "${snapshot.data!['fName']}  ${snapshot.data!['lName']}" ??
                                        " ",
                              ),
                            ),
                            SizedBox(height: Dimensions.height30),
                            AccountWidget(
                              iconButtonWidget: IconButtonWidget(
                                icon: Icons.phone,
                                onPressed: () {},
                                iconColor: Colors.white,
                                backgroundColor: AppColors.yellowColor,
                                iconSize: Dimensions.height10 * 5 / 2,
                                size: Dimensions.height10 * 5,
                              ),
                              bigText: BigText(
                                text: snapshot.data!['phone'] ?? " ",
                              ),
                            ),
                            SizedBox(height: Dimensions.height30),
                            AccountWidget(
                              iconButtonWidget: IconButtonWidget(
                                icon: Icons.email,
                                onPressed: () {},
                                iconColor: Colors.white,
                                backgroundColor: AppColors.yellowColor,
                                iconSize: Dimensions.height10 * 5 / 2,
                                size: Dimensions.height10 * 5,
                              ),
                              bigText: BigText(
                                text: snapshot.data!['email'] ?? " ",
                              ),
                            ),
                            SizedBox(height: Dimensions.height30),
                            GestureDetector(
                              onTap: () {
                                AuthController.instance.logout();
                              },
                              child: AccountWidget(
                                iconButtonWidget: IconButtonWidget(
                                  icon: Icons.logout,
                                  onPressed: () {},
                                  iconColor: Colors.white,
                                  backgroundColor: Colors.redAccent,
                                  iconSize: Dimensions.height10 * 5 / 2,
                                  size: Dimensions.height10 * 5,
                                ),
                                bigText: BigText(
                                  text: "Logout",
                                ),
                              ),
                            ),
                            SizedBox(height: Dimensions.height20 * 2),
                          ],
                        ),
                      ),
                    )
                  ],
                );
              } else {
                return Text("");
              }
            }),
      ),
    );
  }
}
