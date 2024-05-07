import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flare_flutter/flare_controls.dart';
import 'package:foap/components/post_card/post_user_info.dart';
import 'package:foap/components/post_card/reshare_post.dart';
import 'package:foap/components/post_card/reshared_post_card.dart';
import 'package:foap/components/post_card/post_text_widget.dart';
import 'package:foap/screens/post/edit_post.dart';
import 'package:foap/controllers/post/post_gift_controller.dart';
import 'package:foap/components/post_card/video_widget.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/post_imports.dart';
import 'package:profanity_filter/profanity_filter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../controllers/chat_and_call/chat_detail_controller.dart';
import '../../controllers/chat_and_call/select_user_for_chat_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/post/comments_controller.dart';
import '../../screens/post/liked_by_users.dart';
import '../../controllers/post/promotion_controller.dart';
import '../../screens/chat/chat_detail.dart';
import '../../screens/chat/select_users.dart';
import '../../screens/club/club_detail.dart';
import '../../screens/home_feed/comments_screen.dart';
import '../../screens/home_feed/post_media_full_screen.dart';
import '../../screens/live/gifts_list.dart';
import '../../screens/post/post_promotion/post_promotion.dart';
import '../../screens/post/received_gifts.dart';
import '../../screens/post/view_post_insight.dart';
import '../../screens/profile/other_user_profile.dart';
import '../audio_tile.dart';

class PostMediaTile extends StatelessWidget {
  final PostCardController postCardController = Get.find();
  final HomeController homeController = Get.find();

  final PostModel model;
  final bool isSharedPostMedia;

  PostMediaTile(
      {Key? key, required this.model, required this.isSharedPostMedia})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return mediaTile();
  }

  Widget mediaTile() {
    if (model.gallery.length > 1) {
      return SizedBox(
        height: 350,
        child: Stack(
          children: [
            CarouselSlider(
              items: mediaList(isSharedPostMedia),
              options: CarouselOptions(
                aspectRatio: 1,
                enlargeCenterPage: false,
                enableInfiniteScroll: false,
                height: double.infinity,
                viewportFraction: 1,
                onPageChanged: (index, reason) {
                  postCardController.updateGallerySlider(index, model.id);
                },
              ),
            ),
            Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Align(
                  alignment: Alignment.center,
                  child: Obx(
                    () {
                      return DotsIndicator(
                        dotsCount: model.gallery.length,
                        position: (postCardController
                                .postScrollIndexMapping[model.id] ??
                            0),
                        decorator: DotsDecorator(
                            activeColor: Theme.of(Get.context!).primaryColor),
                      );
                    },
                  ),
                ))
          ],
        ),
      );
    } else {
      return model.gallery.first.isVideoPost == true
          ? videoPostTile(
              media: model.gallery.first, isReshared: isSharedPostMedia)
          : model.gallery.first.isAudioPost
              ? AudioPostTile(
                  post: model,
                  isResharedPost: isSharedPostMedia,
                )
              : SizedBox(
                  height: 350, child: photoPostTile(model.gallery.first));
    }
  }

  List<Widget> mediaList(bool isReshared) {
    return model.gallery.map((item) {
      if (item.isVideoPost == true) {
        return videoPostTile(media: item, isReshared: isReshared);
      } else {
        return photoPostTile(item);
      }
    }).toList();
  }

  Widget videoPostTile({required PostGallery media, required bool isReshared}) {
    return VisibilityDetector(
      key: Key(media.id.toString()),
      onVisibilityChanged: (visibilityInfo) {
        var visiblePercentage = visibilityInfo.visibleFraction * 100;
        homeController.setCurrentVisibleVideo(
            media: media, visibility: visiblePercentage);
      },
      child: Obx(() => VideoPostTile(
            media: media,
            width: isReshared
                ? Get.width - ((DesignConstants.horizontalPadding * 3) + 10)
                : Get.width,
            url: media.filePath,
            isLocalFile: false,
            play: homeController.currentVisibleVideoId.value == media.id,
            onTapActionHandler: () {},
          )),
    );
  }

  Widget photoPostTile(PostGallery media) {
    return CachedNetworkImage(
      imageUrl: media.filePath,
      fit: BoxFit.cover,
      width: Get.width,
      placeholder: (context, url) => AppUtil.addProgressIndicator(size: 100),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}

class PostContent extends StatelessWidget {
  final PostModel model;
  final PostCardController postCardController = Get.find();

  final FlareControls flareControls = FlareControls();
  final VoidCallback removePostHandler;
  final VoidCallback blockUserHandler;
  final bool isSponsored;

  PostContent(
      {Key? key,
      required this.model,
      required this.isSponsored,
      required this.removePostHandler,
      required this.blockUserHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: PostUserInfo(
              post: model,
              isSponsored: isSponsored,
            )),
            SizedBox(
              height: 20,
              width: 20,
              child: Obx(() => ThemeIconWidget(
                    postCardController.savedPosts.contains(model) ||
                            model.isSaved
                        ? ThemeIcon.bookMarked
                        : ThemeIcon.bookMark,
                    color: model.isSaved ||
                            postCardController.savedPosts.contains(model)
                        ? AppColorConstants.themeColor
                        : AppColorConstants.iconColor,
                    size: 25,
                  )),
            ).ripple(() {
              postCardController.saveUnSavePost(post: model);
            }),
            const SizedBox(
              width: 20,
            ),
            SizedBox(
              height: 20,
              width: 20,
              child: ThemeIconWidget(
                ThemeIcon.more,
                color: AppColorConstants.iconColor,
                size: 25,
              ),
            ).ripple(() {
              openActionPopup();
            })
          ],
        ).setPadding(
            left: DesignConstants.horizontalPadding,
            right: DesignConstants.horizontalPadding,
            bottom: 16),
        GestureDetector(
            onDoubleTap: () {
              //   widget.model.isLike = !widget.model.isLike;
              postCardController.likeUnlikePost(post: model);
              // widget.likeTapHandler();
              flareControls.play("like");
            },
            // onTap: () {
            //   Navigator.push(
            //     context,
            //     PageRouteBuilder(
            //       pageBuilder: (context, animation1, animation2) =>
            //           PostMediaFullScreen(gallery: model.gallery),
            //       transitionDuration: Duration.zero,
            //       reverseTransitionDuration: Duration.zero,
            //     ),
            //   );
            // },
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (model.title.isNotEmpty)
                      RichTextPostTitle(model: model).setPadding(
                          left: DesignConstants.horizontalPadding,
                          right: DesignConstants.horizontalPadding,
                          bottom: 25),
                    if (model.gallery.isNotEmpty)
                      PostMediaTile(
                        model: model,
                        isSharedPostMedia: model.sharedPost != null,
                      ),
                    if (model.sharedPost != null)
                      ResharedPostCard(model: model.sharedPost!).setPadding(
                          left: DesignConstants.horizontalPadding,
                          right: 10,
                          top: 5,
                          bottom: 15),
                  ],
                ),
                Obx(() => Positioned(
                      left: 0,
                      right: 0,
                      top: 0,
                      bottom: 0,
                      child: SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                          child: Center(
                            child: SizedBox(
                              width: 80,
                              height: 80,
                              child: FlareActor(
                                'assets/like.flr',
                                controller: flareControls,
                                animation: 'idle',
                                color: postCardController.likedPosts
                                            .contains(model) ||
                                        model.isLike
                                    ? Colors.red
                                    : Colors.white,
                              ),
                            ),
                          )),
                    ))
              ],
            )),
        // const SizedBox(
        //   height: 16,
        // ),
      ],
    );
  }

  void openActionPopup() {
    Get.bottomSheet(Container(
      color: AppColorConstants.cardColor.darken(),
      child: model.user.isMe
          ? Wrap(
              children: [
                ListTile(
                    title: Center(
                        child: Heading6Text(
                      editPostString.tr,
                      weight: TextWeight.semiBold,
                    )),
                    onTap: () async {
                      Get.back();
                      Get.to(() => EditPostScreen(post: model));
                    }),
                divider(),
                ListTile(
                    title: Center(
                        child: Heading6Text(
                      deletePostString.tr,
                      weight: TextWeight.semiBold,
                    )),
                    onTap: () async {
                      Get.back();
                      postCardController.deletePost(
                          post: model,
                          callback: () {
                            removePostHandler();
                          });
                    }),
                divider(),
                ListTile(
                    title: Center(
                        child: Heading6Text(
                      shareString.tr,
                      weight: TextWeight.semiBold,
                    )),
                    onTap: () async {
                      Get.back();
                      postCardController.sharePost(
                        post: model,
                      );
                    }),
                divider(),
                ListTile(
                    title: Center(
                        child: BodyLargeText(
                      cancelString.tr,
                      weight: TextWeight.semiBold,
                      color: AppColorConstants.red,
                    )),
                    onTap: () => Get.back()),
              ],
            )
          : Wrap(
              children: [
                ListTile(
                    title: Center(
                        child: Heading6Text(
                      reportString.tr,
                      weight: TextWeight.bold,
                    )),
                    onTap: () async {
                      Get.back();

                      AppUtil.showNewConfirmationAlert(
                        title: reportString.tr,
                        subTitle: areYouSureToReportPostString.tr,
                        okHandler: () {
                          postCardController.reportPost(
                              post: model,
                              callback: () {
                                removePostHandler();
                              });
                        },
                        cancelHandler: () {
                          Get.back();
                        },
                      );
                    }),
                divider(),
                ListTile(
                    title: Center(
                        child: Heading6Text(blockUserString.tr,
                            weight: TextWeight.bold)),
                    onTap: () async {
                      Get.back();
                      AppUtil.showNewConfirmationAlert(
                        title: blockString.tr,
                        subTitle: areYouSureToBlockUserString.tr,
                        okHandler: () {
                          postCardController.blockUser(
                              userId: model.user.id,
                              callback: () {
                                blockUserHandler();
                              });
                        },
                        cancelHandler: () {
                          Get.back();
                        },
                      );
                    }),
                divider(),
                if (!model.isSharePost)
                  ListTile(
                      title: Center(
                          child: Heading6Text(
                        shareString.tr,
                        weight: TextWeight.bold,
                      )),
                      onTap: () async {
                        Get.back();
                        postCardController.sharePost(
                          post: model,
                        );
                      }),
                if (!model.isSharePost) divider(),
                ListTile(
                    title: Center(
                      child: Heading6Text(
                        cancelString.tr,
                        weight: TextWeight.regular,
                        color: AppColorConstants.red,
                      ),
                    ),
                    onTap: () => Get.back()),
                const SizedBox(
                  height: 25,
                )
              ],
            ),
    ).round(40));
  }

  void openClubDetail() async {
    Get.to(() => ClubDetail(
        club: model.club!,
        needRefreshCallback: () {},
        deleteCallback: (club) {}));
  }
}

class PostCard extends StatefulWidget {
  final PostModel model;

  final VoidCallback removePostHandler;
  final VoidCallback blockUserHandler;

  const PostCard({
    Key? key,
    required this.model,
    required this.removePostHandler,
    required this.blockUserHandler,
  }) : super(key: key);

  @override
  PostCardState createState() => PostCardState();
}

class PostCardState extends State<PostCard> {
  final HomeController homeController = Get.find();
  final PostCardController postCardController = Get.find();
  final ChatDetailController chatDetailController = Get.find();
  final SelectUserForChatController selectUserForChatController =
      SelectUserForChatController();
  final PostGiftController _postGiftController = Get.find();
  final PromotionController _promotionController = Get.find();
  final ChatDetailController _chatDetailController = Get.find();

  TextEditingController commentInputField = TextEditingController();
  final CommentsController _commentsController = CommentsController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
        key: Key(widget.model.id.toString()),
        onVisibilityChanged: (visibilityInfo) {
          var visiblePercentage = visibilityInfo.visibleFraction * 100;
          if (visiblePercentage >= 80) {
            postCardController.postView(
                postId: widget.model.id,
                source: widget.model.postPromotionData != null
                    ? ItemViewSource.promotion
                    : ItemViewSource.normal,
                postPromotionId: widget.model.postPromotionData?.id);
          }
        },
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          PostContent(
            model: widget.model,
            isSponsored: widget.model.postPromotionData != null,
            removePostHandler: widget.removePostHandler,
            blockUserHandler: widget.blockUserHandler,
          ),
          if (widget.model.isMyPost)
            Container(
              color: AppColorConstants.cardColor.darken(),
              height: 50,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BodyLargeText(
                    viewInsightsString.tr,
                    weight: TextWeight.semiBold,
                  ).ripple(() {
                    Get.to(() => ViewPostInsights(post: widget.model));
                  }),
                  AppThemeButton(
                      text: boostPost.tr,
                      cornerRadius: 5,
                      height: 36,
                      // width: 80,
                      onPress: () {
                        _promotionController.setPromotingPost(widget.model);
                        Get.to(() => PostPromotionScreen());
                      })
                ],
              ).hp(DesignConstants.horizontalPadding),
            ),
          const SizedBox(
            height: 20,
          ),
          if (widget.model.postPromotionData != null) sponsoredPostView().bP16,
          commentsCountWidget().hp(DesignConstants.horizontalPadding),
          divider(height: 0.8).vP16,
          commentAndLikeWidget().hp(DesignConstants.horizontalPadding),
        ]));
  }

  Widget sponsoredPostView() {
    return Container(
      color: AppColorConstants.themeColor,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        BodyLargeText(
          widget.model.postPromotionData?.type == GoalType.website
              ? widget.model.postPromotionData?.urlText ?? ''
              : widget.model.postPromotionData?.type == GoalType.message
                  ? sendMessagesString.tr
                  : viewProfileString.tr,
          color: Colors.white,
          weight: TextWeight.semiBold,
        ),
        ThemeIconWidget(ThemeIcon.nextArrow, size: 25, color: Colors.white)
      ]).p8.ripple(() {
        widget.model.postPromotionData?.type == GoalType.website
            ? launchUrl(Uri.parse(widget.model.postPromotionData?.url ?? ''))
            : widget.model.postPromotionData?.type == GoalType.message
                ? openChatRoom()
                : Get.to(() => OtherUserProfile(
                    userId: widget.model.user.id, user: widget.model.user));
      }),
    );
  }

  openChatRoom() {
    Loader.show(status: loadingString.tr);
    _chatDetailController.getChatRoomWithUser(
        userId: widget.model.user.id,
        callback: (room) {
          Loader.dismiss();
          Get.to(() => ChatDetail(
                chatRoom: room,
              ));
        });
  }

  Widget viewGifts() {
    return Column(
      children: [
        widget.model.isMyPost
            ? BodyLargeText(
                viewGiftString.tr,
                // weight: TextWeight.regular,
              ).ripple(() {
                showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      _postGiftController
                          .fetchReceivedTimelineStickerGift(widget.model.id);
                      return FractionallySizedBox(
                          heightFactor: 1.5,
                          child: ReceivedGiftsList(
                            postId: widget.model.id,
                          ));
                    });
              })
            : Container(),
      ],
    ).setPadding(left: DesignConstants.horizontalPadding);
  }

  Widget commentsCountWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(() {
          int totalLikes = 0;
          if (postCardController.likedPosts.contains(widget.model)) {
            PostModel post = postCardController.likedPosts
                .where((e) => e.id == widget.model.id)
                .first;
            totalLikes = post.totalLike;
          } else {
            totalLikes = widget.model.totalLike;
          }
          return BodyMediumText(
            '$totalLikes $likesString',
            // weight: TextWeight.semiBold,
            color: AppColorConstants.mainTextColor,
          ).ripple(() {
            Get.to(() => LikedByUsers(
                  postId: widget.model.id,
                ));
          });
        }),
        if (widget.model.commentsEnabled)
          BodyMediumText(
            '${widget.model.totalComment} $commentsString',
            // weight: TextWeight.semiBold,
            color: AppColorConstants.mainTextColor,
          ).ripple(() {
            openComments();
          }),
        BodyMediumText(
          '${widget.model.totalView} $viewsString',
          // weight: TextWeight.semiBold,
          color: AppColorConstants.mainTextColor,
        ),
        BodyMediumText(
          '${widget.model.totalShare} $sharesString',
          // weight: TextWeight.semiBold,
          color: AppColorConstants.mainTextColor,
        ),
      ],
    );
  }

  Widget commentAndLikeWidget() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Row(
        children: [
          Obx(() => ThemeIconWidget(
                postCardController.likedPosts.contains(widget.model) ||
                        widget.model.isLike
                    ? ThemeIcon.favFilled
                    : ThemeIcon.fav,
                color: postCardController.likedPosts.contains(widget.model) ||
                        widget.model.isLike
                    ? AppColorConstants.red
                    : AppColorConstants.iconColor,
                size: 15,
              )),
          const SizedBox(
            width: 10,
          ),
          BodyMediumText(likeString)
        ],
      ).ripple(() {
        postCardController.likeUnlikePost(
          post: widget.model,
        );
      }),

      if (widget.model.commentsEnabled)
        Row(
          children: [
            ThemeIconWidget(
              ThemeIcon.message,
              size: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            BodyMediumText(commentString)
          ],
        ).ripple(() {
          openComments();
        }),

      Row(
        children: [
          ThemeIconWidget(
            ThemeIcon.share,
            size: 15,
          ),
          const SizedBox(
            width: 10,
          ),
          BodyMediumText(
            shareString,
          )
        ],
      ).ripple(() {
        showModalBottomSheet(
            backgroundColor: Colors.transparent,
            context: context,
            isScrollControlled: true,
            builder: (context) =>
                FractionallySizedBox(heightFactor: 0.8, child: sharePost()));
      }),
      if (!widget.model.isMyPost)
        Row(
          children: [
            ThemeIconWidget(
              ThemeIcon.gift,
              size: 15,
            ),
            const SizedBox(
              width: 10,
            ),
            BodyMediumText(giftString)
          ],
        ).ripple(() {
          showModalBottomSheet<void>(
              context: context,
              builder: (BuildContext context) {
                return FractionallySizedBox(
                    heightFactor: 0.8,
                    child: GiftsPageView(giftSelectedCompletion: (gift) {
                      Get.back();
                      homeController.sendPostGift(
                          gift, widget.model.user.id, widget.model.id);
                      Get.back();
                    }));
              });
        })

      // const Spacer(),
      // viewGifts(),
    ]);
  }

  Widget sharePost() {
    return Container(
      color: AppColorConstants.cardColor,
      child: Column(
        children: [
          BodyLargeText(
            shareToFeed.tr,
            weight: TextWeight.semiBold,
          ),
          const SizedBox(
            height: 20,
          ),
          ReSharePost(
            post: widget.model,
          ),
          divider(height: 0.5).vP16,
          BodyLargeText(
            sendSeparatelyToFriends.tr,
            weight: TextWeight.semiBold,
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(child: SelectFollowingUserForMessageSending(
              // post: widget.model,
              sendToUserCallback: (user) {
            selectUserForChatController.sendMessage(
                toUser: user, post: widget.model);
          }))
        ],
      ).p(DesignConstants.horizontalPadding),
    ).topRounded(40);
  }

  void addNewMessage() {
    if (commentInputField.text.trim().isNotEmpty) {
      final filter = ProfanityFilter();
      bool hasProfanity = filter.hasProfanity(commentInputField.text);
      if (hasProfanity) {
        AppUtil.showToast(message: notAllowedMessageString.tr, isSuccess: true);
        return;
      }

      _commentsController.postCommentsApiCall(
          comment: commentInputField.text.trim(),
          postId: widget.model.id,
          commentPosted: () {
            setState(() {
              widget.model.totalComment += 1;
            });
          });
      commentInputField.text = '';
    }
  }

  void openComments() {
    Get.to(() => CommentsScreen(
          isPopup: true,
          model: widget.model,
          commentPostedCallback: () {
            setState(() {
              widget.model.totalComment += 1;
            });
          },
        ));
    // showModalBottomSheet(
    //     backgroundColor: Colors.transparent,
    //     context: Get.context!,
    //     isScrollControlled: true,
    //     builder: (context) => FractionallySizedBox(
    //         heightFactor: 0.8,
    //         child: CommentsScreen(
    //           isPopup: true,
    //           model: widget.model,
    //           commentPostedCallback: () {
    //             setState(() {
    //               widget.model.totalComment += 1;
    //             });
    //           },
    //         ).round(40)));
  }
}
