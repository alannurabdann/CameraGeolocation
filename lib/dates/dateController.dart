import 'package:get/get.dart';
import 'package:intl/intl.dart';

class DateController extends GetxController {
  RxString currentDate = "".obs;
 
  @override
  void onInit() async {
    super.onInit();
    getDate();
  }

  getDate() {
    final String formatted = DateFormat("E, dd MMM yyy HH:mm:ss").format(DateTime.now());
    currentDate.value = formatted;
  }
}
