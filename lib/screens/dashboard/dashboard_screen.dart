import 'dart:io';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/post/watch_videos.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import '../../components/force_update_view.dart';
import '../add_on/ui/reel/reels.dart';
import '../home_feed/home_feed_screen.dart';
import '../profile/my_profile.dart';
import '../settings_menu/settings_controller.dart';
import 'explore.dart';

class DashboardController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxInt unreadMsgCount = 0.obs;
  RxBool isLoading = false.obs;

  indexChanged(int index) {
    currentIndex.value = index;
  }

  updateUnreadMessageCount(int count) {
    unreadMsgCount.value = count;
  }
}

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  DashboardState createState() => DashboardState();
}

class DashboardState extends State<DashboardScreen> {
  final DashboardController _dashboardController = Get.find();
  final SettingsController _settingsController = Get.find();

  List<Widget> widgets = [];
  bool hasPermission = false;

  @override
  void initState() {
    widgets = [
      const HomeFeedScreen(),
      const Explore(),
      const Reels(
        needBackBtn: false,
      ),
      const WatchVideos(),
      const MyProfile(
        showBack: false,
      ),
    ];

    super.initState();
  }

  List<TabItem> items = const [
    TabItem(
      icon: Icons.home_outlined,
    ),
    TabItem(
      icon: Icons.search_sharp,
    ),
    TabItem(
      icon: Icons.play_arrow_outlined,
    ),
    TabItem(
      icon: Icons.videocam_outlined,
    ),
    TabItem(
      icon: Icons.account_circle_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => _dashboardController.isLoading.value == true
        ? SizedBox(
            height: Get.height,
            width: Get.width,
            child: const Center(child: CircularProgressIndicator()),
          )
        : _settingsController.forceUpdate.value == true
            ? ForceUpdateView()
            : _settingsController.appearanceChanged?.value == null
                ? Container()
                : AppScaffold(
                    backgroundColor: AppColorConstants.backgroundColor,
                    body: widgets[_dashboardController.currentIndex.value],
                    floatingActionButtonLocation:
                        FloatingActionButtonLocation.centerDocked,
                    bottomNavigationBar: SizedBox(
                      height: Platform.isIOS ? 100 : 70,
                      width: Get.width,
                      child: BottomBarCreative(
                        items: items,
                        backgroundColor: AppColorConstants.cardColor,
                        color: AppColorConstants.iconColor,
                        colorSelected: AppColorConstants.themeColor,
                        indexSelected: _dashboardController.currentIndex.value,
                        // highlightStyle: const HighlightStyle(
                        //     sizeLarge: true,
                        //     background: Colors.red,
                        //     elevation: 3),
                        // isFloating: true,
                        onTap: (index) {
                          _dashboardController.indexChanged(index);
                        },
                        // backgroundSelected: AppColorConstants.themeColor,
                      ),
                    )));
  }

  void onTabTapped(int index) async {
    // if (index == 2) {
    //   Future.delayed(
    //     Duration.zero,
    //     () => showGeneralDialog(
    //         context: context,
    //         pageBuilder: (context, animation, secondaryAnimation) =>
    //             const AddPostScreen(
    //               postType: PostType.basic,
    //             )),
    //   );
    // } else {
    Future.delayed(
        Duration.zero, () => _dashboardController.indexChanged(index));
    // }
  }
}
