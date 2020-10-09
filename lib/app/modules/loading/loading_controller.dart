import 'dart:async';

import 'package:get/get.dart';
import '../../routes/app_pages.dart';

class LoadingController extends GetxController {
  @override
  void onInit() async {
    await Future.delayed(Duration(seconds: 1));
    Get.offAndToNamed(Routes.HOME);
  }

  @override
  void onReady() {}

  @override
  void onClose() {}
}
