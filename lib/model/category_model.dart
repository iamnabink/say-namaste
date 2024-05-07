import 'package:foap/screens/add_on/model/podcast_model.dart';
import 'fund_raising_campaign.dart';
import 'gift_model.dart';
import 'live_tv_model.dart';

class CategoryModel {
  int id;
  String name;
  String coverImage;

  CategoryModel({
    required this.name,
    required this.id,
    required this.coverImage,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        name: json["name"],
        id: json["id"],
        coverImage: json["imageUrl"] ?? '',
      );
}

class TvCategoryModel extends CategoryModel {
  // int id;
  // String name;

  // String logo;
  // String coverImage;
  List<TvModel> tvs = [];

  // List<CategoryModel> subCategories = [];

  TvCategoryModel({
    required String name,
    required int id,
    // required this.logo,
    required String coverImage,
    required this.tvs,

    // required this.subCategories,
  }) : super(name: name, id: id, coverImage: coverImage);

  factory TvCategoryModel.fromJson(Map<String, dynamic> json) =>
      TvCategoryModel(
        name: json["name"],
        id: json["id"],
        // logo: json["logoUrl"] ?? 'https://images.unsplash.com/photo-1662286844552-81c31af1416c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=800&q=60',
        coverImage: json["imageUrl"],
        tvs: json["liveTv"] == null
            ? []
            : (json["liveTv"] as List<dynamic>)
                .map((e) => TvModel.fromJson(e))
                .toList(),
      );
}

class GiftCategoryModel extends CategoryModel {
  List<GiftModel> gifts = [];

  GiftCategoryModel({
    required String name,
    required int id,
    required this.gifts,
    required String coverImage,
  }) : super(name: name, id: id, coverImage: coverImage);

  factory GiftCategoryModel.fromJson(Map<String, dynamic> json) =>
      GiftCategoryModel(
        name: json["name"],
        id: json["id"],
        coverImage: json["imageUrl"],
        gifts: json["gift"] == null
            ? []
            : (json["gift"] as List<dynamic>)
                .map((e) => GiftModel.fromJson(e))
                .toList(),
      );
}

class PodcastCategoryModel extends CategoryModel {
  List<PodcastModel> podcasts = [];

  PodcastCategoryModel({
    required String name,
    required int id,
    required this.podcasts,
    required String coverImage,

    // required this.subCategories,
  }) : super(name: name, id: id, coverImage: coverImage);

  factory PodcastCategoryModel.fromJson(Map<String, dynamic> json) =>
      PodcastCategoryModel(
        name: json["name"],
        id: json["id"],
        coverImage: json["imageUrl"],
        podcasts: json["podcastList"] == null
            ? []
            : (json["podcastList"] as List<dynamic>)
                .map((e) => PodcastModel.fromJson(e))
                .toList(),
      );
}

class OffersCategoryModel extends CategoryModel {
  int totalBusinesses;
  int totalOffers;

  OffersCategoryModel({
    required String name,
    required int id,
    required String coverImage,
    required this.totalBusinesses,
    required this.totalOffers,
  }) : super(name: name, id: id, coverImage: coverImage);

  factory OffersCategoryModel.fromJson(Map<String, dynamic> json) =>
      OffersCategoryModel(
        name: json["name"],
        id: json["id"],
        coverImage: json["imageUrl"],
        totalBusinesses: json["total_business"],
        totalOffers: json["total_coupon"],
      );
}

class FundRaisingCampaignCategoryModel extends CategoryModel {
  List<FundRaisingCampaign> campaigns = [];

  FundRaisingCampaignCategoryModel({
    required String name,
    required int id,
    required String coverImage,
    required this.campaigns,
  }) : super(name: name, id: id, coverImage: coverImage);

  factory FundRaisingCampaignCategoryModel.fromJson(
      Map<String, dynamic> json) =>
      FundRaisingCampaignCategoryModel(
        name: json["name"],
        id: json["id"],
        // logo: json["logoUrl"] ?? 'https://images.unsplash.com/photo-1662286844552-81c31af1416c?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzfHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=800&q=60',
        coverImage: json["imageUrl"],
        campaigns: json["campaignList"] == null
            ? []
            : (json["campaignList"] as List<dynamic>)
            .map((e) => FundRaisingCampaign.fromJson(e))
            .toList(),
      );
}
