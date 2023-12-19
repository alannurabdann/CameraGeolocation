import 'package:flutter_camera_geolocation/profiles/profile.dart';
import 'package:flutter_camera_geolocation/profiles/profileServices.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  dynamic profile;
  RxBool isLoaded = false.obs;
  RxList listProfile = [].obs;

  @override
  void onInit() async {
    super.onInit();
    //await initProfile();
    Future.delayed(const Duration(seconds: 3)).then((value) {
      getListProfile();
    });
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

  Future getListProfile() async {
    isLoaded.value = false;
    ProfileServices().getProfiles().then((value) async {
      print("RESPONSE STATUS ${value.body['status']}");
      if (value.body['status'] == 1) {
        listProfile.value = value.body['data'];
        var p = listProfile[0]; //ambil data index pertama
        profile = Profiles(name: p['name'], branch: p['branch'] ,phone: p['phone'], email: p['email']);
        isLoaded.value = true;
        update();
      } else {
        Get.snackbar("Whooops!", "Something went wrong!");
      }
    });
  }
}
