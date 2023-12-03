import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salon_app/utils/textstyle.dart';

List categoryIcon = [
  "haircut",
  "makeup",
  "straight",
  "main-padi",
  "spa",
  "trimming",
  "haircolor",
  "waxing",
  "facial"
];
List categoryName = [
  "Hair cut",
  "Makeup",
  "Straightening",
  "Main-Padi",
  "Spa",
  "Beard Trimming",
  "Hair Coloring",
  "Waxing",
  "Facial"
];

class CategoryPage extends StatefulWidget {
  const CategoryPage({super.key});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 50.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                "Category",
                style: roboto(Colors.black, 24.sp, FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: categoryIcon.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    SvgPicture.asset(
                      "assets/${categoryIcon[index]}.svg",
                      height: 40.h,
                      width: 40.h,
                    ),
                    SizedBox(height: 10.h),
                    Text(
                      categoryName[index],
                      style: roboto(Colors.black, 14.sp, FontWeight.bold),
                    )
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
