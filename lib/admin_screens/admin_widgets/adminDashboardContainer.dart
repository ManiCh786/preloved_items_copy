import 'package:flutter/material.dart';

import '../../utils/utils.dart';

class AdminDashboardContainer extends StatelessWidget {
  const AdminDashboardContainer({
    super.key,
    required this.width,
    required this.title,
    required this.titleValue,
    required this.subTitle,
    required this.subTitleValue,
  });

  final double width;
  final String title;
  final int titleValue;
  final String subTitle;
  final int subTitleValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(Dimensions.width10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue[300]!,
              Colors.red[400]!,
            ],
          ),
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        width: width * 0.40,
        child: Padding(
          padding: EdgeInsets.all(Dimensions.width15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                titleValue.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.font36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.height15),
              Text(
                subTitle.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.font16,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                subTitleValue.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: Dimensions.font26,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
