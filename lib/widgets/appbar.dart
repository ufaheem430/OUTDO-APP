import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outdo_app/view/signin_screen.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';
import '../provider/shared_pref_helper.dart';
import '../util/colors.dart';
import '../util/images.dart';

PreferredSizeWidget CustomAppBar(String title, BuildContext context,
    {bool isMenu = false}) {
  final user = Provider.of<AuthProvider>(context).user;
  return AppBar(
    elevation: 0.0,
    backgroundColor: Appcolors.white,
    leading: const Icon(
      Icons.menu,
      color: Appcolors.grey,
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: Appcolors.blue,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {},
        icon: const Icon(
          Icons.notifications_none,
          color: Appcolors.grey,
          size: 26,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(right: 10),
        child: CircleAvatar(
          radius: 17,
          backgroundImage: user.profileImage != null || user.profileImage != ''
              ? NetworkImage(user.profileImage!) as ImageProvider
              : const AssetImage(Images.profile),
        ),
      ),
      isMenu
          ? PopupMenuButton<String>(
              padding: EdgeInsets.zero,
              elevation: 0,
              icon: const Icon(
                Icons.more_vert,
                color: Appcolors.blue,
              ),
              onSelected: (v) async {
                log('value : $v');
                if (v == 'Logout') {
                  await Provider.of<AuthProvider>(context, listen: false)
                      .logOut()
                      .then((value) async {
                    if (value) {
                      await SharedPreferenceHelper().setAuthToken('null');
                      await SharedPreferenceHelper().setUserId('null');
                      Get.off(() => SignInScreen());
                    }
                  });
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Logout', 'Settings'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              })
          : const SizedBox(),
    ],
  );
}
