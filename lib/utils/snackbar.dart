import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:salon_app/utils/textstyle.dart';

void customSnaackBar(String title, String message) {
  Get.snackbar("", "",
      maxWidth: 300.w,
      colorText: Colors.white,
      backgroundColor: const Color(0xFF13577B),
      titleText: Text(
        title,
        style: roboto(Colors.white, 12.sp, FontWeight.bold),
      ),
      messageText: Text(
        message,
        style: roboto(Colors.white, 12.sp, FontWeight.normal),
      ));
}
