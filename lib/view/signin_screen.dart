import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outdo_app/provider/auth_provider.dart';
import 'package:outdo_app/util/colors.dart';
import 'package:outdo_app/util/images.dart';
import 'package:outdo_app/view/home/home_page.dart';
import 'package:outdo_app/view/meetings_screen.dart';
import 'package:outdo_app/widgets/custom_button.dart';
import 'package:outdo_app/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';

import '../util/dimensions.dart';

class SignInScreen extends StatelessWidget {
  SignInScreen({super.key});
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Container(
                height: 90,
                width: 230,
                margin: const EdgeInsets.fromLTRB(0, 30, 0, 30),
                child: Image.asset(Images.logo),
              ),
            ),
            Expanded(
              child: Container(
                width: Get.width,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(Dimensions.RADIUS_LARGE),
                      topRight: Radius.circular(Dimensions.RADIUS_LARGE)),
                  color: Theme.of(context).cardColor,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 0,
                        blurRadius: 5,
                        offset: Offset(0, 3))
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Hello!',
                      style: TextStyle(
                        color: Appcolors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Welcome back!',
                      style: TextStyle(
                        color: Appcolors.grey,
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 30),
                    CustomTextField(
                      title: 'Email',
                      hintText: 'Enter Email',
                      controller: emailController,
                      capitalization: TextCapitalization.words,
                      inputType: TextInputType.name,
                      showTitle: true,
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        size: 25,
                        color: Appcolors.red,
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      title: 'Password',
                      hintText: 'Enter Password',
                      controller: passwordController,
                      capitalization: TextCapitalization.words,
                      inputType: TextInputType.name,
                      showTitle: true,
                      prefixIcon: const Icon(
                        Icons.lock_outline,
                        size: 25,
                        color: Appcolors.red,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Forgot password?',
                        style: TextStyle(
                          color: Appcolors.blue,
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    Provider.of<AuthProvider>(context).isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : CustomButton(
                            buttonText: 'Sign In',
                            onPressed: () async {
                              if (emailController.text != '' &&
                                  passwordController.text != '') {
                                try {
                                  await Provider.of<AuthProvider>(context,
                                          listen: false)
                                      // .login('chanchal.corpaidcs@gmail.com',
                                      //     '@Krishna1', context);
                                      .login(emailController.text,
                                          passwordController.text, context);
                                  Get.off(() => const HomePage());
                                } on HttpException {
                                  return '';
                                }
                              }
                            },
                            fontSize: 20,
                          )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
