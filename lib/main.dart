import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:outdo_app/provider/auth_provider.dart';
import 'package:outdo_app/provider/location_provider.dart';
import 'package:outdo_app/provider/meeting_provider.dart';
import 'package:outdo_app/view/signin_screen.dart';
import 'package:outdo_app/view/splash_screen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => AuthProvider()),
        ChangeNotifierProvider(create: (ctx) => MeetingProvider()),
        ChangeNotifierProvider(create: (ctx) => LocationProvider()),
      ],
      child: GetMaterialApp(
        title: 'OutDo App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
