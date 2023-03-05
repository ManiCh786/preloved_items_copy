import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:preloved_cloths/controllers/product_controller.dart';
import 'package:preloved_cloths/screens/search.dart';

import '../controllers/category_controller.dart';
import '../model/models.dart';
import '../screens/details.dart';
import '../utils/utils.dart';
import '../widget/widget.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late PageController _pageController;
  final int _currentIndex = 2;

  @override
  void initState() {
    _pageController =
        PageController(initialPage: _currentIndex, viewportFraction: 0.7);
    super.initState();
  }

  final categoryController = Get.find<CategoryController>();
  final productController = Get.find<ProductController>();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var textTheme = Theme.of(context).textTheme;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Top Text
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: Padding(
                  padding: EdgeInsets.all(Dimensions.height10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          text: "Find your",
                          style: textTheme.headlineLarge,
                          children: [
                            TextSpan(
                              text: " Style",
                              style: textTheme.headlineMedium!.copyWith(
                                color: Colors.orange,
                                fontSize: Dimensions.font50,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Be more beautiful with our ",
                          style: TextStyle(
                            color: const Color.fromARGB(186, 0, 0, 0),
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w400,
                          ),
                          children: const [
                            TextSpan(
                              text: "suggestions :)",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /// Categories
              StreamBuilder(
                  stream: categoryController.readAllCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Text("");
                    } else if (snapshot.data!.docs.isEmpty) {
                      return Center(
                          child: BigText(
                        text: "No Category Added !",
                        color: Colors.black,
                      ));
                    } else {
                      return FadeInUp(
                        delay: const Duration(milliseconds: 450),
                        child: Container(
                          margin: const EdgeInsets.only(top: 7),
                          width: size.width,
                          height: size.height * 0.2,
                          child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data!.docs.length,
                              itemBuilder: (ctx, index) {
                                List<CategoriesModel> categoriesList = snapshot
                                    .data!.docs
                                    .map((document) =>
                                        CategoriesModel.fromFirestore(document))
                                    .toList();

                                CategoriesModel current = categoriesList[index];
                                return Padding(
                                  padding: EdgeInsets.all(Dimensions.height10),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Search(
                                            catName: current.catName!,
                                          ),
                                        ),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        CircleAvatar(
                                          radius: Dimensions.radius30,
                                          backgroundImage: NetworkImage(
                                              current.catImageUrl!),
                                        ),
                                        SizedBox(
                                          height: size.height * 0.008,
                                        ),
                                        Text(
                                          current.catName!,
                                          style: textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        ),
                      );
                    }
                  }),

              /// Body Slider
              StreamBuilder(
                  stream: productController.getAllProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator(
                        color: AppColors.yellowColor,
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
                          .where((e) => e.isBulk == true)
                          .toList();
                      return FadeInUp(
                        delay: const Duration(milliseconds: 550),
                        child: Container(
                          margin: EdgeInsets.only(top: Dimensions.height10),
                          width: size.width,
                          height: size.height * 0.45,
                          child: PageView.builder(
                            controller: _pageController,
                            itemCount: productsList.length,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                  onTap: () {
                                    final pId = snapshot.data!.docs[index].id;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Details(
                                          data: productsList[index],
                                          isCameFromMostPopularPart: false,
                                          isBulk: true,
                                          pId: pId,
                                        ),
                                      ),
                                    );
                                  },
                                  child: view(
                                      index, textTheme, size, productsList));
                            },
                          ),
                        ),
                      );
                    }
                  }),

              /// Most Popular Text
              FadeInUp(
                delay: const Duration(milliseconds: 650),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width10,
                      vertical: Dimensions.height10 - 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Most Popular", style: textTheme.bodyMedium),
                      Text("See all", style: textTheme.bodyMedium),
                    ],
                  ),
                ),
              ),

              /// Most Popular Content
              FadeInUp(
                delay: const Duration(milliseconds: 750),
                child: StreamBuilder(
                    stream: productController.getAllProducts(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator(
                          color: AppColors.yellowColor,
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
                            .where((e) => e.isBulk != true)
                            .toList();
                        return Container(
                          margin: EdgeInsets.only(top: Dimensions.height10),
                          width: size.width,
                          height: size.height * 0.44,
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              itemCount: 1,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio: 0.59),
                              itemBuilder: (context, index) {
                                ProductsModel current = productsList[index];
                                final pId = snapshot.data!.docs[index].id;

                                return GestureDetector(
                                  onTap: (() => Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          return Details(
                                            data: current,
                                            isCameFromMostPopularPart: true,
                                            isBulk: false,
                                            pId: pId,
                                          );
                                        }),
                                      )),
                                  child: Hero(
                                    tag: current.pImage!,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: size.width * 0.5,
                                          height: size.height * 0.3,
                                          margin: EdgeInsets.all(
                                              Dimensions.height10),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(3),
                                            image: DecorationImage(
                                              image:
                                                  NetworkImage(current.pImage!),
                                              fit: BoxFit.cover,
                                            ),
                                            boxShadow: const [
                                              BoxShadow(
                                                offset: Offset(0, 4),
                                                blurRadius: 4,
                                                color:
                                                    Color.fromARGB(61, 0, 0, 0),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 2.0),
                                          child: Text(
                                            current.pName!,
                                            style: textTheme.bodyMedium,
                                          ),
                                        ),
                                        RichText(
                                            text: TextSpan(
                                                text: "PKR  ",
                                                style: textTheme.bodyMedium!
                                                    .copyWith(
                                                  color: primaryColor,
                                                  fontSize: Dimensions.font16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                children: [
                                              TextSpan(
                                                text: current.sizes!
                                                    .map((e) => e['price'])
                                                    .first
                                                    .toString(),
                                                style: textTheme.bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize:
                                                            Dimensions.font26),
                                              )
                                            ])),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                        );
                      }
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Page View
  Widget view(int index, TextTheme theme, Size size, productsList) {
    return AnimatedBuilder(
        animation: _pageController,
        builder: (context, child) {
          double value = 0.0;
          if (_pageController.position.haveDimensions) {
            value = index.toDouble() - (_pageController.page ?? 0);
            value = (value * 0.04).clamp(-1, 1);
          }
          return Transform.rotate(
            angle: 3.14 * value,
            child: card(productsList[index], theme, size),
          );
        });
  }

  /// Page view Cards
  Widget card(ProductsModel data, TextTheme theme, Size size) {
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.height15),
      child: Column(
        children: [
          Hero(
            tag: data.pName!,
            child: Container(
              width: size.width * 0.6,
              height: size.height * 0.35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                image: DecorationImage(
                  // image: NetworkImage(data.pImage!),
                  image: NetworkImage(data.pImage!),
                  fit: BoxFit.cover,
                ),
                boxShadow: const [
                  BoxShadow(
                      offset: Offset(0, 4),
                      blurRadius: 4,
                      color: Color.fromARGB(61, 0, 0, 0))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              data.pName!,
              style: theme.bodyMedium,
            ),
          ),
          RichText(
            text: TextSpan(
              text: "PKR ",
              style: theme.bodyMedium!.copyWith(
                color: primaryColor,
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.bold,
              ),
              children: [
                TextSpan(
                  text: data.sizes!.map((e) => e['price']).first.toString(),
                  style: theme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600, fontSize: Dimensions.font26),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
