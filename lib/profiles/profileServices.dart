import 'package:get/get.dart';

class ProfileServices extends GetConnect {
  Future<Response> getProfiles() {
    var headers = {
      'Accept': 'application/json',
    };
    String uri =
        'https://naohcv6s2i.execute-api.ap-southeast-1.amazonaws.com/dev';

    return get(uri, headers: headers);
  }
}
