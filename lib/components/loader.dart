import 'package:lottie/lottie.dart';
import '../helper/imports/common_import.dart';

class Loader {
  static bool _isShowing = false; // Flag to track if bottom sheet is showing

  static void show({String? status}) {
    if (_isShowing) {
      // Bottom sheet is already showing, don't show another one
      return;
    }

    _isShowing = true; // Set the flag to true

    showModalBottomSheet<void>(
      context: Get.context!,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(Get.context!),
        duration: const Duration(
            seconds: 0), // Set the duration to 0 to disable animation
      ),
      builder: (BuildContext context) {
        return FractionallySizedBox(
          heightFactor: 1,
          child: SizedBox(
            // color: Colors.black.withOpacity(0.7),
            height: Get.height,
            width: Get.width,
            child: Center(
              child: Lottie.asset('assets/lottie/syahi.json', height: 200),
            ),
          ),
        );
      },
    );
  }

  static void dismiss() {
    if (_isShowing) {
      // Future.delayed(const Duration(seconds: 2), () {
      _isShowing = false; // Set the flag to false when dismissing
      Navigator.of(Get.context!).pop(); // Dismiss the bottom sheet
      // });
    }
  }
}
