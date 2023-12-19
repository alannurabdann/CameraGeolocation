import 'package:flutter_camera_geolocation/profiles/profileScreen.dart';
import 'package:get/get.dart';

import '../cameras/cameraScreen.dart';
import 'appRoutes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.main,
      page: () => CameraScreen(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileScreen(),
    ),
  ];
}
