import 'package:foap/controllers/post/post_controller.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/number_extension.dart';
import 'package:foap/screens/profile/users_club_listing.dart';
import '../../components/highlights_bar.dart';
import '../../controllers/chat_and_call/chat_detail_controller.dart';
import '../../controllers/story/highlights_controller.dart';
import '../../controllers/profile/profile_controller.dart';
import '../../model/post_search_query.dart';
import '../add_on/controller/reel/reels_controller.dart';
import '../add_on/ui/reel/reels.dart';
import '../chat/chat_detail.dart';
import '../dashboard/mentions.dart';
import '../dashboard/posts.dart';
import '../highlights/hightlights_viewer.dart';
import '../live/gifts_list.dart';
import '../settings_menu/settings_controller.dart';
import 'follower_following_list.dart';

class OtherUserProfile extends StatefulWidget {
  final int userId;
  final UserModel? user;

  const OtherUserProfile({Key? key, required this.userId, this.user})
      : super(key: key);

  @override
  OtherUserProfileState createState() => OtherUserProfileState();
}

class OtherUserProfileState extends State<OtherUserProfile>
    with SingleTickerProviderStateMixin {
  final ProfileController _profileController = Get.find();
  final HighlightsController _highlightsController = HighlightsController();
  final SettingsController _settingsController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();
  final PostController _postController = Get.find();

  List<String> tabs = [postsString, reelsString, mentionsString];

  TabController? controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: tabs.length)
      ..addListener(() {});
    initialLoad();
  }

  initialLoad() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.user != null) {
        _profileController.setUser(widget.user!);
      }
      _profileController.clear();
      loadData();
    });
  }

  @override
  void didUpdateWidget(covariant OtherUserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    loadData();
  }

  @override
  void dispose() {
    _profileController.clear();
    _postController.clear();
    super.dispose();
  }

  loadData() {
    _profileController.getOtherUserDetail(userId: widget.userId);
    _profileController.getMentionPosts(widget.userId);

    PostSearchQuery query = PostSearchQuery();
    query.userId = widget.userId;
    _postController.setPostSearchQuery(query: query, callback: () {});
    _profileController.getReels(widget.userId);
    _highlightsController.getHighlights(userId: widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AppScaffold(
          backgroundColor: AppColorConstants.backgroundColor,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(children: [
                  if (_settingsController.appearanceChanged!.value) Container(),
                  const SizedBox(
                    height: 20,
                  ),
                  addProfileView().bP16,
                  addHighlightsView().bP16,
                  contentWidget(),
                  const SizedBox(
                    height: 20,
                  )
                ]),
              ),
              Positioned(top: 0, left: 0, right: 0, child: appBar())
            ],
          ),
        ));
  }

  Widget addProfileView() {
    return GetBuilder<ProfileController>(
        init: _profileController,
        builder: (ctx) {
          return _profileController.user.value != null
              ? Column(
                  children: [
                    Stack(
                      children: [coverImage(), imageAndNameView()],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    statsView().hp(DesignConstants.horizontalPadding),
                    const SizedBox(
                      height: 40,
                    ),
                    divider(height: 1),
                    buttonsView().hp(DesignConstants.horizontalPadding),
                    divider(height: 1),
                  ],
                )
              : Container();
        });
  }

  Widget imageAndNameView() {
    return Positioned(
      left: 0,
      right: 0,
      top: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              UserAvatarView(
                  user: _profileController.user.value!,
                  size: 85,
                  onTapHandler: () {
                    //open live
                  }),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Heading6Text(_profileController.user.value!.userName,
                      weight: TextWeight.medium),
                  if (_profileController.user.value!.isVerified)
                    verifiedUserTag()
                ],
              ).bP4,
              if (_profileController.user.value!.profileCategoryTypeId != 0)
                BodyLargeText(
                        _profileController.user.value!.profileCategoryTypeName,
                        weight: TextWeight.regular)
                    .bP4,
              if (_profileController.user.value?.country != null)
                BodyMediumText(
                  '${_profileController.user.value!.country},${_profileController.user.value!.city}',
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget coverImage() {
    return _profileController.user.value!.coverImage != null
        ? CachedNetworkImage(
                width: Get.width,
                height: 250,
                fit: BoxFit.cover,
                imageUrl: _profileController.user.value!.coverImage!)
            .bottomRounded(20)
        : SizedBox(
            width: Get.width,
            height: 250,
            // color: AppColorConstants.themeColor.withOpacity(0.2),
          );
  }

  Widget buttonsView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          child: Center(
            child: BodyMediumText(
              _profileController.user.value!.followingStatus ==
                      FollowingStatus.following
                  ? unFollowString.tr
                  : _profileController.user.value!.followingStatus ==
                          FollowingStatus.requested
                      ? requestedString.tr
                      : _profileController.user.value!.isFollower
                          ? followBackString.tr
                          : followString.tr,
              color: _profileController.user.value!.followingStatus ==
                      FollowingStatus.following
                  ? AppColorConstants.themeColor
                  : AppColorConstants.mainTextColor,
              weight: _profileController.user.value!.followingStatus ==
                      FollowingStatus.following
                  ? TextWeight.bold
                  : TextWeight.medium,
            ),
          ),
        ).ripple(() {
          _profileController.followUnFollowUser(
              user: _profileController.user.value!);
        }),
        Container(
          height: 40,
          width: 1,
          color: AppColorConstants.dividerColor,
        ),
        if (_settingsController.setting.value!.enableChat)
          SizedBox(
            height: 40,
            child: Center(child: BodyMediumText(chatString.tr)),
          ).ripple(() {
            Loader.show(status: loadingString.tr);
            _chatDetailController.getChatRoomWithUser(
                userId: _profileController.user.value!.id,
                callback: (room) {
                  Loader.dismiss();
                  Get.to(() => ChatDetail(
                        chatRoom: room,
                      ));
                });
          }),
        Container(
          height: 40,
          width: 1,
          color: AppColorConstants.dividerColor,
        ),
        if (_settingsController.setting.value!.enableGift)
          SizedBox(
            height: 40,
            child: Center(child: BodyMediumText(sendGiftString.tr)),
          ).ripple(() {
            showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return FractionallySizedBox(
                      heightFactor: 0.8,
                      child: GiftsPageView(giftSelectedCompletion: (gift) {
                        Get.back();
                        _profileController.sendGift(gift);
                      }));
                });
          }),
      ],
    );
  }

  Widget statsView() {
    return Container(
      color: AppColorConstants.cardColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Heading4Text(
                _profileController.user.value!.totalPost.toString(),
              ).bP8,
              BodySmallText(
                postsString.tr,
              ),
            ],
          ).ripple(() {
            if (_profileController.user.value!.totalPost > 0) {
              Get.to(() => Posts(
                    userId: _profileController.user.value!.id,
                    title: _profileController.user.value!.userName,
                  ));
            }
          }),
          // const SizedBox(
          //   width: 20,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Heading4Text(
                '${_profileController.user.value!.totalFollower}',
              ).bP8,
              BodySmallText(
                followersString.tr,
              ),
            ],
          ).ripple(() {
            if (_profileController.user.value!.totalFollower > 0) {
              Get.to(() => FollowerFollowingList(
                        isFollowersList: true,
                        userId: widget.userId,
                      ))!
                  .then((value) {
                initialLoad();
              });
            }
          }),
          // const SizedBox(
          //   width: 20,
          // ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Heading4Text(
                '${_profileController.user.value!.totalFollowing}',
              ).bP8,
              BodySmallText(
                followingString.tr,
              ),
            ],
          ).ripple(() {
            if (_profileController.user.value!.totalFollowing > 0) {
              Get.to(() => FollowerFollowingList(
                        isFollowersList: false,
                        userId: widget.userId,
                      ))!
                  .then((value) {
                initialLoad();
              });
            }
          }),
        ],
      ).p16,
    ).round(15);
  }

  Widget appBar() {
    return Container(
      height: 100,
      color: AppColorConstants.cardColor,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
              width: 50,
              child: Align(
                alignment: Alignment.centerLeft,
                child: ThemeIconWidget(
                  ThemeIcon.backArrow,
                  size: 18,
                ),
              )).ripple(() {
            Get.back();
          }),
          ThemeIconWidget(
            ThemeIcon.more,
          ).ripple(() {
            openActionPopup();
          }),
        ],
      ).setPadding(
          left: DesignConstants.horizontalPadding,
          right: DesignConstants.horizontalPadding,
          top: 40),
    );
  }

  void openActionPopup() {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              color: AppColorConstants.backgroundColor,
              child: Wrap(
                children: [
                  ListTile(
                      title: Center(child: BodyLargeText(reportString.tr)),
                      onTap: () async {
                        Get.back();

                        _profileController.reportUser();
                      }),
                  divider(),
                  ListTile(
                      title: Center(child: BodyLargeText(blockString.tr)),
                      onTap: () async {
                        Get.back();

                        _profileController.blockUser();
                      }),
                  divider(),
                  ListTile(
                      title: Center(child: BodyLargeText(cancelString.tr)),
                      onTap: () {
                        Get.back();
                      }),
                ],
              ),
            ));
  }

  Widget addHighlightsView() {
    return GetBuilder<HighlightsController>(
        init: _highlightsController,
        builder: (ctx) {
          return _highlightsController.isLoading.value == true
              ? const StoryAndHighlightsShimmer()
              : _highlightsController.highlights.isEmpty
                  ? Container()
                  : HighlightsBar(
                      highlights: _highlightsController.highlights,
                      viewHighlightCallback: (highlight) {
                        Get.to(() => HighlightViewer(highlight: highlight))!
                            .then((value) {
                          loadData();
                        });
                      },
                    );
        });
  }

  Widget contentWidget() {
    return _profileController.user.value == null
        ? Container()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: (Get.width -
                            (2 * DesignConstants.horizontalPadding) -
                            5) /
                        2,
                    height: 50,
                    color: AppColorConstants.cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodyLargeText(
                          postsString,
                          weight: TextWeight.semiBold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BodyMediumText(
                          '(${_profileController.user.value!.totalPost.formatNumber})',
                          weight: TextWeight.bold,
                        ),
                      ],
                    ),
                  ).round(10).ripple(() {
                    if (_profileController.user.value!.totalPost > 0) {
                      Get.to(() => Posts(
                            userId: _profileController.user.value!.id,
                            title: _profileController.user.value!.userName,
                          ));
                    }
                  }),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: (Get.width -
                            (2 * DesignConstants.horizontalPadding) -
                            5) /
                        2,
                    height: 50,
                    color: AppColorConstants.cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodyLargeText(
                          reelsString,
                          weight: TextWeight.semiBold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BodyMediumText(
                          '(${_profileController.user.value!.totalReels.formatNumber})',
                          weight: TextWeight.bold,
                        ),
                      ],
                    ),
                  ).round(10).ripple(() {
                    if (_profileController.user.value!.totalReels > 0) {
                      ReelsController reelsController = Get.find();

                      PostSearchQuery query = PostSearchQuery();
                      query.userId = _profileController.user.value!.id;
                      reelsController.setReelsSearchQuery(query);
                      Get.to(() => const Reels(
                            needBackBtn: true,
                          ));
                    }
                  }),
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: (Get.width -
                            (2 * DesignConstants.horizontalPadding) -
                            5) /
                        2,
                    height: 50,
                    color: AppColorConstants.cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodyLargeText(
                          mentionsString,
                          weight: TextWeight.semiBold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BodyMediumText(
                          '(${_profileController.user.value!.totalMentions.formatNumber})',
                          weight: TextWeight.bold,
                        ),
                      ],
                    ),
                  ).round(10).ripple(() {
                    if (_profileController.user.value!.totalMentions > 0) {
                      Get.to(() =>
                          Mentions(userId: _profileController.user.value!.id));
                    }
                  }),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: (Get.width -
                            (2 * DesignConstants.horizontalPadding) -
                            5) /
                        2,
                    height: 50,
                    color: AppColorConstants.cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BodyLargeText(
                          clubsString,
                          weight: TextWeight.semiBold,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        BodyMediumText(
                          '(${_profileController.user.value!.totalClubs.formatNumber})',
                          weight: TextWeight.bold,
                        ),
                      ],
                    ),
                  ).round(10).ripple(() {
                    if (_profileController.user.value!.totalClubs > 0) {
                      Get.to(() => UsersClubs(
                            user: _profileController.user.value!,
                          ));
                    }
                  }),
                ],
              ),
            ],
          ).hp(DesignConstants.horizontalPadding);
  }
}
