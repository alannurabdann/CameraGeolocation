import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screenshot/screenshot.dart';

class CameraController extends GetxController {
  List<XFile>? _imageFileList;
  RxBool imageCapture = false.obs;
  RxString imagePath = "".obs;
  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  late Position _currentPosition;
  RxString myAddress = "".obs;
  RxString currentDate = "".obs;
  ScreenshotController screenshotC = ScreenshotController();

  @override
  void onInit() async {
    super.onInit();
    askPermission();
    getdate();
  }

  void askPermission() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.storage,
      Permission.camera,
      Permission.mediaLibrary,
    ].request();
  }

  final picker = ImagePicker();
  Future getImage() async {
    try {
      getLocation();
      imageCapture.value = false;
      final XFile? photo = await picker.pickImage(
          source: ImageSource.camera,
          maxWidth: 640,
          maxHeight: 480,
          imageQuality: 100);
      _setImageFileListFromFile(photo);
      //File result = File(_imageFileList![0].path);
      imagePath.value = _imageFileList![0].path.toString();
      imageCapture.value = true;
      await saveImage();
      update();
    } catch (platformException) {
      imageCapture.value = true;
      print("not allowing " + platformException.toString());
    }
  }

  void _setImageFileListFromFile(XFile? value) {
    _imageFileList = value == null ? null : <XFile>[value];
  }

//  String _currentAddress;
  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);
      Placemark place = p[0];
      myAddress.value =
          "${_currentPosition.latitude.toString()}, ${_currentPosition.longitude.toString()}"
          "\n${place.name}, ${place.subLocality}, ${place.locality}, ${place.postalCode}"
          "\n${currentDate.value}";
      print(myAddress.value);
      update();
    } catch (e) {
      print(e);
    }
  }

  getdate() {
    final String formatted = DateFormat.yMd().add_jm().format(DateTime.now());
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

    // String fname = f.format(DateTime.now());
    // fname = fname + "png";
    // final boundary =
    //     key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    // final image = await boundary?.toImage();
    // final byteData = await image?.toByteData(format: ImageByteFormat.png);
    // final imageBytes = byteData?.buffer.asUint8List();

    // if (imageBytes != null) {
    //   final directory = await getApplicationDocumentsDirectory();
    //   final imagePath =
    //       await File('${directory.path}/$fname').create();
    //   await imagePath.writeAsBytes(imageBytes);
    //   print("Image Saved!");
    // }else {
    //    print("Image Null!");
    // }

    // if (imageBytes != null) {
    //   await ImageGallerySaver.saveImage(Uint8List.fromList(imageBytes),
    //       quality: 100, name: "$fname.png");
    //   Get.snackbar(
    //     "Image Capture",
    //     "Saved to gallery",
    //     colorText: Colors.white,
    //     backgroundColor: Colors.green,
    //     icon: const Icon(Icons.check_circle),
    //   );
    // } else {
    //   Get.snackbar("Image Capture", "Cannot save image to gallery.",
    //       colorText: Colors.white,
    //       backgroundColor: Colors.red,
    //       icon: const Icon(Icons.warning_rounded));
    // }
  }
}
