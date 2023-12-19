import 'package:flutter/material.dart';
import 'package:flutter_camera_geolocation/profiles/profileController.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  ProfileController profC = Get.put(ProfileController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Profile")),
        body: Obx(() => profC.isLoaded.value
            ? Container(
                margin: const EdgeInsets.all(8),
                child: Card(
                    elevation: 1.0,
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(8),
                      leading: const SizedBox(height: double.infinity, child: Icon(Icons.person_rounded, size: 36,)),
                      title: Text(
                        profC.profile.name, style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profC.profile.phone),
                          Text(profC.profile.branch),
                        ],
                      ),
                    )))
            : const Center(
                child: CircularProgressIndicator(),
              )));
  }
}
