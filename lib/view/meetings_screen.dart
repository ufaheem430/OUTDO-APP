import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:get/get.dart';
import 'package:outdo_app/model/meeting_model.dart';
import 'package:outdo_app/provider/meeting_provider.dart';
import 'package:outdo_app/provider/shared_pref_helper.dart';
import 'package:outdo_app/view/home/pick_map_screen.dart';
import 'package:outdo_app/widgets/appbar.dart';
import 'package:outdo_app/widgets/common_functions.dart';
import 'package:outdo_app/widgets/custom_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../provider/location_provider.dart';
import '../util/colors.dart';

// List<String> locationsList = [];

class MettingsScreen extends StatefulWidget {
  MettingsScreen({super.key});

  @override
  State<MettingsScreen> createState() => _MettingsScreenState();
}

class _MettingsScreenState extends State<MettingsScreen> {
  int selectedChip = 0;
  List<String> chipsList = ['Upcoming', 'Completed', 'Delayed'];
  List<Completed> _completedMeetingList = [];
  List<Delay> _delayMeetingList = [];
  List<Upcoming> _upcomingMeetingList = [];
  int? reachedIndex;
  void getMeetings() async {
    String? userId = await SharedPreferenceHelper().getUserId();

    await Provider.of<MeetingProvider>(context, listen: false)
        .fetchMeetings(userId!);

    _upcomingMeetingList =
        Provider.of<MeetingProvider>(context, listen: false).upcomingMeetings;

    _completedMeetingList =
        Provider.of<MeetingProvider>(context, listen: false).completedMeetings;
    _delayMeetingList =
        Provider.of<MeetingProvider>(context, listen: false).delayMeetings;
    // if (reachedIndex != null && isFromReached == true) {
    //   final loc = Provider.of<LocationProvider>(context, listen: false);
    //   _upcomingMeetingList[reachedIndex!].address1 = loc.adddress1;
    //   _upcomingMeetingList[reachedIndex!].address2 = loc.adddress2;
    //   _upcomingMeetingList[reachedIndex!].area = loc.locality;
    //   _upcomingMeetingList[reachedIndex!].city = loc.city;
    //   _upcomingMeetingList[reachedIndex!].locationPosition =
    //       loc.currentPosition;
    // }

    // final loc = Provider.of<LocationProvider>(context, listen: false);
    // for (int i = 0; i < locationsList.length; i++) {
    //   int index =
    //       _upcomingMeetingList.indexWhere((e) => e.id == locationsList[i]);
    //   if (index != null) {
    //     _upcomingMeetingList[index].address1 = loc.adddress1;
    //     _upcomingMeetingList[index].address2 = loc.adddress2;
    //     _upcomingMeetingList[index].area = loc.locality;
    //     _upcomingMeetingList[index].city = loc.city;
    //     _upcomingMeetingList[index].locationPosition = loc.currentPosition;
    //   }
    // }
  }

  @override
  void initState() {
    getMeetings();

    super.initState();
  }

  String _date = '';
  final _commentController = TextEditingController();

  void showDialogue(
    MeetingProvider prov,
    Upcoming item,
  ) {
    showDialog(
        context: context,
        builder: (ctx) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Center(child: Text('Time : $_date')),
              // title: const Text("Reschedule Meeting"),
              content: SizedBox(
                height: 100,
                child: TextField(
                  controller: _commentController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Appcolors.blue)),
                      hintText: 'Enter comment!',
                      labelText: 'Enter comment!',
                      prefixIcon: Icon(
                        Icons.comment,
                        color: Appcolors.blue,
                      ),
                      prefixText: ' ',
                      suffixText: '',
                      suffixStyle: TextStyle(color: Appcolors.blue)),
                ),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    DatePicker.showDateTimePicker(context,
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2050, 6, 7),
                        theme: const DatePickerTheme(
                            headerColor: Appcolors.black,
                            backgroundColor: Appcolors.blue,
                            itemStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            cancelStyle: TextStyle(color: Colors.white),
                            doneStyle:
                                TextStyle(color: Colors.white, fontSize: 16)),
                        onChanged: (date) {
                      _date =
                          '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}0';
                      // print('change $date in time zone ' +
                      //     date.timeZoneOffset.inHours.toString());
                      setState(() {});
                    }, onConfirm: (date) async {
                      _date =
                          '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}0';

                      setState(() {});
                    }, currentTime: DateTime.now(), locale: LocaleType.en);
                  },
                  child: Container(
                    color: Appcolors.blue,
                    padding: const EdgeInsets.all(14),
                    child: const Text(
                      "Select Time",
                      style: TextStyle(color: Appcolors.white),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (_date == '') {
                      CommonFunctions.showWarningToast('select Date & Time');
                    } else {
                      Navigator.of(ctx).pop();
                      final result = await prov.rescheduleMeeting(
                          item, _date, _commentController.text);
                      if (result) {
                        CommonFunctions.showSuccessToast(
                            prov.rescheduleMeetingMessage);
                        getMeetings();
                      } else {
                        CommonFunctions.showErrorToast(
                            prov.rescheduleMeetingMessage);
                      }
                    }
                  },
                  child: Container(
                    color: Appcolors.blue,
                    padding: const EdgeInsets.all(14),
                    child: const Text(
                      "Reschedule",
                      style: TextStyle(color: Appcolors.white),
                    ),
                  ),
                ),
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    final meet = Provider.of<MeetingProvider>(context);
    final loc = Provider.of<LocationProvider>(context);
    // final check = locationsList.contains('1');
    // log('location list contain 1 : $check');

    // loc.currentPosition = null;
    return Scaffold(
      backgroundColor: Appcolors.white,
      appBar: CustomAppBar('Meetings', context, isMenu: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // MaterialButton(
            //   onPressed: () async {
            //     await placemarkFromCoordinates(18.658102, 73.731081)
            //         .then((List<Placemark> placemarks) {
            //       Placemark place = placemarks[0];
            //       log('place is : ${place.toJson()}');
            //       //street + locality+sublocality
            //     }).catchError((e) {
            //       // debugPrint(e);
            //     });
            //     // Get.to(() => CheckLocation());
            //     // await placemarkFromCoordinates(18.658102, 73.731081)
            //     //     .then((List<Placemark> placemarks) {
            //     //   Placemark place = placemarks[0];
            //     //   log('place is : ${place.toJson()}');

            //     //   // String currentAddress =
            //     //   //     '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
            //     // }).catchError((e) {});
            //     // // CommonViews.showProgressDialog(context);

            //     // // await loc.getCurrentPosition().then((value) {
            //     // //   Navigator.pop(context);
            //     // // }).catchError((onError) {
            //     // //   log('errorsssssssss : ${onError.toString()}');
            //     // // });
            //   },
            //   child: const Text('check location'),
            //   color: Colors.green,
            // ),
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
            const SizedBox(height: 20),
            selectedChip == 0
                ? meet.isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _upcomingMeetingList.length,
                        itemBuilder: (context, i) {
                          DateTime _shceduleDate =
                              DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                  _upcomingMeetingList[i]
                                      .scheduleDate
                                      .toString());
                          return Container(
                            width: Get.width,
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
                            decoration: BoxDecoration(
                                // color: Colors.grey,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: Appcolors.grey.withOpacity(0.2),
                                )),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                _upcomingMeetingList[i].locationPosition == null
                                    ? const SizedBox.shrink()
                                    : InkWell(
                                        onTap: () async {
                                          // await loc.getCurrentPosition();
                                          Get.to(() => PickMapScreen(
                                                isFromUpcomingMeeting: true,
                                                upcomingMeeting:
                                                    _upcomingMeetingList[i],
                                                _upcomingMeetingList[i]
                                                            .locationPosition !=
                                                        null
                                                    ? _upcomingMeetingList[i]
                                                        .locationPosition!
                                                        .latitude
                                                    : 0.0,
                                                _upcomingMeetingList[i]
                                                            .locationPosition !=
                                                        null
                                                    ? _upcomingMeetingList[i]
                                                        .locationPosition!
                                                        .longitude
                                                    : 0.0,
                                              ));
                                        },
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Appcolors.red,
                                          size: 30,
                                        )),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 150,
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      decoration: BoxDecoration(
                                          color: Appcolors.blueLight,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Text(
                                            DateFormat('dd')
                                                .format(_shceduleDate)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Appcolors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('MMM')
                                                .format(_shceduleDate)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Appcolors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('yyyy')
                                                .format(_shceduleDate)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Appcolors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            DateFormat('hh:mm a')
                                                .format(_shceduleDate)
                                                .toString(),
                                            style: const TextStyle(
                                              color: Appcolors.black,
                                              fontWeight: FontWeight.w200,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      // height: 120,
                                      // width: 135,
                                      width: Get.width * 0.5,
                                      alignment: Alignment.center,
                                      margin: const EdgeInsets.only(left: 20),
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 0, 10, 10),
                                      decoration: BoxDecoration(
                                          // color: Appcolors.blueLight,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _upcomingMeetingList[i].name ?? '',
                                            style: const TextStyle(
                                              color: Appcolors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 18,
                                            ),
                                          ),
                                          Text(
                                            _upcomingMeetingList[i].firstLine ??
                                                '',
                                            style: const TextStyle(
                                              color: Appcolors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            _upcomingMeetingList[i]
                                                    .secondLine ??
                                                '',
                                            // _upcomingMeetingList[i].address2 ??
                                            //     '',
                                            style: const TextStyle(
                                              color: Appcolors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            _upcomingMeetingList[i].area ?? ''
                                            // _upcomingMeetingList[i].locality ??
                                            //     ''
                                            // _upcomingMeetingList[i].area ?? ''
                                            ,
                                            style: const TextStyle(
                                              color: Appcolors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                          Text(
                                            _upcomingMeetingList[i].city !=
                                                        null &&
                                                    _upcomingMeetingList[i]
                                                            .city !=
                                                        ''
                                                ? 'City ${_upcomingMeetingList[i].city}'
                                                : '',
                                            style: const TextStyle(
                                              color: Appcolors.grey,
                                              fontSize: 15,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                        child: _upcomingMeetingList[i]
                                                    .isLoading ??
                                                false
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : CustomButton(
                                                buttonColor: Appcolors.redLight,
                                                textColor: Appcolors.red,
                                                buttonText:
                                                    _upcomingMeetingList[i]
                                                        .btnOneLabel,
                                                onPressed: () async {
                                                  _commentController.clear();
                                                  showDialogue(meet,
                                                      _upcomingMeetingList[i]);
                                                },
                                              )),
                                    const SizedBox(width: 10),
                                    Expanded(
                                        child: _upcomingMeetingList[i]
                                                    .isChangeMeetingStateLoading ??
                                                false
                                            ? const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              )
                                            : CustomButton(
                                                buttonText:
                                                    _upcomingMeetingList[i]
                                                        .btnTwoLabel,
                                                onPressed: () async {
                                                  // await loc.getMeetingLocation(
                                                  //     _upcomingMeetingList[i],
                                                  //     context);
                                                  if (_upcomingMeetingList[i]
                                                          .btnTwoLabel ==
                                                      'Done') {
                                                    final result = await meet.changeMeetingState(
                                                        _upcomingMeetingList[i],
                                                        _upcomingMeetingList[i]
                                                                    .locationPosition ==
                                                                null
                                                            ? 0.0
                                                            : _upcomingMeetingList[
                                                                    i]
                                                                .locationPosition!
                                                                .latitude,
                                                        _upcomingMeetingList[i]
                                                                    .locationPosition ==
                                                                null
                                                            ? 0.0
                                                            : _upcomingMeetingList[
                                                                    i]
                                                                .locationPosition!
                                                                .longitude,
                                                        loc.area!,
                                                        'Completed');

                                                    if (result) {
                                                      CommonFunctions
                                                          .showSuccessToast(meet
                                                              .rescheduleMeetingMessage);
                                                      getMeetings();
                                                    }
                                                  } else if (_upcomingMeetingList[
                                                                  i]
                                                              .locationPosition ==
                                                          null ||
                                                      _upcomingMeetingList[i]
                                                              .address1 ==
                                                          null ||
                                                      _upcomingMeetingList[i]
                                                              .address2 ==
                                                          null ||
                                                      _upcomingMeetingList[i]
                                                              .locality ==
                                                          null ||
                                                      _upcomingMeetingList[i]
                                                              .city ==
                                                          null) {
                                                    // if (locationsList.contains(
                                                    //         _upcomingMeetingList[
                                                    //                 i]
                                                    //             .id) ==
                                                    //     false) {
                                                    //   locationsList.add(
                                                    //       _upcomingMeetingList[
                                                    //               i]
                                                    //           .id!);
                                                    // }
                                                    log('meeting location null is executed');
                                                    await loc.getMeetingLocation(
                                                        _upcomingMeetingList[i],
                                                        context);
                                                    log('city : ${_upcomingMeetingList[i].city}');
                                                    log('address 2 : ${_upcomingMeetingList[i].address2}');
                                                    log('date time meeting screen after location picked : ${DateTime.now()}');

                                                    final result = await meet
                                                        .changeMeetingState(
                                                            _upcomingMeetingList[
                                                                i],
                                                            _upcomingMeetingList[
                                                                    i]
                                                                .locationPosition!
                                                                .latitude,
                                                            _upcomingMeetingList[
                                                                    i]
                                                                .locationPosition!
                                                                .longitude,
                                                            loc.area!,
                                                            _upcomingMeetingList[
                                                                    i]
                                                                .btnTwoLabel!);
                                                    if (result) {
                                                      CommonFunctions
                                                          .showSuccessToast(meet
                                                              .rescheduleMeetingMessage);
                                                      reachedIndex = i;
                                                      getMeetings();
                                                    }
                                                  } else {
                                                    log('meeting else is executed');
                                                    await loc.getMeetingLocation(
                                                        _upcomingMeetingList[i],
                                                        context);
                                                    final result = await meet
                                                        .changeMeetingState(
                                                            _upcomingMeetingList[
                                                                i],
                                                            _upcomingMeetingList[
                                                                    i]
                                                                .locationPosition!
                                                                .latitude,
                                                            _upcomingMeetingList[
                                                                    i]
                                                                .locationPosition!
                                                                .longitude,
                                                            loc.area!,
                                                            _upcomingMeetingList[
                                                                    i]
                                                                .btnTwoLabel!);
                                                    if (result) {
                                                      CommonFunctions
                                                          .showSuccessToast(meet
                                                              .rescheduleMeetingMessage);
                                                      getMeetings();
                                                    }
                                                  }
                                                },
                                              )),
                                  ],
                                )
                              ],
                            ),
                          );
                        })
                : selectedChip == 1
                    ? meet.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _completedMeetingList.length,
                            itemBuilder: (context, i) {
                              DateTime _shceduleDate =
                                  DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                      _completedMeetingList[i]
                                          .scheduleDate
                                          .toString());
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          // await loc.getCurrentPosition();
                                          Get.to(() => PickMapScreen(
                                                _completedMeetingList[i]
                                                            .latitude !=
                                                        null
                                                    ? double.parse(
                                                        _completedMeetingList[i]
                                                            .latitude!)
                                                    : 0.0,
                                                _completedMeetingList[i]
                                                            .longitude !=
                                                        null
                                                    ? double.parse(
                                                        _completedMeetingList[i]
                                                            .longitude!)
                                                    : 0.0,
                                              ));
                                        },
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Appcolors.red,
                                          size: 30,
                                        )),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 150,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          decoration: BoxDecoration(
                                              color: Appcolors.blueLight,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                DateFormat('dd')
                                                    .format(_shceduleDate)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Appcolors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('MMM')
                                                    .format(_shceduleDate)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('yyyy')
                                                    .format(_shceduleDate)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('hh:mm a')
                                                    .format(_shceduleDate)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Appcolors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // height: 120,
                                          // width: Get.width * 0.5,
                                          alignment: Alignment.center,
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          decoration: BoxDecoration(
                                              // color: Appcolors.blueLight,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: Get.width * 0.5,
                                                child: Text(
                                                  _completedMeetingList[i]
                                                      .name!,
                                                  style: const TextStyle(
                                                    color: Appcolors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _completedMeetingList[i]
                                                        .firstLine ??
                                                    '',
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                _completedMeetingList[i]
                                                        .secondLine ??
                                                    '',
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                _completedMeetingList[i].area ??
                                                    '',
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                'City ${_completedMeetingList[i].cityName ?? ''}',
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            })
                    : meet.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _delayMeetingList.length,
                            itemBuilder: (context, i) {
                              DateTime _shceduleDate =
                                  DateFormat("yyyy-MM-dd hh:mm:ss").parse(
                                      _delayMeetingList[i]
                                          .scheduleDate
                                          .toString());
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                        onTap: () async {
                                          // await loc.getCurrentPosition();
                                          Get.to(() => PickMapScreen(
                                                _delayMeetingList[i].latitude !=
                                                        null
                                                    ? double.parse(
                                                        _delayMeetingList[i]
                                                            .latitude!)
                                                    : 0.0,
                                                _delayMeetingList[i]
                                                            .longitude !=
                                                        null
                                                    ? double.parse(
                                                        _delayMeetingList[i]
                                                            .longitude!)
                                                    : 0.0,
                                              ));
                                        },
                                        child: const Icon(
                                          Icons.location_on,
                                          color: Appcolors.red,
                                          size: 30,
                                        )),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 150,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          decoration: BoxDecoration(
                                              color: Appcolors.blueLight,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Text(
                                                DateFormat('dd')
                                                    .format(_shceduleDate)
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Appcolors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 20,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('MMM')
                                                    .format(_shceduleDate)
                                                    .toString(),
                                                style: const TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('yyyy')
                                                    .format(_shceduleDate)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                DateFormat('hh:mm a')
                                                    .format(_shceduleDate)
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Appcolors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 15,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          // height: 120,
                                          // width: Get.width * 0.5,
                                          alignment: Alignment.center,
                                          margin:
                                              const EdgeInsets.only(left: 20),
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 0, 10, 10),
                                          decoration: BoxDecoration(
                                              // color: Appcolors.blueLight,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                width: Get.width * 0.5,
                                                child: Text(
                                                  _delayMeetingList[i].name!,
                                                  style: TextStyle(
                                                    color: Appcolors.black,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 18,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                _delayMeetingList[i]
                                                        .firstLine ??
                                                    '',
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                _delayMeetingList[i]
                                                        .secondLine ??
                                                    '',
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                _delayMeetingList[i].area ?? '',
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
                                              Text(
                                                _delayMeetingList[i].cityName ==
                                                        null
                                                    ? ''
                                                    : 'City ${_delayMeetingList[i].cityName}',
                                                style: TextStyle(
                                                  color: Appcolors.grey,
                                                  fontSize: 15,
                                                ),
                                              ),
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
