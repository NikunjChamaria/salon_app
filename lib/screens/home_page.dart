import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:salon_app/main.dart';
import 'package:salon_app/screens/category_page.dart';
import 'package:salon_app/utils/textstyle.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController search = TextEditingController();
  PageController pageController = PageController();
  late Future<DocumentSnapshot<Map<String, dynamic>>> name;
  int categorylength = 6;
  int selectedCategory = 0;

  void getName() {
    name = FirebaseFirestore.instance.collection("users").doc(userId).get();
  }

  @override
  void initState() {
    getName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: EdgeInsets.only(left: 15.w),
          child: CircleAvatar(
            radius: 20.h,
            backgroundImage: const CachedNetworkImageProvider(
              "https://t4.ftcdn.net/jpg/03/64/21/11/360_F_364211147_1qgLVxv1Tcq0Ohz3FawUfrtONzz8nq3e.jpg",
            ),
          ),
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: SvgPicture.asset(
              "assets/notification.svg",
              height: 30.h,
              width: 30.h,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 15.w),
            child: SvgPicture.asset(
              "assets/bookmark.svg",
              height: 30.h,
              width: 30.h,
            ),
          ),
        ],
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Good Morning!!",
              style: roboto(Colors.black, 18.sp, FontWeight.normal),
            ),
            FutureBuilder(
                future: name,
                builder: (context, snapshot) {
                  return snapshot.connectionState == ConnectionState.waiting
                      ? Container()
                      : Text(
                          snapshot.data!.get("name"),
                          style: roboto(Colors.black, 20.sp, FontWeight.w600),
                        );
                })
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 5.h),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.h),
                  border: Border.all(color: Colors.grey[200]!)),
              child: TextFormField(
                controller: search,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search),
                  suffixIcon: Icon(Icons.sort),
                  hintText: "Search",
                ),
              ),
            ),
            SizedBox(height: 20.h),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("ads").snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Shimmer.fromColors(
                      baseColor: Colors.white,
                      highlightColor: Colors.grey,
                      child: Container(
                        height: 200.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.h)),
                      ));
                }
                List<DocumentSnapshot> ads = snapshot.data!.docs;

                return Stack(
                  children: [
                    SizedBox(
                      height: 200.h,
                      child: PageView.builder(
                          itemCount: ads.length,
                          controller: pageController,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.h)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10.h),
                                  child: CachedNetworkImage(
                                    imageUrl: ads[index]['imageUrl'],
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor: Colors.white,
                                            highlightColor: Colors.grey,
                                            child: Container(
                                              height: 200.h,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.h)),
                                            )),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                    Positioned(
                      bottom: 10.h,
                      left: MediaQuery.of(context).size.width / 2 -
                          8 * ads.length,
                      child: SmoothPageIndicator(
                        controller: pageController,
                        count: ads.length,
                        effect: ExpandingDotsEffect(
                            dotHeight: 8.h,
                            dotWidth: 8.h,
                            activeDotColor: const Color(0xFF13577B)),
                      ),
                    )
                  ],
                );
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "Featured Services",
                style: roboto(Colors.black, 20.sp, FontWeight.w600),
              ),
            ),
            SizedBox(height: 20.h),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("featured_services")
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return SizedBox(
                    height: 150.h,
                    child: ListView.builder(
                      itemCount: 4,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Shimmer.fromColors(
                            baseColor: Colors.white,
                            highlightColor: Colors.grey,
                            child: Container(
                              height: 150.h,
                              width: 100.w,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.h)),
                            ));
                      },
                    ),
                  );
                }
                List<DocumentSnapshot> services = snapshot.data!.docs;

                return Container(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  height: 160.h,
                  child: ListView.builder(
                      itemCount: services.length,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0.h),
                          child: Container(
                            height: 150.h,
                            width: 140.w,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10.h)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10.h),
                                      topRight: Radius.circular(10.h)),
                                  child: CachedNetworkImage(
                                    imageUrl: services[index]['imageUrl'],
                                    height: 100.h,
                                    width: 140.w,
                                    placeholder: (context, url) =>
                                        Shimmer.fromColors(
                                            baseColor: Colors.white,
                                            highlightColor: Colors.grey,
                                            child: Container(
                                              height: 150.h,
                                              width: 140.w,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.h)),
                                            )),
                                    errorWidget: (context, url, error) =>
                                        const Icon(Icons.error),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Container(
                                  height: 50.h,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 5.h, vertical: 7.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        services[index]['name'],
                                        style: roboto(Colors.black, 14.sp,
                                            FontWeight.bold),
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            "Rs${services[index]['discountedPrice']}",
                                            style: roboto(Colors.black, 12.sp,
                                                FontWeight.bold),
                                          ),
                                          SizedBox(
                                            width: 10.w,
                                          ),
                                          Text(
                                            "Rs${services[index]['price']}",
                                            style: roboto(Colors.grey, 12.sp,
                                                FontWeight.bold),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
                );
              },
            ),
            SizedBox(
              height: 20.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: roboto(Colors.black, 20.sp, FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        categorylength = categorylength == 6 ? 9 : 6;
                      });
                    },
                    child: Text(
                      categorylength == 6 ? "View all" : "View less",
                      style: roboto(
                          const Color(0xFF13577B), 16.sp, FontWeight.w600),
                    ),
                  ),
                ],
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
              itemCount: categorylength,
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
            Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Text(
                "Most Popular Services",
                style: roboto(Colors.black, 20.sp, FontWeight.w600),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            SizedBox(
              height: 30.h,
              child: ListView.builder(
                itemCount: categoryIcon.length + 1,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = index;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(5.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.h),
                            color: selectedCategory == index
                                ? const Color(0xFF13577B)
                                : const Color(0xFFEEF9FF)),
                        child: Text(
                          index == 0 ? "All" : categoryName[index - 1],
                          style: roboto(
                              selectedCategory == index
                                  ? Colors.white
                                  : const Color(0xFF13577B),
                              16.sp,
                              FontWeight.normal),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20.h),
            StreamBuilder(
              stream: selectedCategory == 0
                  ? FirebaseFirestore.instance
                      .collection("popular_services")
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("popular_services")
                      .where("category",
                          isEqualTo: categoryName[selectedCategory - 1])
                      .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return ListView.builder(
                    itemCount: 4,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Shimmer.fromColors(
                          baseColor: Colors.white,
                          highlightColor: Colors.grey,
                          child: Container(
                            height: 100.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.h)),
                          ));
                    },
                  );
                }
                List<DocumentSnapshot> services = snapshot.data!.docs;

                return ListView.builder(
                    itemCount: services.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.0.h, vertical: 8.h),
                        child: Container(
                          height: 100.h,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.h)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10.h),
                                    child: CachedNetworkImage(
                                        fit: BoxFit.cover,
                                        height: 100.h,
                                        width: 100.h,
                                        imageUrl: services[index]['imageUrl']),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(vertical: 10.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          services[index]['name'],
                                          style: roboto(Colors.black, 14.sp,
                                              FontWeight.bold),
                                        ),
                                        Text(
                                          services[index]['location'],
                                          style: roboto(Colors.grey, 12.sp,
                                              FontWeight.bold),
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: const Color(0xFF13577B),
                                              size: 24.sp,
                                            ),
                                            Text(
                                              services[index]['distance'] < 1000
                                                  ? "${services[index]['distance']}m"
                                                  : "${services[index]['distance'] / 1000}km",
                                              style: roboto(
                                                  const Color.fromRGBO(
                                                      114, 114, 114, 1),
                                                  14.sp,
                                                  FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.yellow,
                                              size: 24.sp,
                                            ),
                                            Text(
                                              "${services[index]['rating']}  |  ${services[index]['reviews']} Reviews",
                                              style: roboto(
                                                  const Color.fromRGBO(
                                                      114, 114, 114, 1),
                                                  14.sp,
                                                  FontWeight.bold),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const Column(
                                children: [Icon(Icons.bookmark)],
                              )
                            ],
                          ),
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ),
    );
  }
}
