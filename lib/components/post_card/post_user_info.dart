import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/models.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../screens/club/club_detail.dart';
import '../../screens/profile/my_profile.dart';
import '../../screens/profile/other_user_profile.dart';

class PostUserInfo extends StatelessWidget {
  final PostModel post;
  final bool isSponsored;
  final ProfileController _profileController = Get.find();

  PostUserInfo({Key? key, required this.post, required this.isSponsored})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
            height: 35,
            width: 35,
            child: UserAvatarView(
              size: 35,
              user: post.user,
              onTapHandler: () {
                openProfile();
              },
            )),
        const SizedBox(width: 10),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                BodyMediumText(
                  post.user.userName,
                  weight: TextWeight.medium,
                ).ripple(() {
                  openProfile();
                }),
                if (post.user.isVerified) verifiedUserTag().rP8,
                if (post.club != null)
                  Expanded(
                    child: BodyMediumText(
                      '${sharedInString.tr} (${post.club!.name})',
                      weight: TextWeight.semiBold,
                      color: AppColorConstants.themeColor,
                      maxLines: 1,
                    ).ripple(() {
                      openClubDetail();
                    }),
                  ),
                if (post.sharedPost != null)
                  BodySmallText(
                    ' ($reSharedString) ',
                    weight: TextWeight.semiBold,
                    maxLines: 1,
                  )
              ],
            ),
            const SizedBox(
              height: 2,
            ),
            isSponsored == true
                ? BodyExtraSmallText(sponsoredString.tr)
                : Row(
                    children: [
                      ThemeIconWidget(ThemeIcon.clock, size: 12),
                      const SizedBox(
                        width: 5,
                      ),
                      BodyExtraSmallText(post.postTime.tr),
                    ],
                  ),
          ],
        )),
      ],
    );
  }

  void openProfile() async {
    if (post.user.isMe) {
      Get.to(() => const MyProfile(
            showBack: true,
          ));
    } else {
      _profileController.otherUserProfileView(
          refId: post.user.id, viewSource: UserViewSourceType.post);
      Get.to(() => OtherUserProfile(userId: post.user.id, user: post.user));
    }
  }

  void openClubDetail() async {
    Get.to(() => ClubDetail(
        club: post.club!,
        needRefreshCallback: () {},
        deleteCallback: (club) {}));
  }
}
