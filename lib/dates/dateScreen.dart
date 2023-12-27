import 'package:flutter/material.dart';
import 'package:flutter_camera_geolocation/dates/dateController.dart';
import 'package:get/get.dart';

class DateScreen extends StatelessWidget {
  DateController c = Get.put(DateController());

  @override
  Widget build(BuildContext context) {
    c.currentDate();
    return Scaffold(
        appBar: AppBar(title: const Text("Date Screen")),
        body: Center(child: Obx(() => Text(c.currentDate.value))));
  }
}
