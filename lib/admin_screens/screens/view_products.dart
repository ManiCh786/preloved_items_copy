import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/controller.dart';
import '../../data/app_data.dart';
import '../../model/models.dart';
import '../../utils/utils.dart';
import '../../widget/widget.dart';
import 'add_product_screen.dart';
import 'product_desc.dart';

class Products extends StatelessWidget {
  final productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10, vertical: Dimensions.height10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "All Products",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font20,
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () {
                    // Get.to(() => ProductForm());
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: Dimensions.iconSize24,
                      ),
                      Text(
                        "Add Product",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: Dimensions.font20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
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
                  } else if (snapshot.hasData) {
                    List<ProductsModel> productsList = snapshot.data!.docs
                        .map(
                            (document) => ProductsModel.fromFirestore(document))
                        .toList();

                    return ListView.builder(
                      itemCount: productsList.length,
                      itemBuilder: (context, index) {
                        ProductsModel current = productsList[index];

                        return SizedBox(
                          height: Dimensions.height80,
                          width: width * 0.90,
                          child: Card(
                            elevation: 2.0,
                            margin: EdgeInsets.only(
                                right: Dimensions.width10,
                                bottom: 4.0,
                                top: 4.0),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(Dimensions.radius15),
                              side: BorderSide(
                                  color: Colors.grey.shade200, width: 1.0),
                            ),
                            child: ListTile(
                              onTap: () {
                                // Navigator.push(context, MaterialPageRoute(
                                //   builder: (context) {
                                //     return ProductsDetailsPage(
                                //       data: current,
                                //       pId: snapshot.data!.docs[index].id,
                                //       isCameFromMostPopularPart: false,
                                //     );
                                //   },
                                // ));
                              },
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                  current.pImage!,
                                ),
                                radius: Dimensions.radius30,
                              ),
                              title: Text(current.pName!.capitalizeFirst!),
                              subtitle: Text(
                                  "${current.sizes!.map((e) => e['price'])}  PKR"),
                              trailing: IconButton(
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  final pId = snapshot.data!.docs[index].id;
                                  final imageUrl = current.pImage;
                                  ConfirmationDialog.showConfirmationDialog(
                                    'Confirm Action',
                                    'Are you sure you want to delete this Product ?',
                                    () => productController.deleteProduct(
                                        pId, imageUrl!),
                                    Colors.red,
                                    Colors.grey,
                                    Colors.white,
                                  );
                                },
                              ),
                              // trailing: IconButton(
                              //   icon: const Icon(
                              //     Icons.delete,
                              //     color: Colors.red,
                              //   ),
                              //   onPressed: () {},
                              // ),
                              tileColor: Colors.white,
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return Text("");
                  }
                }),
          ),
        ],
      ),
    );
  }
}
