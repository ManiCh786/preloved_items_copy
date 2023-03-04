import 'package:flutter/material.dart';

import '../utils/utils.dart';

class DrawerListTile extends StatelessWidget {
   DrawerListTile({Key? key, required this.icon, required this.title,  this.iconColor=Colors.black, this.iconSize=24, required this.onTap}) : super(key: key);
   final IconData icon;
   final String title;
   final Color iconColor;
   final double iconSize;
   final Function onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon,size: iconSize,color: iconColor),
      title: Text(title,style: TextStyle(
        color: Colors.black,
        fontSize: Dimensions.font20,
      ),),
      onTap:()=> onTap(),
    );
  }
}
