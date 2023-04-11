import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outdo_app/util/images.dart';
import 'package:outdo_app/widgets/appbar.dart';
import 'package:outdo_app/widgets/custom_button.dart';

import '../util/colors.dart';

class ProjectsScreen extends StatefulWidget {
  ProjectsScreen({super.key});

  @override
  State<ProjectsScreen> createState() => _ProjectsScreenState();
}

class _ProjectsScreenState extends State<ProjectsScreen> {
  int selectedChip = 0;
  List<String> chipsList = ['Service', 'Material'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: CustomAppBar('Projects', context),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, i) {
                  return Container(
                    width: Get.width,
                    margin: const EdgeInsets.all(10),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Appcolors.grey.withOpacity(0.2),
                        )),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(Images.location_pin,
                                height: 25, width: 25),
                            Container(
                              margin: const EdgeInsets.only(left: 5),
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Client Name',
                                    style: TextStyle(
                                      color: Appcolors.black,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 18,
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'City State',
                                    style: TextStyle(
                                      color: Appcolors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  Text(
                                    'Progress 12%',
                                    style: TextStyle(
                                      color: Appcolors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: Appcolors.redLight,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: const Text(
                                'Active',
                                style: TextStyle(
                                  color: Appcolors.red,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Container(
                          width: Get.width,
                          margin: const EdgeInsets.symmetric(horizontal: 15),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 14),
                          decoration: BoxDecoration(
                            color: Appcolors.blueLight,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.calendar_month),
                              SizedBox(width: 10),
                              Text(
                                'Start Date - End Date',
                                style: TextStyle(
                                  color: Appcolors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
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
