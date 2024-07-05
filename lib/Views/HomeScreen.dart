import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localstorage_and_livestorage/Constant/color_constant.dart';
import 'package:localstorage_and_livestorage/Models/LocalDatabaseModel.dart';
import 'package:sizer/sizer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "STORED DATA",
          style: TextStyle(color: white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: black,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(30),
          ),
        ),
      ),
      body: FutureBuilder(
        future: Hive.openBox('myBox'),
        builder: (BuildContext context, AsyncSnapshot<Box<dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              var box = snapshot.data!;
              return ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder:
                    (BuildContext context, Box<dynamic> box, Widget? child) {
                  List<User> userList = box.values.toList().cast<User>();
                  return Container(
                    margin: EdgeInsets.only(left: 7.w, right: 7.w),
                    child: ListView.builder(
                      itemCount: userList.length,
                      itemBuilder: (BuildContext context, int index) {
                        User user = userList[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: black),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    "Name : ",
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(user.name,
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: white,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Email : ",
                                    style: TextStyle(
                                        fontSize: 13.sp,
                                        color: white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(user.email,
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: white,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    "Contact No: ",
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        color: white,
                                        fontWeight: FontWeight.w700),
                                  ),
                                  Text(user.phoneNumber,
                                      style: TextStyle(
                                          fontSize: 11.sp,
                                          color: white,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ],
                          ),
                        );

                        // ListTile(
                        //   title: Row(
                        //     children: [
                        //       Text(
                        //         "Name : ",
                        //         style: TextStyle(
                        //             fontSize: 13.sp, fontWeight: FontWeight.w700),
                        //       ),
                        //       Text(user.name),
                        //     ],
                        //   ),
                        //   subtitle: Row(
                        //     children: [
                        //       Text(
                        //         "Email : ",
                        //         style: TextStyle(
                        //             fontSize: 11.sp, fontWeight: FontWeight.w700),
                        //       ),
                        //       Text(user.email),
                        //     ],
                        //   ),
                        // );
                      },
                    ),
                  );
                },
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
