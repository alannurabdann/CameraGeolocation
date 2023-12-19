import 'package:flutter_camera_geolocation/profiles/profile.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  dynamic profile;
  RxBool isLoaded = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await initProfile();
  }

  Future initProfile() async {
    isLoaded.value = false;
    Future.delayed(const Duration(seconds: 3)).then((value) {
      profile = Profiles(
          name: "Jack Sparrow",
          branch: "INDONESIA",
          phone: "0819-5672-7272",
          email: "jacks@gmail.com");
      isLoaded.value = true;
      update();
    });
  }
}
