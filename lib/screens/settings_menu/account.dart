import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/profile/blocked_users.dart';
import '../live/live_history.dart';
import 'package:foap/helper/imports/setting_imports.dart';

class AppAccount extends StatefulWidget {
  const AppAccount({Key? key}) : super(key: key);

  @override
  State<AppAccount> createState() => _AppAccountState();
}

class _AppAccountState extends State<AppAccount> {
  final SettingsController _settingsController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      backgroundColor: AppColorConstants.backgroundColor,
      body: Column(
        children: [
          backNavigationBar(title: accountString.tr),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Column(
                  children: [
                    addTileEvent(liveHistoryString.tr, () {
                      Get.to(() => const LiveHistory());
                    }),
                    addTileEvent(blockedUserString.tr, () {
                      Get.to(() => const BlockedUsersList());
                    }),
                    if (_settingsController
                        .setting.value!.enableProfileVerification)
                      addTileEvent(requestVerificationString.tr, () {
                        Get.to(() => const RequestVerification());
                      }),
                    // addTileEvent(
                    //     'assets/findFriends.png',
                    //     addRelationshipString.tr,
                    //     '', () {
                    //   Get.to(() => const AddRelationship());
                    // }),
                  ],
                ),
                const SizedBox(
                  height: 50,
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  addTileEvent(String title, VoidCallback action) {
    return InkWell(
        onTap: action,
        child: Column(
          children: [
            SizedBox(
              height: 50,
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BodyLargeText(title.tr, weight: TextWeight.medium)
                    ],
                  ),
                ),
                // const Spacer(),
                ThemeIconWidget(
                  ThemeIcon.nextArrow,
                  color: AppColorConstants.iconColor,
                  size: 15,
                )
              ]).hp(DesignConstants.horizontalPadding),
            ),
            divider()
          ],
        ));
  }
}
