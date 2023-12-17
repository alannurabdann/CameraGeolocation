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
        body: SingleChildScrollView(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                    margin: const EdgeInsets.all(16),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        c.getImage(context);
                      },
                      child: const Text("Capture Image",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                    )),
                Obx(
                  () => !c.imageCapture.value
                      ? Container()
                      : Container(
                          margin: const EdgeInsets.all(16),
                          height: 480,
                          width: 300,
                          color: Colors.amberAccent[30],
                          child: Screenshot(
                            controller: c.screenshotC,
                            child: Stack(
                              fit: StackFit.expand,
                              alignment: Alignment.topCenter,
                              children: [
                                Image.file(
                                  File(c.imagePath.value),
                                  fit: BoxFit.cover,
                                ),
                                Obx(() => c.myAddress.value != ""
                                    ? Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Container(
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    width: 0,
                                                    color: Colors
                                                        .transparent), //color is transparent so that it does not blend with the actual color specified
                                                color: const Color.fromARGB(
                                                    144,
                                                    252,
                                                    242,
                                                    242) // Specifies the background color and the opacity
                                                ),
                                            //color: Colors.amber,
                                            padding: const EdgeInsets.all(5),
                                            child: Text(
                                              c.myAddress.value,
                                            )))
                                    : Container())
                              ],
                            ),
                          )),
                )
              ]),
        ));
  }
}
