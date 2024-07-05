import 'package:flutter/material.dart';
import 'package:localstorage_and_livestorage/Constant/color_constant.dart';
import 'package:sizer/sizer.dart';

getFormButton(Function fun, str, {required bool validate}) {
  return Center(
    child: GestureDetector(
      onTap: () {
        fun();
      },
      child: Container(
        height: 6.h,
        alignment: Alignment.center,
        width: SizerUtil.width / 1,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.h),
          color: validate ? black : Colors.grey,
          boxShadow: [
            BoxShadow(
                color: validate
                    ? black.withOpacity(0.2)
                    : Colors.grey.withOpacity(0.2),
                blurRadius: 10.0,
                offset: const Offset(0, 1),
                spreadRadius: 3.0)
          ],
        ),
        child: Text(
          str,
          style: TextStyle(color: white, fontSize: 14.sp),
        ),
      ),
    ),
  );
}
