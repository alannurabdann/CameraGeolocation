import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_file.dart';

import 'appPages.dart';
import 'appRoutes.dart';

void main() async {
  //await initializeDateFormatting('id_ID', 'en_EN').then((_) => runApp(MyApp()));
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ));
    return GetMaterialApp(
      title: 'Camera Geolocation',
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 250),
      theme: ThemeData(
        brightness: Brightness.light,
      ),
      getPages: AppPages.pages,
      initialRoute: AppRoutes.main,
    );
  }
}
