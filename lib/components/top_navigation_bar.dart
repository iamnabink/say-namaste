import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/screens/add_on/ui/add_relationship/accept_reject_invitation.dart';

Widget backNavigationBar({required String title}) {
  return Container(
    height: 100,
    color: AppColorConstants.cardColor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          height: 40,
          width: 40,
          child: Center(
            child: Icon(
              Icons.arrow_back_ios,
              size: 20,
              color: AppColorConstants.iconColor,
            ),
          ),
        ).lP8.ripple(() {
          Get.back();
        }),
        Expanded(
            child: BodyLargeText(title.tr,
                maxLines: 1, weight: TextWeight.medium)),
        const SizedBox(
          width: 40,
        )
      ],
    ).setPadding(
        left: DesignConstants.horizontalPadding,
        right: DesignConstants.horizontalPadding,
        top: 40),
  );
}

Widget backNavigationBarWithTrailingWidget(
    {required String title, required Widget widget}) {
  return Container(
    height: 100,
    color: AppColorConstants.cardColor,
    width: double.infinity,
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: 50,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: ThemeIconWidget(
                    ThemeIcon.backArrow,
                    size: 18,
                    color: AppColorConstants.iconColor,
                  ),
                )).ripple(() {
              Get.back();
            }),
            widget,
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          top: 0,
          child: Center(
            child: BodyLargeText(
              title,
            ),
          ),
        )
      ],
    ).setPadding(
        left: DesignConstants.horizontalPadding,
        right: DesignConstants.horizontalPadding,
        top: 40),
  );
}

Widget backNavigationBarWithIconBadge(
    {required ThemeIcon icon,
    required String title,
    required int badgeCount,
    required VoidCallback iconBtnClicked}) {
  return Stack(
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ThemeIconWidget(
            ThemeIcon.backArrow,
            size: 18,
            color: AppColorConstants.iconColor,
          ).ripple(() {
            Get.back();
          }),
          Expanded(
              child: Align(
            alignment: Alignment.centerRight,
            child: ThemeIconWidget(
              ThemeIcon.setting,
              size: 25,
              color: AppColorConstants.iconColor,
            ).rP8.ripple(() {
              iconBtnClicked();
            }),
          )),
          Stack(children: [
            ThemeIconWidget(
              icon,
              size: 30,
              color: AppColorConstants.iconColor,
            ).ripple(() {
              Get.to(() => const AcceptRejectInvitation());
            }),
            if (badgeCount > 0)
              Positioned.fill(
                  child: Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        height: 18,
                        width: 18,
                        decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        child: Center(child: Text(badgeCount.toString())),
                      )))
          ]).ripple(() {
            Get.to(() => const AcceptRejectInvitation());
            //
          }),
        ],
      ),
      Positioned(
        left: 0,
        right: 0,
        child: Center(
          child: BodyLargeText(title.tr, weight: TextWeight.medium),
        ),
      ),
    ],
  ).setPadding(
      left: DesignConstants.horizontalPadding,
      right: DesignConstants.horizontalPadding,
      top: 8,
      bottom: 16);
}

Widget profileScreensNavigationBar(
    {required String title,
    String? rightBtnTitle,
    required VoidCallback completion}) {
  return Stack(
    alignment: AlignmentDirectional.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ThemeIconWidget(
            ThemeIcon.backArrow,
            size: 18,
            color: AppColorConstants.iconColor,
          ).ripple(() {
            Get.back();
          }),
          if (rightBtnTitle != null)
            BodyLargeText(rightBtnTitle.tr, weight: TextWeight.medium)
                .ripple(() {
              completion();
            }),
        ],
      ).setPadding(
          left: DesignConstants.horizontalPadding,
          right: DesignConstants.horizontalPadding),
      Positioned(
        left: 0,
        right: 0,
        child: Center(
          child: BodyLargeText(title.tr, weight: TextWeight.medium),
        ),
      )
    ],
  ).bP16;
}

Widget titleNavigationBarWithIcon(
    {required String title,
    required ThemeIcon icon,
    Color? iconColor,
    required VoidCallback completion}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const SizedBox(
        width: 25,
      ),
      BodyLargeText(title.tr, weight: TextWeight.medium),
      ThemeIconWidget(
        icon,
        color: iconColor ?? AppColorConstants.iconColor,
        size: 25,
      ).ripple(() {
        completion();
      }),
    ],
  ).setPadding(
      left: DesignConstants.horizontalPadding,
      right: DesignConstants.horizontalPadding,
      top: 8,
      bottom: 16);
}

Widget titleNavigationBarWithWidget(
    {required String title,
      required Widget widget,
      required VoidCallback completion}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const SizedBox(
        width: 25,
      ),
      BodyLargeText(title.tr, weight: TextWeight.medium),
      widget,
    ],
  ).setPadding(
      left: DesignConstants.horizontalPadding,
      right: DesignConstants.horizontalPadding,
      top: 8,
      bottom: 16);
}

Widget titleNavigationBar({required String title}) {
  return Container(
    height: 100,
    width: Get.width,
    color: AppColorConstants.cardColor,
    child: Center(
      child: BodyLargeText(title.tr, weight: TextWeight.medium)
          .setPadding(top: 40),
    ),
  );
}

Widget customNavigationBar(
    {required String title, VoidCallback? action, Widget? trailing}) {
  return Container(
    height: 100,
    color: AppColorConstants.cardColor,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ThemeIconWidget(
          ThemeIcon.backArrow,
          size: 18,
          color: AppColorConstants.iconColor,
        ).ripple(() {
          if (action != null) {
            action();
          } else {
            Get.back();
          }
        }),
        Heading4Text(title, weight: TextWeight.bold),
        trailing ?? const SizedBox(width: 20),
      ],
    ).setPadding(
        left: DesignConstants.horizontalPadding,
        right: DesignConstants.horizontalPadding,
        top: 8,
        bottom: 16),
  );
}
