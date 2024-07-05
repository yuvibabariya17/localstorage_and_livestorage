import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:localstorage_and_livestorage/Models/ValidationModel.dart';

enum ScreenState { apiLoading, apiError, apiSuccess, noNetwork, noDataFound }

class RegisterScreenController extends GetxController {
  RxBool obsecureText = true.obs;

  // final InternetController networkManager = Get.find<InternetController>();
  late FocusNode nameNode, emailNode, passNode, phoneNode;
  late TextEditingController nameCtr, emailCtr, passCtr, phoneCtr;

  Rx<ScreenState> state = ScreenState.apiLoading.obs;

  @override
  void onInit() {
    nameNode = FocusNode();
    emailNode = FocusNode();
    passNode = FocusNode();
    phoneNode = FocusNode();

    nameCtr = TextEditingController();
    emailCtr = TextEditingController();
    passCtr = TextEditingController();
    phoneCtr = TextEditingController();

    super.onInit();
  }

  var isLoading = false.obs;
  var emailModel = ValidationModel(null, null, isValidate: false).obs;
  var passModel = ValidationModel(null, null, isValidate: false).obs;
  var nameModel = ValidationModel(null, null, isValidate: false).obs;
  var phoneModel = ValidationModel(null, null, isValidate: false).obs;

  void enableSignUpButton() {
    if (emailModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (passModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (nameModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else if (phoneModel.value.isValidate == false) {
      isFormInvalidate.value = false;
    } else {
      isFormInvalidate.value = true;
    }
  }

  void validateName(String? val) {
    nameModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = "Enter Name";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validateEmail(String? val) {
    emailModel.update((model) {
      if (val != null && val.toString().trim().isEmpty) {
        model!.error = "Enter Email Id";
        model.isValidate = false;
      } else if (!RegExp(r'\S+@\S+\.\S+').hasMatch(emailCtr.text.trim())) {
        model!.error = "Enter Valid Email Id";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validatePhone(String? val) {
    phoneModel.update((model) {
      if (val == null || val.isEmpty) {
        model!.error = "Enter Contact No";
        model.isValidate = false;
      } else if (val.replaceAll(' ', '').length != 10) {
        model!.error = "Enter Valid Contact No";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });

    enableSignUpButton();
  }

  void validatePassword(String? val) {
    passModel.update((model) {
      if (val == null || val.toString().trim().isEmpty) {
        model!.error = "Enter Password";
        model.isValidate = false;
      } else if (val.length < 8) {
        model!.error = "Enter Valid Password";
        model.isValidate = false;
      } else {
        model!.error = null;
        model.isValidate = true;
      }
    });
    enableSignUpButton();
  }

  RxBool isFormInvalidate = false.obs;

  void hideKeyboard(context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus) {
      currentFocus.unfocus();
    }
  }

  // void signInAPI(context) async {
  //   var loadingIndicator = LoadingProgressDialog();
  //   try {
  //     if (networkManager.connectionType == 0) {
  //       loadingIndicator.hide(context);
  //       showDialogForScreen(context, "No Internet Connection", callback: () {
  //         Get.back();
  //       });
  //       return;
  //     }
  //     loadingIndicator.show(context, '');
  //     var response = await Repository.postForm({
  //       "email": emailCtr.text.toString(),
  //       "password": passCtr.text.toString(),
  //     }, ApiUrl.login, allowHeader: true);
  //     loadingIndicator.hide(context);
  //     var data = jsonDecode(response.body);
  //     logcat("RESPOnse", data);
  //     if (response.statusCode == 200) {
  //       var responseDetail = SignInModel.fromJson(data);
  //       if (responseDetail.success == true) {
  //         UserPreferences().saveSignInInfo(responseDetail);
  //         UserPreferences().setToken(responseDetail.authToken.toString());
  //         Get.offAll(const HomeScreen());
  //       } else {
  //         showDialogForScreen(context, data['message'].toString(),
  //             callback: () {});
  //       }
  //     } else {
  //       state.value = ScreenState.apiError;
  //       showDialogForScreen(context, data['message'].toString(),
  //           callback: () {});
  //     }
  //   } catch (e) {
  //     logcat("Exception", e);
  //     showDialogForScreen(context, "Server Error", callback: () {});
  //     loadingIndicator.hide(context);
  //   }
  // }

  // showDialogForScreen(context, String message, {Function? callback}) {
  //   showMessage(
  //       context: context,
  //       callback: () {
  //         if (callback != null) {
  //           callback();
  //         }
  //         return true;
  //       },
  //       message: message,
  //       title: Strings.login,
  //       negativeButton: '',
  //       positiveButton: Strings.continueBtn);
  // }
}
