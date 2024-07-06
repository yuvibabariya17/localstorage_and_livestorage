import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localstorage_and_livestorage/Constant/color_constant.dart';
import 'package:localstorage_and_livestorage/Controllers/RegisterScreenController.dart';
import 'package:localstorage_and_livestorage/Custom_componant/custom_button.dart';
import 'package:localstorage_and_livestorage/Views/HomeScreen.dart';
import 'package:localstorage_and_livestorage/Models/LocalDatabaseModel.dart';
import 'package:sizer/sizer.dart';
import 'package:animate_do/animate_do.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final controller = Get.put(RegisterScreenController());

  Future<void> _submitForm() async {
    if (controller.isFormInvalidate.value == true) {
      User newUser = User(
        name: controller.nameCtr.text,
        email: controller.emailCtr.text,
        password: controller.passCtr.text,
        phoneNumber: controller.phoneCtr.text,
      );

      try {
        // Check internet connectivity
        // var connectivityResult = await Connectivity().checkConnectivity();
        final List<ConnectivityResult> connectivityResult =
            await (Connectivity().checkConnectivity());
        print("connectivityResult:::${connectivityResult.toString()}");
        if (connectivityResult.contains(ConnectivityResult.mobile) ||
            connectivityResult.contains(ConnectivityResult.wifi)) {
          // Internet connection available, store data remotely
          FirebaseFirestore firestore = FirebaseFirestore.instance;
          // await firestore.collection('Users').add({
          //   'name': newUser.name,
          //   'email': newUser.email,
          //   'password': newUser.password,
          //   'phoneNumber': newUser.phoneNumber,
          // });
          await firestore.collection('Users').doc(newUser.email).set({
            'name': newUser.name,
            'email': newUser.email,
            'password': newUser.password,
            'phoneNumber': newUser.phoneNumber,
          });

          // Mobile network available.
        } else if (connectivityResult.contains(ConnectivityResult.none)) {
          // No internet connection, store data locally
          var box =
              await Hive.openBox('myBox'); // Replace 'myBox' with your box name
          await box.add(newUser);
        }

        Get.offAll(const HomeScreen());
      } catch (e) {
        print('Error submitting form: $e');
      }
    }
  }

// OLD LOGIC

  // void _submitForm() async {
  //   if (controller.isFormInvalidate.value == true) {
  //     User newUser = User(
  //       name: controller.nameCtr.text,
  //       email: controller.emailCtr.text,
  //       password: controller.passCtr.text,
  //       phoneNumber: controller.phoneCtr.text,
  //     );

  //     // Get the Hive box
  //     var box =
  //         await Hive.openBox('myBox'); // Replace 'myBox' with your box name

  //     // Add the user to the box
  //     await box.add(newUser);

  //     // Navigate to the next screen
  //     Get.to(const HomeScreen());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "ENTER YOUR DETAILS",
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
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(left: 7.w, right: 7.w, top: 7.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                getCustomeFormFields(controller.nameCtr, "Enter Name", 1),
                SizedBox(
                  height: 1.h,
                ),
                getCustomeFormFields(controller.emailCtr, "Enter Email", 2),
                SizedBox(
                  height: 1.h,
                ),
                getCustomeFormFields(controller.passCtr, "Enter Password", 3),
                SizedBox(
                  height: 1.h,
                ),
                getCustomeFormFields(
                    controller.phoneCtr, "Enter Phone Number", 4),
                SizedBox(
                  height: 10.h,
                ),
                FadeInUp(
                    from: 50,
                    child: Obx(() {
                      return getFormButton(() {
                        // For HIVE Database
                        _submitForm();

                        // For Form Validation

                        // if (controller.isFormInvalidate.value == true) {
                        //   Get.to(const Homescreen());
                        // }
                      }, "Submit", validate: controller.isFormInvalidate.value);
                    })),
              ],
            ),
          ),
        ));
  }

  getCustomeFormFields(
      TextEditingController? controllers, String hint, int index) {
    return Obx(
      () {
        return TextFormField(
          controller: controllers,
          style: TextStyle(fontSize: 10.sp),
          keyboardType: index == 2
              ? TextInputType.emailAddress
              : index == 3
                  ? TextInputType.text
                  : index == 4
                      ? TextInputType.phone
                      : TextInputType.text,
          obscureText: index == 3 ? controller.obsecureText.value : false,
          onChanged: (value) {
            if (index == 1) {
              controller.validateName(value);
            }
            if (index == 2) {
              controller.validateEmail(value);
            }
            if (index == 3) {
              controller.validatePassword(value);
            }
            if (index == 4) {
              controller.validatePhone(value);
            }
          },
          decoration: InputDecoration(
            errorText: index == 1
                ? controller.nameModel.value.error
                : index == 2
                    ? controller.emailModel.value.error
                    : index == 3
                        ? controller.passModel.value.error
                        : controller.phoneModel.value.error,
            hintText: hint,
            prefixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  index == 1
                      ? Icons.person
                      : index == 2
                          ? Icons.mail
                          : index == 3
                              ? Icons.password_rounded
                              : Icons.phone,
                  // color: primaryColor,
                ),
                SizedBox(
                  width: 3.w,
                ),
                Container(
                  color: Colors.grey,
                  width: 0.5.w,
                  height: 3.5.h,
                ),
                SizedBox(
                  width: 2.w,
                ),
              ],
            ),
            suffixIcon: index == 3
                ? GestureDetector(
                    onTap: () {
                      controller.obsecureText.value =
                          !controller.obsecureText.value;
                      setState(() {});
                    },
                    child: Icon(
                      controller.obsecureText.value == true
                          ? Icons.visibility_off
                          : Icons.visibility,
                      //   color: primaryColor,
                    ),
                  )
                : null,
          ),
          validator: (value) {
            // if (value!.isEmpty) {
            //   return index == 1
            //       ? Strings.emailbtnvalidate
            //       : Strings.passbtnValidate;
            // }
            return null;
          },
        );
      },
    );
  }
}
