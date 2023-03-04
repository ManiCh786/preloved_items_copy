import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';

import '../controllers/controller.dart';
import '../model/base_model.dart';
import '../model/models.dart';
import '../utils/constants.dart';
import '../utils/utils.dart';
import '../data/app_data.dart';
import '../screens/details.dart';
import '../widget/widget.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreen();
}

class _ExploreScreen extends State<ExploreScreen> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();

    super.initState();
  }

  final productController = Get.find<ProductController>();

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
              StreamBuilder(
                  stream: productController.getAllProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.deepPink,
                      ));
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: BigText(
                        text: "No Record Found !",
                        color: Colors.black,
                      ));
                    } else {
                      List<ProductsModel> productsList = snapshot.data!.docs
                          .map((document) =>
                              ProductsModel.fromFirestore(document))
                          .toList();

                      return Expanded(
                        child: productsList.isNotEmpty

                            ? GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: productsList.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        childAspectRatio: 0.63),
                                itemBuilder: (context, index) {
                                  final pId = snapshot.data!.docs[index].id;

                                  ProductsModel current = productsList[index];

                                  return FadeInUp(
                                    delay: Duration(milliseconds: 100 * index),
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                            return Details(
                                              data: current,
                                              isCameFromMostPopularPart: false,
                                              isBulk: current.isBulk!,
                                              pId: pId,
                                            );
                                          }),
                                        );
                                      },
                                      child: Hero(
                                        tag: pId,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned(
                                              top: size.height * 0.02,
                                              left: size.width * 0.01,
                                              right: size.width * 0.01,
                                              child: Container(
                                                width: size.width * 0.5,
                                                height: size.height * 0.28,
                                                margin:
                                                    const EdgeInsets.all(10),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                  image: DecorationImage(
                                                    image: NetworkImage(
                                                        current.pImage!),
                                                    fit: BoxFit.cover,
                                                  ),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      offset: Offset(0, 4),
                                                      blurRadius: 4,
                                                      color: Color.fromARGB(
                                                          61, 0, 0, 0),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: size.height * 0.04,
                                              child: Text(
                                                current.pName!,
                                                style: textTheme.headline2,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: size.height * 0.01,
                                              child: RichText(
                                                  text: TextSpan(
                                                      text: "PKR",
                                                      style: textTheme.subtitle2
                                                          ?.copyWith(
                                                        color: primaryColor,
                                                        fontSize:
                                                            Dimensions.font20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                      children: [
                                                    TextSpan(
                                                      text: current.sizes!
                                                          .map(
                                                              (e) => e['price'])
                                                          .first
                                                          .toString(),
                                                      style: textTheme.subtitle2
                                                          ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    )
                                                  ])),
                                            ),
                                            Positioned(
                                              top: size.height * 0.01,
                                              right: 0,
                                              child: CircleAvatar(
                                                backgroundColor: primaryColor,
                                                child: IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    LineIcons.addToShoppingCart,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                })

                            : Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    height: size.height * 0.02,
                                  ),
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 200),
                                    child: const Image(
                                      image: AssetImage(
                                          "assets/images/search_fail.png"),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * 0.01,
                                  ),
                                  FadeInUp(
                                    delay: const Duration(milliseconds: 250),
                                    child: Text(
                                      "No Result Found :(",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: Dimensions.font16),
                                    ),
                                  ),
                                ],
                              ),
                      );
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
