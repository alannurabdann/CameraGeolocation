import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class CameraController extends GetxController {
  RxBool imageCapture = false.obs;
  RxString imagePath = "".obs;
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  late Position _currentPosition;
  RxString myAddress = "".obs;
  RxString currentDate = "".obs;
  ScreenshotController screenshotC = ScreenshotController();
  RxInt imageWidth = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    askPermission();
  }

  void askPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.mediaLibrary,
    ].request();
  }

  Future getImage(BuildContext context) async {
    getLocation();
    getdate();
    var image = await ImagePickerGC.pickImage(
        enableCloseButton: true,
        closeIcon: const Icon(
          Icons.close,
          color: Colors.red,
          size: 12,
        ),
        context: context,
        source: ImgSource.Camera,
        barrierDismissible: true,
        cameraIcon: const Icon(
          Icons.camera_alt,
          color: Colors.red,
        ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
        cameraText: const Text(
          "From Camera",
          style: TextStyle(color: Colors.red),
        ),
        galleryText: const Text(
          "From Gallery",
          style: TextStyle(color: Colors.blue),
        ));
    if (image != null) {
      imagePath.value = image.path;
      imageCapture.value = true;
      print(imageWidth.value);
      saveImage();
      update();
    } else {
      print("User Cancelled");
    }
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      myAddress.value = "Lat ${_currentPosition.latitude.toString()}, "
          "Long ${_currentPosition.longitude.toString()}"
          "\n${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}"
          "\n${currentDate.value}";
      print(myAddress.value);
      update();
    } catch (e) {
      print(e);
    }
  }

  getdate() {
    //Intl.defaultLocale = 'id';
    final String formatted = DateFormat("E, dd MMM yyy HH:mm:ss").format(DateTime.now());
    currentDate.value = formatted;
  }

  getLocation() async {
    if (await Permission.location.status.isGranted) {
      await geolocator.getCurrentPosition().then((Position position) {
        _currentPosition = position;
        _getAddressFromLatLng();
      });
    }
  }

  saveImage() async {
    final f = DateFormat('yyyyMMddhhmmss');
    String fname = f.format(DateTime.now()) + ".png";

    try {
      final uint8List =
          await screenshotC.capture(delay: const Duration(seconds: 3));
      await ImageGallerySaver.saveImage(uint8List!, quality: 100, name: fname);
      Get.snackbar("Image Capture", "Saved to gallery!",
          colorText: Colors.white,
          backgroundColor: Colors.green,
          icon: const Icon(
            Icons.check_circle,
            color: Colors.white,
          ));
    } catch (e) {
      print("SAVE IMAGE : " + e.toString());
      Get.snackbar("Image Capture", "Failed to save image",
          colorText: Colors.white,
          backgroundColor: Colors.red,
          icon: const Icon(
            Icons.warning,
            color: Colors.white,
          ));
    }
  }
}
