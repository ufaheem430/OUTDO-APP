import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outdo_app/provider/shared_pref_helper.dart';
import 'package:outdo_app/util/colors.dart';
import 'package:outdo_app/util/images.dart';
import 'package:outdo_app/view/home/home_page.dart';
import 'package:outdo_app/view/signin_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void fun() async {
    // final token = await SharedPreferenceHelper().getAuthToken();
    // final uID = await SharedPreferenceHelper().getUserId();
    // log('token is : $token');
    // log('user id is : $uID');
    Timer(const Duration(seconds: 3), () {
      // if (token == null || uID == null) {
      Get.off(() => SignInScreen());
      // } else {
      //   Get.off(() => const HomePage());
      // }
    });
  }

  @override
  void initState() {
    fun();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // fun();
    return Scaffold(
      body: Container(
        color: Appcolors.white,
        width: double.infinity,
        height: double.infinity,
        child: Center(
          child: Image.asset(
            Images.logo,
            width: Get.width * 0.7,
          ),
        ),
      ),
    );
  }
}
