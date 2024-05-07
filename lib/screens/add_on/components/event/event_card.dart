import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/imports/event_imports.dart';

class EventCard extends StatelessWidget {
  final EventModel event;
  final VoidCallback joinBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback leaveBtnClicked;

  const EventCard(
      {Key? key,
      required this.event,
      required this.joinBtnClicked,
      required this.leaveBtnClicked,
      required this.previewBtnClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.6,
      color: AppColorConstants.cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: event.image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: Get.width * 0.45,
              ).round(25).ripple(() {
                previewBtnClicked();
              }),
              if (event.isFree)
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      color: AppColorConstants.themeColor,
                      child: BodyLargeText(
                        freeString.tr,
                        color: Colors.white,
                      ).p8,
                    ).round(5))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Heading5Text(
            event.name,
            weight: TextWeight.semiBold,
            maxLines: 1,
          ),
          const SizedBox(
            height: 5,
          ),
          BodyMediumText(
            event.startAtDateTime,
            weight: TextWeight.regular,
            color: AppColorConstants.themeColor,
          ),
          const SizedBox(
            height: 8,
          ),
          Row(
            children: [
              ThemeIconWidget(
                ThemeIcon.location,
                color: AppColorConstants.themeColor,
                size: 17,
              ),
              const SizedBox(
                width: 5,
              ),
              Expanded(
                  child: BodyLargeText(
                event.placeName,
                weight: TextWeight.regular,
                maxLines: 1,
              )),
            ],
          ),
        ],
      ).p(12),
    ).round(25);
  }
}

class EventCard2 extends StatelessWidget {
  final EventModel event;
  final VoidCallback joinBtnClicked;
  final VoidCallback previewBtnClicked;
  final VoidCallback leaveBtnClicked;

  const EventCard2(
      {Key? key,
      required this.event,
      required this.joinBtnClicked,
      required this.leaveBtnClicked,
      required this.previewBtnClicked})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      color: AppColorConstants.cardColor,
      child: Row(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageUrl: event.image,
                fit: BoxFit.cover,
                width: 120,
                height: double.infinity,
              ).round(15).ripple(() {
                previewBtnClicked();
              }),
              if (event.isFree)
                Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      color: AppColorConstants.themeColor,
                      child: BodyLargeText(
                        freeString.tr,
                        color: Colors.white,
                        weight: TextWeight.bold,
                      ).p4,
                    ).round(5))
            ],
          ),
          const SizedBox(
            width: 15,
          ),
          Expanded(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Heading5Text(event.name,
                        maxLines: 1, weight: TextWeight.semiBold),
                    const SizedBox(
                      height: 10,
                    ),
                    BodyMediumText(event.startAtDateTime.toUpperCase(),
                        maxLines: 1,
                        weight: TextWeight.regular,
                        color: AppColorConstants.themeColor),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          ThemeIconWidget(
                            ThemeIcon.location,
                            color: AppColorConstants.themeColor,
                            size: 17,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Expanded(
                            child: BodyMediumText(event.placeName,
                                weight: TextWeight.medium),
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(
                    //   height: 20,
                    // ),
                    // Text(
                    //   '${event.totalMembers.formatNumber} ${going}',
                    //   style: TextStyle(fontSize: FontSizes.b2),
                    // ),
                  ],
                ),
                // Positioned(
                //     right: 10,
                //     top: 10,
                //     child: Container(
                //       color: ColorConstants.backgroundColor,
                //       height: 40,
                //       width: 40,
                //       child: ThemeIconWidget(
                //         ThemeIcon.favFilled,
                //         color: event.isFavourite ? Colors.red : Colors.white,
                //       ).p4,
                //     ).circular)
              ],
            ),
          ),
        ],
      ).p(12),
    ).round(25);
  }
}
