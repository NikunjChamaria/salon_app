// ignore_for_file: use_build_context_synchronously, unused_field

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:salon_app/main.dart';
import 'package:salon_app/screens/home.dart';
import 'package:salon_app/utils/loadingdialog.dart';
import 'package:salon_app/utils/snackbar.dart';
import 'package:salon_app/utils/textstyle.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isOtp = false;
  bool resendOtp = false;
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController otp = TextEditingController();
  String verificationIdMain = "";
  int _secondsRemaining = 60;
  late Timer _timer;

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          resendOtp = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> saveUserInfoToFirestore(String name) async {
    LoadingIndicatorDialog().dismiss();

    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'name': name,
      'phone': phone.text,
    });
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("user", uid);
    userId = uid;
    _timer.cancel();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Home()),
        (route) => false);
  }

  Future<void> _signUp() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+91${phone.text}",
      verificationCompleted: (PhoneAuthCredential credential) async {
        await FirebaseAuth.instance.signInWithCredential(credential);
        await saveUserInfoToFirestore(name.text);
      },
      verificationFailed: (FirebaseAuthException e) {
        LoadingIndicatorDialog().dismiss();

        customSnaackBar("Oops!", "Verification Failed");
      },
      codeSent: (String verificationId, int? resendToken) {
        LoadingIndicatorDialog().dismiss();

        setState(() {
          isOtp = true;
        });
        startTimer();
        verificationIdMain = verificationId;
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
      timeout: const Duration(seconds: 60),
    );
  }

  Future<void> _verifyPhoneNumber() async {
    try {
      String smsCode = otp.text;

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationIdMain,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      await saveUserInfoToFirestore(name.text);
    } catch (e) {
      customSnaackBar("Oops!", "Otp entered is wrong!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 25.h, horizontal: 20.w),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/logo.png"),
              Text(
                "HAIR SALON",
                style: nautigal(Colors.black, 45.sp, FontWeight.w900),
              ),
              Stack(
                children: [
                  SizedBox(
                    height: 350.h,
                    width: MediaQuery.of(context).size.width,
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 40.w,
                      height: 270.h,
                      padding: EdgeInsets.all(20.h),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.h),
                          border: Border.all(color: Colors.grey[200]!)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Visibility(
                              visible: isOtp,
                              child: Pinput(
                                controller: otp,
                                onSubmitted: (value) {
                                  _signUp();
                                },
                                length: 6,
                                autofocus: true,
                                defaultPinTheme: PinTheme(
                                    textStyle: roboto(
                                        Colors.black, 16.sp, FontWeight.normal),
                                    width: 40.w,
                                    height: 40.h,
                                    decoration: const BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.black)))),
                              )),
                          Visibility(
                            visible: isOtp,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  if (resendOtp) {
                                    setState(() {
                                      resendOtp = false;
                                    });
                                    _verifyPhoneNumber();
                                  }
                                },
                                child: Text(
                                  resendOtp
                                      ? "Resnd Code"
                                      : 'Resend code in $_secondsRemaining s',
                                  style: roboto(
                                      Colors.red, 16.sp, FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !isOtp,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  40.w -
                                  40.h,
                              child: TextFormField(
                                controller: name,
                                style: roboto(
                                    Colors.black, 16.sp, FontWeight.normal),
                                decoration: InputDecoration(
                                    hintStyle: roboto(Colors.grey[400]!, 16.sp,
                                        FontWeight.normal),
                                    hintText: "Enter Username",
                                    suffixIcon: const Icon(Icons.person),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.2,
                                          color: Colors.grey[200]!,
                                          style: BorderStyle.none),
                                    )),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: !isOtp,
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width -
                                  40.w -
                                  40.h,
                              child: TextFormField(
                                controller: phone,
                                style: roboto(
                                    Colors.black, 16.sp, FontWeight.normal),
                                decoration: InputDecoration(
                                    hintStyle: roboto(Colors.grey[400]!, 16.sp,
                                        FontWeight.normal),
                                    hintText: "Enter Mobile Number",
                                    suffixIcon: const Icon(Icons.phone),
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          width: 0.2,
                                          color: Colors.grey[200]!,
                                          style: BorderStyle.none),
                                    )),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          GestureDetector(
                            onTap: () {
                              LoadingIndicatorDialog().show(context);
                              isOtp ? _verifyPhoneNumber() : _signUp();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 15.h, horizontal: 90.w),
                              decoration: BoxDecoration(
                                  color: const Color(0xFF13577B),
                                  borderRadius: BorderRadius.circular(10.h)),
                              child: Text(
                                "CONTINUE",
                                style: roboto(
                                    Colors.white, 16.sp, FontWeight.normal),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.h),
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: roboto(
                                  Colors.black, 14.sp, FontWeight.normal),
                              children: [
                                const TextSpan(
                                    text: 'By continuing you agree to our '),
                                TextSpan(
                                  text: 'Terms & Conditions',
                                  style: roboto(const Color(0xFF13577B), 14.sp,
                                      FontWeight.normal),
                                ),
                                const TextSpan(text: ' and '),
                                TextSpan(
                                  text: 'Privacy Policy',
                                  style: roboto(const Color(0xFF13577B), 14.sp,
                                      FontWeight.normal),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: 20.h),
                      child: Container(
                        padding: EdgeInsets.all(20.h),
                        decoration: ShapeDecoration(
                            color: Colors.white,
                            shape: CircleBorder(
                                side: BorderSide(color: Colors.grey[200]!))),
                        child: Icon(
                          Icons.login,
                          size: 40.sp,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
