import 'package:flutter_camera_geolocation/cameraScreen.dart';
import 'package:get/get.dart';

import 'appRoutes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.main,
      page: () => CameraScreen(),
    ),
  ];
}