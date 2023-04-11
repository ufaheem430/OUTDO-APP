// import 'dart:async';
// import 'dart:convert';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:outdo_app/model/meeting_model.dart';
// import 'package:outdo_app/provider/meeting_provider.dart';
// import 'package:outdo_app/provider/shared_pref_helper.dart';
// import 'package:outdo_app/util/images.dart';
// import 'package:outdo_app/view/a.dart';
// import 'package:outdo_app/view/home/pick_map_screen.dart';
// import 'package:outdo_app/widgets/appbar.dart';
// import 'package:outdo_app/widgets/common_functions.dart';
// import 'package:outdo_app/widgets/custom_button.dart';
// import 'package:provider/provider.dart';
// import 'package:intl/intl.dart';

// import '../provider/location_provider.dart';
// import '../util/colors.dart';

// class MettingsScreen extends StatefulWidget {
//   MettingsScreen({super.key});

//   @override
//   State<MettingsScreen> createState() => _MettingsScreenState();
// }

// class _MettingsScreenState extends State<MettingsScreen> {
//   int selectedChip = 0;
//   List<String> chipsList = ['Upcoming', 'Completed', 'Delayed'];
//   List<Completed> _completedMeetingList = [];
//   List<Delay> _delayMeetingList = [];
//   List<Upcoming> _upcomingMeetingList = [];

//   void getMeetings() async {
//     String? userId = await SharedPreferenceHelper().getUserId();

//     await Provider.of<MeetingProvider>(context, listen: false)
//         .fetchMeetings(userId!);
//     _upcomingMeetingList.clear();
//     _completedMeetingList.clear();
//     _delayMeetingList.clear();
//     _upcomingMeetingList =
//         Provider.of<MeetingProvider>(context, listen: false).upcomingMeetings;

//     _completedMeetingList =
//         Provider.of<MeetingProvider>(context, listen: false).completedMeetings;
//     _delayMeetingList =
//         Provider.of<MeetingProvider>(context, listen: false).delayMeetings;
//   }

//   @override
//   void initState() {
//     getMeetings();

//     super.initState();
//   }

//   String _date = '';
//   final _commentController = TextEditingController();

//   void showDialogue(
//     MeetingProvider prov,
//     Upcoming item,
//   ) {
//     showDialog(
//         context: context,
//         builder: (ctx) {
//           return StatefulBuilder(builder: (context, setState) {
//             return AlertDialog(
//               title: Center(child: Text('Time : $_date')),
//               // title: const Text("Reschedule Meeting"),
//               content: SizedBox(
//                 height: 100,
//                 child: TextField(
//                   controller: _commentController,
//                   decoration: const InputDecoration(
//                       border: OutlineInputBorder(
//                           borderSide: BorderSide(color: Appcolors.blue)),
//                       hintText: 'Enter comment!',
//                       labelText: 'Enter comment!',
//                       prefixIcon: Icon(
//                         Icons.comment,
//                         color: Appcolors.blue,
//                       ),
//                       prefixText: ' ',
//                       suffixText: '',
//                       suffixStyle: TextStyle(color: Appcolors.blue)),
//                 ),
//               ),
//               actions: <Widget>[
//                 TextButton(
//                   onPressed: () {
//                     DatePicker.showDateTimePicker(context,
//                         showTitleActions: true,
//                         minTime: DateTime(2018, 3, 5),
//                         maxTime: DateTime(2050, 6, 7),
//                         theme: const DatePickerTheme(
//                             headerColor: Appcolors.black,
//                             backgroundColor: Appcolors.blue,
//                             itemStyle: TextStyle(
//                                 color: Colors.white,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18),
//                             cancelStyle: TextStyle(color: Colors.white),
//                             doneStyle:
//                                 TextStyle(color: Colors.white, fontSize: 16)),
//                         onChanged: (date) {
//                       _date =
//                           '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}0';
//                       // print('change $date in time zone ' +
//                       //     date.timeZoneOffset.inHours.toString());
//                       setState(() {});
//                     }, onConfirm: (date) async {
//                       _date =
//                           '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}0';

//                       setState(() {});
//                     }, currentTime: DateTime.now(), locale: LocaleType.en);
//                   },
//                   child: Container(
//                     color: Appcolors.blue,
//                     padding: const EdgeInsets.all(14),
//                     child: const Text(
//                       "Select Time",
//                       style: TextStyle(color: Appcolors.white),
//                     ),
//                   ),
//                 ),
//                 TextButton(
//                   onPressed: () async {
//                     if (_date == '') {
//                       CommonFunctions.showWarningToast('select Date & Time');
//                     } else {
//                       Navigator.of(ctx).pop();
//                       final result = await prov.rescheduleMeeting(
//                           item, _date, _commentController.text);
//                       if (result) {
//                         CommonFunctions.showSuccessToast(
//                             prov.rescheduleMeetingMessage);
//                         getMeetings();
//                       } else {
//                         CommonFunctions.showErrorToast(
//                             prov.rescheduleMeetingMessage);
//                       }
//                     }
//                   },
//                   child: Container(
//                     color: Appcolors.blue,
//                     padding: const EdgeInsets.all(14),
//                     child: const Text(
//                       "Reschedule",
//                       style: TextStyle(color: Appcolors.white),
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           });
//         });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final meet = Provider.of<MeetingProvider>(context);
//     final loc = Provider.of<LocationProvider>(context);
//     return Scaffold(
//       backgroundColor: Appcolors.white,
//       appBar: CustomAppBar('Meetings', context, isMenu: true),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 20),
//             // MaterialButton(
//             //   onPressed: () {
//             //     // showDialogue();
//             //     // showDialog(
//             //     //     context: context,
//             //     //     builder: (ctx) {
//             //     //       return AlertDialog(
//             //     //         title: Text('how are you'),
//             //     //         content: MaterialButton(
//             //     //           child: Text('button'),
//             //     //           onPressed: () {
//             //     //             DatePicker.showDatePicker(context);
//             //     //           },
//             //     //         ),
//             //     //       );
//             //     //     });
//             //   },
//             //   child: const Text('meet'),
//             //   color: Colors.green,
//             // ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 ...chipsList
//                     .asMap()
//                     .entries
//                     .map((e) => Container(
//                           margin: EdgeInsets.symmetric(
//                               horizontal: selectedChip == e.key ? 10.0 : 0),
//                           child: InkWell(
//                             onTap: () {
//                               setState(() {
//                                 selectedChip = e.key;
//                               });
//                             },
//                             child: Chip(
//                               backgroundColor: selectedChip == e.key
//                                   ? Appcolors.blue
//                                   : Appcolors.white,
//                               label: Text(e.value),
//                               labelStyle: TextStyle(
//                                   color: selectedChip == e.key
//                                       ? Appcolors.white
//                                       : Appcolors.grey,
//                                   fontSize: 16),
//                               labelPadding: const EdgeInsets.symmetric(
//                                   horizontal: 15, vertical: 5),
//                             ),
//                           ),
//                         ))
//                     .toList(),
//               ],
//             ),
//             const SizedBox(height: 30),
//             selectedChip == 0
//                 ? meet.isLoading
//                     ? const Center(
//                         child: CircularProgressIndicator(),
//                       )
//                     : ListView.builder(
//                         shrinkWrap: true,
//                         physics: const NeverScrollableScrollPhysics(),
//                         itemCount: _upcomingMeetingList.length,
//                         itemBuilder: (context, i) {
//                           DateTime _shceduleDate =
//                               DateFormat("yyyy-MM-dd hh:mm:ss").parse(
//                                   _upcomingMeetingList[i]
//                                       .scheduleDate
//                                       .toString());
//                           return Container(
//                             width: Get.width,
//                             margin: const EdgeInsets.all(10),
//                             padding: const EdgeInsets.fromLTRB(15, 15, 10, 15),
//                             decoration: BoxDecoration(
//                                 // color: Colors.grey,
//                                 borderRadius: BorderRadius.circular(10),
//                                 border: Border.all(
//                                   color: Appcolors.grey.withOpacity(0.2),
//                                 )),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Container(
//                                       height: 110,
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 10),
//                                       decoration: BoxDecoration(
//                                           color: Appcolors.blueLight,
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         children: [
//                                           Text(
//                                             DateFormat('dd')
//                                                 .format(_shceduleDate)
//                                                 .toString(),
//                                             style: TextStyle(
//                                               color: Appcolors.black,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 20,
//                                             ),
//                                           ),
//                                           Text(
//                                             DateFormat('MMM')
//                                                 .format(_shceduleDate)
//                                                 .toString(),
//                                             style: TextStyle(
//                                               color: Appcolors.grey,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                           Text(
//                                             DateFormat('yyyy')
//                                                 .format(_shceduleDate)
//                                                 .toString(),
//                                             style: TextStyle(
//                                               color: Appcolors.grey,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     Container(
//                                       // height: 120,
//                                       // width: 135,
//                                       alignment: Alignment.center,
//                                       margin: const EdgeInsets.only(left: 20),
//                                       padding: const EdgeInsets.symmetric(
//                                           horizontal: 10, vertical: 10),
//                                       decoration: BoxDecoration(
//                                           // color: Appcolors.blueLight,
//                                           borderRadius:
//                                               BorderRadius.circular(10)),
//                                       child: Column(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.spaceAround,
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             _upcomingMeetingList[i].name ?? '',
//                                             style: TextStyle(
//                                               color: Appcolors.black,
//                                               fontWeight: FontWeight.w500,
//                                               fontSize: 18,
//                                             ),
//                                           ),
//                                           Text(
//                                             loc.adddress1 ?? '',
//                                             style: const TextStyle(
//                                               color: Appcolors.grey,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                           Text(
//                                             loc.adddress2 ?? '',
//                                             style: const TextStyle(
//                                               color: Appcolors.grey,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                           Text(
//                                             loc.locality ?? ''
//                                             // _upcomingMeetingList[i].area ?? ''
//                                             ,
//                                             style: const TextStyle(
//                                               color: Appcolors.grey,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                           Text(
//                                             loc.city ?? '',
//                                             // 'City ${_upcomingMeetingList[i].area ?? ''}',
//                                             style: TextStyle(
//                                               color: Appcolors.grey,
//                                               fontSize: 15,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const Spacer(),
//                                     loc.currentPosition == null
//                                         ? SizedBox(
//                                             height: 50,
//                                             width: 50,
//                                             child: InkWell(
//                                                 onTap: () async {
//                                                   await loc
//                                                       .getCurrentPosition();
//                                                 },
//                                                 child: Image.asset(
//                                                     Images.location)))
//                                         : SizedBox(
//                                             height: 50,
//                                             width: 50,
//                                             child:
//                                                 // ignore: prefer_const_constructors
//                                                 GoogleMap(
//                                               onTap: (v) {
//                                                 Get.to(() => PickMapScreen());
//                                                 // Get.to(() => MapScreen());
//                                               },
//                                               zoomControlsEnabled: false,
//                                               compassEnabled: false,
//                                               indoorViewEnabled: true,
//                                               mapToolbarEnabled: false,
//                                               mapType: MapType.normal,
//                                               initialCameraPosition:
//                                                   const CameraPosition(
//                                                 target: LatLng(
//                                                     37.42796133580664,
//                                                     -122.085749655962),
//                                                 zoom: 14.4746,
//                                               ),
//                                               onMapCreated: (GoogleMapController
//                                                   controller) {
//                                                 // loc.controller
//                                                 //     .complete(controller);
//                                               },
//                                             ),
//                                           ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Column(
//                                   mainAxisAlignment: MainAxisAlignment.start,
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         SizedBox(
//                                             height: 25,
//                                             width: 25,
//                                             child: Image.asset(Images.clock)),
//                                         const SizedBox(width: 3),
//                                         Text(
//                                           DateFormat('hh:mm a')
//                                               .format(_shceduleDate)
//                                               .toString(),
//                                           style: const TextStyle(
//                                             color: Appcolors.black,
//                                             fontWeight: FontWeight.w200,
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const SizedBox(height: 10),
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                         child: _upcomingMeetingList[i]
//                                                     .isLoading ??
//                                                 false
//                                             ? const Center(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               )
//                                             : CustomButton(
//                                                 buttonColor: Appcolors.redLight,
//                                                 textColor: Appcolors.red,
//                                                 buttonText:
//                                                     _upcomingMeetingList[i]
//                                                         .btnOneLabel,
//                                                 onPressed: () async {
//                                                   _commentController.clear();
//                                                   showDialogue(meet,
//                                                       _upcomingMeetingList[i]);
//                                                   // DatePicker.showDateTimePicker(
//                                                   //     context,
//                                                   //     showTitleActions: true,
//                                                   //     minTime:
//                                                   //         DateTime(2018, 3, 5),
//                                                   //     maxTime:
//                                                   //         DateTime(2050, 6, 7),
//                                                   //     theme: const DatePickerTheme(
//                                                   //         headerColor:
//                                                   //             Appcolors.black,
//                                                   //         backgroundColor:
//                                                   //             Appcolors.blue,
//                                                   //         itemStyle: TextStyle(
//                                                   //             color:
//                                                   //                 Colors.white,
//                                                   //             fontWeight:
//                                                   //                 FontWeight
//                                                   //                     .bold,
//                                                   //             fontSize: 18),
//                                                   //         cancelStyle: TextStyle(
//                                                   //             color:
//                                                   //                 Colors.white),
//                                                   //         doneStyle:
//                                                   //             TextStyle(color: Colors.white, fontSize: 16)),
//                                                   //     onChanged: (date) {
//                                                   //   _date =
//                                                   //       '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}0';
//                                                   //   // print('change $date in time zone ' +
//                                                   //   //     date.timeZoneOffset.inHours.toString());
//                                                   // }, onConfirm: (date) async {
//                                                   //   _date =
//                                                   //       '${date.year}-${date.month}-${date.day} ${date.hour}:${date.minute}:${date.second}0';
//                                                   //   showDialogue(
//                                                   //       meet,
//                                                   //       _upcomingMeetingList[
//                                                   //           i]);
//                                                   // },
//                                                   //     currentTime: DateTime.now(),
//                                                   //     locale: LocaleType.en);
//                                                 },
//                                               )),
//                                     const SizedBox(width: 10),
//                                     Expanded(
//                                         child: _upcomingMeetingList[i]
//                                                     .isChangeMeetingStateLoading ??
//                                                 false
//                                             ? const Center(
//                                                 child:
//                                                     CircularProgressIndicator(),
//                                               )
//                                             : CustomButton(
//                                                 buttonText: _upcomingMeetingList[
//                                                                 i]
//                                                             .isReachedDone ==
//                                                         true
//                                                     ? 'Done'
//                                                     : _upcomingMeetingList[i]
//                                                         .btnTwoLabel,
//                                                 onPressed: () async {
//                                                   if (loc.currentPosition ==
//                                                       null) {
//                                                     loc.getCurrentPosition();
//                                                   } else if (_upcomingMeetingList[
//                                                                   i]
//                                                               .isReachedDone ==
//                                                           null ||
//                                                       _upcomingMeetingList[i]
//                                                               .isReachedDone ==
//                                                           false) {
//                                                     _upcomingMeetingList[i]
//                                                         .isReachedDone = true;

//                                                     setState(() {});
//                                                   } else {
//                                                     final result = await meet
//                                                         .changeMeetingState(
//                                                             _upcomingMeetingList[
//                                                                 i],
//                                                             loc.currentPosition!
//                                                                 .latitude,
//                                                             loc.currentPosition!
//                                                                 .longitude);
//                                                     if (result) {
//                                                       CommonFunctions
//                                                           .showSuccessToast(meet
//                                                               .rescheduleMeetingMessage);
//                                                       getMeetings();
//                                                     }
//                                                   }
//                                                 },
//                                               )),
//                                   ],
//                                 )
//                               ],
//                             ),
//                           );
//                         })
//                 : selectedChip == 1
//                     ? meet.isLoading
//                         ? const Center(
//                             child: CircularProgressIndicator(),
//                           )
//                         : ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: _completedMeetingList.length,
//                             itemBuilder: (context, i) {
//                               DateTime _shceduleDate =
//                                   new DateFormat("yyyy-MM-dd hh:mm:ss").parse(
//                                       _completedMeetingList[i]
//                                           .scheduleDate
//                                           .toString());
//                               return Container(
//                                 width: Get.width,
//                                 margin: const EdgeInsets.all(10),
//                                 padding: const EdgeInsets.all(15),
//                                 decoration: BoxDecoration(
//                                     // color: Colors.grey,
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(
//                                       color: Appcolors.grey.withOpacity(0.2),
//                                     )),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           height: 110,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 10),
//                                           decoration: BoxDecoration(
//                                               color: Appcolors.blueLight,
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Text(
//                                                 DateFormat('dd')
//                                                     .format(_shceduleDate)
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   color: Appcolors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 20,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 DateFormat('MMM')
//                                                     .format(_shceduleDate)
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 DateFormat('yyyy')
//                                                     .format(_shceduleDate)
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 120,
//                                           margin:
//                                               const EdgeInsets.only(left: 20),
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 10),
//                                           decoration: BoxDecoration(
//                                               // color: Appcolors.blueLight,
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: const [
//                                               const Text(
//                                                 'Client Name',
//                                                 style: TextStyle(
//                                                   color: Appcolors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 18,
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 'Address Line 1',
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 'Address Line 2',
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 'Landmark',
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 'City Pincode',
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 120,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 1),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Expanded(
//                                                 child: Row(
//                                                   children: [
//                                                     SizedBox(
//                                                         height: 25,
//                                                         width: 25,
//                                                         child: Image.asset(
//                                                             Images.clock)),
//                                                     // Icon(Icons.alarm, color: Appcolors.grey),
//                                                     SizedBox(width: 5),
//                                                     Text(
//                                                       DateFormat('hh:mm a')
//                                                           .format(_shceduleDate)
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                         color: Appcolors.black,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontSize: 15,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               Expanded(
//                                                   child: Image.asset(
//                                                       Images.location))
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             })
//                     : meet.isLoading
//                         ? const Center(
//                             child: CircularProgressIndicator(),
//                           )
//                         : ListView.builder(
//                             shrinkWrap: true,
//                             physics: const NeverScrollableScrollPhysics(),
//                             itemCount: _delayMeetingList.length,
//                             itemBuilder: (context, i) {
//                               DateTime _shceduleDate =
//                                   new DateFormat("yyyy-MM-dd hh:mm:ss").parse(
//                                       _delayMeetingList[i]
//                                           .scheduleDate
//                                           .toString());
//                               return Container(
//                                 width: Get.width,
//                                 margin: const EdgeInsets.all(10),
//                                 padding: const EdgeInsets.all(15),
//                                 decoration: BoxDecoration(
//                                     // color: Colors.grey,
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(
//                                       color: Appcolors.grey.withOpacity(0.2),
//                                     )),
//                                 child: Column(
//                                   children: [
//                                     Row(
//                                       children: [
//                                         Container(
//                                           height: 110,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 10),
//                                           decoration: BoxDecoration(
//                                               color: Appcolors.blueLight,
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             children: [
//                                               Text(
//                                                 DateFormat('dd')
//                                                     .format(_shceduleDate)
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   color: Appcolors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 20,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 DateFormat('MMM')
//                                                     .format(_shceduleDate)
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               Text(
//                                                 DateFormat('yyyy')
//                                                     .format(_shceduleDate)
//                                                     .toString(),
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 120,
//                                           margin:
//                                               const EdgeInsets.only(left: 20),
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 10),
//                                           decoration: BoxDecoration(
//                                               // color: Appcolors.blueLight,
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.spaceAround,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: const [
//                                               const Text(
//                                                 'Client Name',
//                                                 style: TextStyle(
//                                                   color: Appcolors.black,
//                                                   fontWeight: FontWeight.w500,
//                                                   fontSize: 18,
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 'Address Line 1',
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 'Address Line 2',
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 'Landmark',
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                               const Text(
//                                                 'City Pincode',
//                                                 style: TextStyle(
//                                                   color: Appcolors.grey,
//                                                   fontSize: 15,
//                                                 ),
//                                               ),
//                                             ],
//                                           ),
//                                         ),
//                                         Container(
//                                           height: 120,
//                                           padding: const EdgeInsets.symmetric(
//                                               horizontal: 10, vertical: 1),
//                                           decoration: BoxDecoration(
//                                               borderRadius:
//                                                   BorderRadius.circular(10)),
//                                           child: Column(
//                                             mainAxisAlignment:
//                                                 MainAxisAlignment.start,
//                                             crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                             children: [
//                                               Expanded(
//                                                 child: Row(
//                                                   children: [
//                                                     SizedBox(
//                                                         height: 25,
//                                                         width: 25,
//                                                         child: Image.asset(
//                                                             Images.clock)),
//                                                     // Icon(Icons.alarm, color: Appcolors.grey),
//                                                     SizedBox(width: 5),
//                                                     Text(
//                                                       DateFormat('hh:mm a')
//                                                           .format(_shceduleDate)
//                                                           .toString(),
//                                                       style: TextStyle(
//                                                         color: Appcolors.black,
//                                                         fontWeight:
//                                                             FontWeight.w500,
//                                                         fontSize: 15,
//                                                       ),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               ),
//                                               // Container(
//                                               //   height: 70,
//                                               //   width: 90,
//                                               //   decoration: const BoxDecoration(
//                                               //     image: DecorationImage(
//                                               //       fit: BoxFit.fill,
//                                               //       image: AssetImage(Images.location),
//                                               //     ),
//                                               //   ),
//                                               // )
//                                               Expanded(
//                                                   child: Image.asset(
//                                                       Images.location))
//                                             ],
//                                           ),
//                                         )
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             }),
//           ],
//         ),
//       ),
//     );
//   }
// }
