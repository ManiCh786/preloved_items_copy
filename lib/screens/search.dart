import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_icons/line_icons.dart';
import 'package:preloved_cloths/model/models.dart';
import '../controllers/controller.dart';
import '../screens/details.dart';
import '../utils/utils.dart';
import '../widget/widget.dart';

class Search extends StatefulWidget {
  Search({super.key, required this.catName});
  String catName = "";

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController();
    _selectedCategory = "";
    _selectedSeason = "";
    super.initState();
  }

  onSearch(String search) {
    if (widget.catName.isEmpty) {
      setState(() {});
    }
  }

  final productController = Get.find<ProductController>();
  final categoryController = Get.find<CategoryController>();

  String? _selectedCategory = "";

  final List<String> _season = ['Summer', 'Winter'];
  String? _selectedSeason = "";

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
              FadeInUp(
                delay: const Duration(milliseconds: 50),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
                  child: SizedBox(
                    width: size.width,
                    height: size.height * 0.07,
                    child: Center(
                      child: TextField(
                        controller: controller,
                        onChanged: (value) {
                          onSearch(value);
                        },
                        onSubmitted: onSearch(controller.text),
                        style: textTheme.displaySmall?.copyWith(
                            fontSize: Dimensions.font16,
                            fontWeight: FontWeight.w400),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          filled: true,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.clear();
                            },
                            icon: const Icon(Icons.close),
                          ),
                          hintStyle: textTheme.displaySmall?.copyWith(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[600],
                          ),
                          hintText: "e,g.Casual Jeans",
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(13),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              filtersMethod(size),
              SizedBox(
                height: size.height * 0.01,
              ),
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
                          .where((e) => e.pName
                              .toString()
                              .toLowerCase()
                              .contains(controller.text.toLowerCase().trim()))
                          .toList();
                      if (widget.catName.isNotEmpty) {
                        productsList = snapshot.data!.docs
                            .where((product) {
                              return product['category'].any((category) =>
                                  category.toString().toLowerCase() ==
                                  widget.catName.toLowerCase());
                            })
                            .map((document) =>
                                ProductsModel.fromFirestore(document))
                            .toList();
                      } else if (_selectedCategory.toString().isNotEmpty) {
                        _selectedSeason = "summer";
                        productsList = productsList
                            .where((product) {
                              return product.category!.any((category) =>
                                  category.toString().toLowerCase() ==
                                  _selectedCategory.toString().toLowerCase());
                            })
                            .where((e) =>
                                e.forSeason.toString().toLowerCase() ==
                                _selectedSeason.toString().toLowerCase())
                            .toList();
                      } else if (_selectedSeason.toString().isNotEmpty) {
                        productsList = productsList
                            .where((e) =>
                                e.forSeason.toString().toLowerCase() ==
                                _selectedSeason.toString().toLowerCase())
                            .toList();
                      }

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
                                  ProductsModel current = productsList[index];
                                  return FadeInUp(
                                    delay: Duration(milliseconds: 100 * index),
                                    child: GestureDetector(
                                      onTap: (() => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                              FocusManager.instance.primaryFocus
                                                  ?.unfocus();
                                              return Details(
                                                isBulk: false,
                                                data: current,
                                                pId: snapshot
                                                    .data!.docs[index].id,
                                                isCameFromMostPopularPart:
                                                    false,
                                              );
                                            }),
                                          )),
                                      child: Hero(
                                        tag: current.pName!.toString(),
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
                                                style: textTheme.displayMedium,
                                              ),
                                            ),
                                            Positioned(
                                              bottom: size.height * 0.01,
                                              child: RichText(
                                                  text: TextSpan(
                                                      text: "PKR  - ",
                                                      style: textTheme
                                                          .bodyMedium!
                                                          .copyWith(
                                                        color: primaryColor,
                                                        fontSize:
                                                            Dimensions.font16,
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
                                                      style: textTheme.bodyLarge
                                                          ?.copyWith(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize:
                                                                  Dimensions
                                                                      .font20),
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
                            : SingleChildScrollView(
                                child: Column(
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
                                      child: const Text(
                                        "No Result Found :(",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 16),
                                      ),
                                    ),
                                  ],
                                ),
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

  FadeInUp filtersMethod(Size size) {
    return FadeInUp(
        delay: const Duration(milliseconds: 50),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: size.width * 0.03),
            child: SizedBox(
              width: size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Category',
                            style: TextStyle(
                              fontSize: Dimensions.font16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedCategory = "";
                                _selectedSeason = "";
                              });
                            },
                            child: Text(
                              'Clear Filters',
                              style: TextStyle(
                                fontSize: Dimensions.font14,
                                color: AppColors.yellowColor,
                                fontWeight: FontWeight.w100,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      StreamBuilder(
                          stream: categoryController.readAllCategories(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Text('');
                            } else if (snapshot.data!.docs.isEmpty) {
                              return Center(
                                  child: BigText(
                                text: "No Category Added !",
                                color: Colors.black,
                              ));
                            } else {
                              List<CategoriesModel> categoriesList = snapshot
                                  .data!.docs
                                  .map((document) =>
                                      CategoriesModel.fromFirestore(document))
                                  .toList();

                              return Wrap(
                                spacing: 8,
                                children: categoriesList.map((category) {
                                  return FilterChip(
                                    label: Text(category.catName!),
                                    selected:
                                        _selectedCategory == category.catName,
                                    onSelected: (isSelected) {
                                      setState(() {
                                        _selectedCategory = isSelected
                                            ? category.catName
                                            : null;
                                      });
                                    },
                                  );
                                }).toList(),
                              );
                            }
                          }),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Season',
                        style: TextStyle(
                          fontSize: Dimensions.font16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Wrap(
                        spacing: 8,
                        children: _season.map((season) {
                          return FilterChip(
                            label: Text(season),
                            selected: _selectedSeason == season,
                            onSelected: (isSelected) {
                              setState(() {
                                _selectedSeason = isSelected ? season : null;
                              });
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ],
              ),
            )));
  }
}
