import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:foap/screens/near_by_offers/offers_list.dart';

import '../../components/paging_scrollview.dart';
import '../../components/sm_tab_bar.dart';
import '../../controllers/coupons/near_by_offers.dart';
import '../../helper/imports/common_import.dart';
import '../../model/business_model.dart';
import 'about_businesss.dart';

class BusinessDetail extends StatelessWidget {
  final BusinessModel business;
  final NearByOffersController _nearbyOfferController = Get.find();

  BusinessDetail({Key? key, required this.business}) : super(key: key);

  final List<String> tabs = [
    aboutString.tr,
    offers.tr,
    // commentsString.tr,
  ];

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                height: Get.height * 0.4,
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
                          _nearbyOfferController.updateGallerySlider(index);
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
                                  position:
                                      _nearbyOfferController.currentIndex.value,
                                  decorator: DotsDecorator(
                                      activeColor:
                                          Theme.of(Get.context!).primaryColor),
                                );
                              },
                            ),
                          )),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: SizedBox(
                  height: Get.height - (Get.height * 0.4),
                  child: DefaultTabController(
                      length: tabs.length,
                      initialIndex: 0,
                      child: Column(
                        children: [
                          SMTabBar(tabs: tabs,canScroll: false),
                          const SizedBox(
                            height: 20,
                          ),
                          Expanded(
                            child: TabBarView(children: [
                              AboutBusiness(
                                business: business,
                              ).hp(DesignConstants.horizontalPadding),
                              PagingScrollView(
                                child: OffersList(source: OfferSource.normal,),
                                loadMoreCallback: (controller) {
                                  _nearbyOfferController.getOffers(() {
                                    controller.loadComplete();
                                  });
                                },
                              ),
                              // OffersList(),
                            ]),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
          backNavigationBarWithTrailingWidget(
              title: '',
              widget: Obx(() => Container(
                    height: 40,
                    width: 40,
                    color: AppColorConstants.themeColor.withOpacity(0.2),
                    child: ThemeIconWidget(
                        _nearbyOfferController
                                .currentBusiness.value!.isFavourite
                            ? ThemeIcon.favFilled
                            : ThemeIcon.fav,
                        color: _nearbyOfferController
                                .currentBusiness.value!.isFavourite
                            ? AppColorConstants.red
                            : AppColorConstants.iconColor),
                  ).round(10).ripple(() {
                    _nearbyOfferController.favUnFavBusiness(
                        _nearbyOfferController.currentBusiness.value!);
                  }))),
        ],
      ),
    );
  }

  List<Widget> mediaList() {
    List<CachedNetworkImage> images = [];
    images.add(CachedNetworkImage(
      imageUrl: business.coverImage,
      width: double.infinity,
      height: double.infinity,
      fit: BoxFit.cover,
    ));

    for (String image in business.allImages) {
      images.add(CachedNetworkImage(imageUrl: image));
    }

    return images;
  }
}
