import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outdo_app/util/images.dart';
import 'package:outdo_app/widgets/appbar.dart';
import 'package:outdo_app/widgets/custom_button.dart';

import '../util/colors.dart';

class VendorScreen extends StatefulWidget {
  VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  int selectedChip = 0;
  List<String> chipsList = ['Service', 'Material'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: CustomAppBar('Vendor List', context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ...chipsList
                    .asMap()
                    .entries
                    .map((e) => Container(
                          margin: EdgeInsets.symmetric(
                              horizontal: selectedChip == e.key ? 10.0 : 0),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedChip = e.key;
                              });
                            },
                            child: Chip(
                              backgroundColor: selectedChip == e.key
                                  ? Appcolors.blue
                                  : Appcolors.white,
                              label: Text(e.value),
                              labelStyle: TextStyle(
                                  color: selectedChip == e.key
                                      ? Appcolors.white
                                      : Appcolors.grey,
                                  fontSize: 16),
                              labelPadding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 5),
                            ),
                          ),
                        ))
                    .toList(),
              ],
            ),
            const SizedBox(height: 30),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, i) {
                  return Container(
                    width: Get.width,
                    height: 125,
                    margin: const EdgeInsets.all(10),
                    // padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                        // color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Appcolors.grey.withOpacity(0.2),
                        )),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 120,
                              height: 123,
                              decoration: const BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: AssetImage(Images.placeholder))),
                            ),
                            Container(
                              height: 120,
                              margin: const EdgeInsets.only(left: 5),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  // color: Appcolors.blueLight,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  const Text(
                                    'Vendor Name',
                                    style: TextStyle(
                                      color: Appcolors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  const Text(
                                    'Address Line 1',
                                    style: TextStyle(
                                      color: Appcolors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    'Address Line 2',
                                    style: TextStyle(
                                      color: Appcolors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    'Landmark',
                                    style: TextStyle(
                                      color: Appcolors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    'City Pincode',
                                    style: TextStyle(
                                      color: Appcolors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Image.asset(Images.location_pin,
                                      height: 25, width: 25),
                                  const SizedBox(height: 50),
                                  Image.asset(Images.pencil_icon,
                                      height: 25, width: 25),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
          ],
        ),
      ),
    );
  }
}
