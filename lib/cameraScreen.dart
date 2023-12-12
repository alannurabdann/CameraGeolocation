import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_camera_geolocation/camController.dart';
import 'package:get/get.dart';
import 'package:screenshot/screenshot.dart';

class CameraScreen extends StatelessWidget {
  CameraController c = Get.put(CameraController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Camera")),
      body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              width:double.infinity,
              child: ElevatedButton(
              onPressed: () {
                c.getImage();
              },
              child: const Text("Capture Image",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                primary: Colors.black,
              ),
            )),
            Obx(
              () => !c.imageCapture.value
                  ? Container()
                  : Container(
                      height: 560,
                      width: double.infinity,
                      color: Colors.amberAccent[30],
                      child: Screenshot(
                        controller: c.screenshotC,
                        child: Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Image.file(
                              File(c.imagePath.value),
                            ),
                            Obx(() => c.myAddress.value != ""
                                ? Container(
                                    width: 550 / 2,
                                    color: Colors.amber,
                                    padding: const EdgeInsets.all(5),
                                    child: Text(
                                      c.myAddress.value,
                                    ))
                                : Container())
                          ],
                        ),
                      )),
            )
          ]),
    );
  }
}
