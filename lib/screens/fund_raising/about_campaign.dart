import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:foap/helper/date_extension.dart';
import 'package:foap/helper/number_extension.dart';
import '../../controllers/fund_raising/fund_raising_controller.dart';
import '../../helper/imports/common_import.dart';
import '../../model/fund_raising_campaign.dart';
import 'enter_donation_amount.dart';

class AboutCampaign extends StatelessWidget {
  final FundRaisingCampaign campaign;
  final FundRaisingController fundRaisingController = Get.find();

  AboutCampaign({Key? key, required this.campaign}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 30),
          SizedBox(
            height: Get.height * 0.3,
            child: Stack(
              children: [
                CarouselSlider(
                  items: mediaList(),
                  options: CarouselOptions(
                    aspectRatio: 1,
                    enlargeCenterPage: false,
                    enableInfiniteScroll: false,
                    height: double.infinity,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      fundRaisingController.updateGallerySlider(index);
                    },
                  ),
                ),

                if (mediaList().length > 1)
                  Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Align(
                        alignment: Alignment.center,
                        child: Obx(
                              () {
                            return DotsIndicator(
                              dotsCount: mediaList().length,
                              position: fundRaisingController
                                  .currentIndex.value,
                              decorator: DotsDecorator(
                                  activeColor: Theme.of(Get.context!)
                                      .primaryColor),
                            );
                          },
                        ),
                      )),
              ],
            ),
          ).round(25),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Heading4Text(
                  campaign.title,
                  weight: TextWeight.bold,
                ),
              ),
              SizedBox(
                height: 30,
                child:
                    Center(child: BodySmallText(campaign.category!.name)).hP8,
              ).borderWithRadius(
                  value: 1, radius: 10, color: AppColorConstants.themeColor)
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Wrap(
            children: [
              BodyLargeText(
                '\$${campaign.raisedValue.toString()} ',
                weight: TextWeight.semiBold,
                color: AppColorConstants.themeColor,
              ),
              BodyLargeText(
                '\$$fundRaisedFrom ${campaign.targetValue.toString()}',
                weight: TextWeight.regular,
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Stack(
            children: [
              Container(
                height: 5,
                width: Get.width - (2 * DesignConstants.horizontalPadding),
                color: AppColorConstants.disabledColor,
              ).circular,
              Container(
                height: 5,
                width: ((campaign.raisedValue) / campaign.targetValue) *
                    (Get.width - (2 * DesignConstants.horizontalPadding)),
                color: AppColorConstants.themeColor,
              ).circular
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  BodyMediumText(
                    campaign.totalDonors.formatNumber,
                    weight: TextWeight.bold,
                    color: AppColorConstants.themeColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  BodyMediumText(
                    donationsString,
                    weight: TextWeight.semiBold,
                    color: AppColorConstants.subHeadingTextColor,
                  ),
                ],
              ),
              Row(
                children: [
                  BodyMediumText(
                    closingOnString,
                    weight: TextWeight.semiBold,
                    color: AppColorConstants.subHeadingTextColor,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  BodyMediumText(
                    campaign.endDate.formatTo('yyyy-MMM-dd'),
                    weight: TextWeight.bold,
                    color: AppColorConstants.subHeadingTextColor,
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 40,
          ),
          AppThemeButton(
              text: donateNowString,
              onPress: () {
                Get.to(() => EnterDonationAmount());
              }),
          divider(height: 0.5).vP16,
          createdBy(),
          divider(height: 0.5).vP16,
          createdFor(),
          divider(height: 0.5).vP16,
          Heading6Text(
            aboutString,
            weight: TextWeight.semiBold,
            color: AppColorConstants.themeColor,
          ),
          const SizedBox(
            height: 20,
          ),
          BodyMediumText(campaign.description),
          const SizedBox(
            height: 100,
          ),
        ],
      ),
    );
  }

  List<Widget> mediaList() {
    List<CachedNetworkImage> images = [];
    images.add(CachedNetworkImage(
      imageUrl: campaign.coverImage,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    ));

    for (String image in campaign.allImages) {
      images.add(CachedNetworkImage(
        imageUrl: image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      ));
    }

    return images;
  }

  Widget createdBy() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Heading6Text(
          fundRaiserString,
          weight: TextWeight.semiBold,
          color: AppColorConstants.themeColor,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            AvatarView(
              url: campaign.createdBy!.coverImage,
              name: campaign.createdBy!.name,
              size: 50,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                children: [
                  BodyLargeText(
                    campaign.createdBy!.name!,
                    weight: TextWeight.semiBold,
                  ),
                ],
              ),
            ),
            const Spacer()
          ],
        )
      ],
    );
  }

  Widget createdFor() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Heading6Text(
          fundRaisingForString,
          weight: TextWeight.semiBold,
          color: AppColorConstants.themeColor,
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            AvatarView(
              url: campaign.createdFor!.picture,
              name: campaign.createdFor!.name,
              size: 50,
            ),
            const SizedBox(width: 10,),
            Expanded(
              child: Column(
                children: [
                  BodyLargeText(
                    campaign.createdFor!.name!,
                    weight: TextWeight.semiBold,
                  ),
                ],
              ),
            ),
            const Spacer()
          ],
        )
      ],
    );
  }
}
