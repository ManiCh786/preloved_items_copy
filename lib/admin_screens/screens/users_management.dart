import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controllers/controller.dart';
import '../../utils/utils.dart';
import '../../widget/widget.dart';

class UsersManagement extends StatelessWidget {
  const UsersManagement({super.key});

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: StreamBuilder(
     
          stream: AuthController.instance.readUsersSnapshots(),
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
            }
            if (snapshot.hasData) {
              final documents = snapshot.data!.docs
                  .where((doc) => doc['accountType'] != 'admin')
                  .toList();
              return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    final current = documents[index].data();
                    return SizedBox(
                      height: Dimensions.height80,
                      width: width * 0.90,
                      child: Card(
                        elevation: 2.0,
                        margin: EdgeInsets.only(bottom: 4.0, top: 4.0),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius15),
                          side: BorderSide(
                              color: Colors.grey.shade200, width: 1.0),
                        ),
                        color: current['status'].contains("active")
                            ? Colors.red
                            : Colors.white,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              current['profileImageUrl'],
                            ),
                            radius: Dimensions.radius30,
                          ),
                          title: Text(current['fName'] + current['lName']),
                          subtitle: Text(current['email']),
                          trailing: SizedBox(
                            width: Dimensions.width100 + Dimensions.width30,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                    onPressed: () {
                                      if (current['status']
                                          .contains("active")) {
                                        ConfirmationDialog
                                            .showConfirmationDialog(
                                          'Confirm Action',
                                          'Are you sure you want to block this users?',
                                          () => _blockUser(documents[index].id),
                                          Colors.red,
                                          Colors.grey,
                                          Colors.white,
                                        );
                                      } else if (current['status']
                                          .contains("blocked")) {
                                        ConfirmationDialog
                                            .showConfirmationDialog(
                                          'Confirm Action',
                                          'Are you sure you want to unblock this users?',
                                          () =>
                                              _unBlockUser(documents[index].id),
                                          Colors.red,
                                          Colors.grey,
                                          Colors.white,
                                        );
                                      }
                                    },
                                    child: Text(
                                      current['status'].contains("active")
                                          ? "Block"
                                          : "UnBlock",
                                      style: TextStyle(
                                          color: current['status']
                                                  .contains("active")
                                              ? Colors.red
                                              : Colors.black,
                                          fontSize: Dimensions.font16),
                                    ))
                              ],
                            ),
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
                  });
            } else {
              return Text("");
            }
          }),
    );
  }
}

_blockUser(userId) {
  AuthController.instance.blockOrunblockUser("blocked", userId);
}

_unBlockUser(userId) {
  AuthController.instance.blockOrunblockUser("active", userId);
}
