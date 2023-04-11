import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outdo_app/util/images.dart';
import 'package:outdo_app/widgets/appbar.dart';
import 'package:outdo_app/widgets/custom_button.dart';

import '../util/colors.dart';

class DeliveryManagementScreen extends StatefulWidget {
  DeliveryManagementScreen({super.key});

  @override
  State<DeliveryManagementScreen> createState() =>
      _DeliveryManagementScreenState();
}

class _DeliveryManagementScreenState extends State<DeliveryManagementScreen> {
  int selectedChip = 0;
  List<String> chipsList = ['Pick-Up', 'Delivery'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: CustomAppBar('Delivery Management', context),
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
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.all(15),
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
                              height: 110,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                  color: Appcolors.blueLight,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: const [
                                  const Text(
                                    '12',
                                    style: TextStyle(
                                      color: Appcolors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                    ),
                                  ),
                                  const Text(
                                    'May',
                                    style: TextStyle(
                                      color: Appcolors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const Text(
                                    '2022',
                                    style: TextStyle(
                                      color: Appcolors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: 120,
                              margin: const EdgeInsets.only(left: 20),
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
                                    'Client Name',
                                    style: TextStyle(
                                      color: Appcolors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
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
                            Container(
                              height: 120,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 1),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: Image.asset(Images.clock)),
                                        // Icon(Icons.alarm, color: Appcolors.grey),
                                        SizedBox(width: 5),
                                        Text(
                                          '03:30 PM',
                                          style: TextStyle(
                                            color: Appcolors.black,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 15,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Container(
                                  //   height: 70,
                                  //   width: 90,
                                  //   decoration: const BoxDecoration(
                                  //     image: DecorationImage(
                                  //       fit: BoxFit.fill,
                                  //       image: AssetImage(Images.location),
                                  //     ),
                                  //   ),
                                  // )
                                  Expanded(child: Image.asset(Images.location))
                                ],
                              ),
                            )
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                                child: CustomButton(
                              buttonColor: Appcolors.redLight,
                              textColor: Appcolors.red,
                              buttonText: 'Reschedule',
                              onPressed: () {},
                            )),
                            const SizedBox(width: 10),
                            Expanded(
                                child: CustomButton(
                              buttonText: 'View List',
                              onPressed: () {},
                            )),
                          ],
                        )
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
