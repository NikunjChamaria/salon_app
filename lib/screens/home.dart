// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salon_app/screens/category_page.dart';
import 'package:salon_app/screens/home_page.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  List pages = [
    const HomePage(),
    const CategoryPage(),
    const Scaffold(),
    const Scaffold(),
    const Scaffold()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        iconSize: 24.sp,
        selectedItemColor: const Color(0xFF13577B),
        unselectedItemColor: Colors.grey,
        onTap: (value) {
          setState(() {
            index = value;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/home.svg",
              height: 24.h,
              width: 24.h,
              color: index == 0 ? const Color(0xFF13577B) : Colors.grey,
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/category.svg",
              height: 24.h,
              width: 24.h,
              color: index == 1 ? const Color(0xFF13577B) : Colors.grey,
            ),
            label: "Category",
          ),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/calender.svg",
                height: 24.h,
                width: 24.h,
                color: index == 2 ? const Color(0xFF13577B) : Colors.grey,
              ),
              label: "3"),
          BottomNavigationBarItem(
              icon: SvgPicture.asset(
                "assets/chat.svg",
                height: 24.h,
                width: 24.h,
                color: index == 3 ? const Color(0xFF13577B) : Colors.grey,
              ),
              label: "4"),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              "assets/profile.svg",
              height: 24.h,
              width: 24.h,
              color: index == 4 ? const Color(0xFF13577B) : Colors.grey,
            ),
            label: "5",
          )
        ],
      ),
    );
  }
}
