import 'package:foap/helper/imports/common_import.dart';

int postTypeValueFrom(PostType postType) {
  switch (postType) {
    case PostType.basic:
      return 1;
    case PostType.competition:
      return 2;
    case PostType.club:
      return 3;
    case PostType.reel:
      return 4;
    case PostType.reshare:
      return 5;
  }
}

int postContentTypeValueFrom(PostContentType contentType) {
  switch (contentType) {
    case PostContentType.text:
      return 1;
    case PostContentType.media:
      return 2;
    case PostContentType.location:
      return 3;
  }
}

int mediaTypeIdFromMediaType(GalleryMediaType type) {
  switch (type) {
    case GalleryMediaType.photo:
      return 1;
    case GalleryMediaType.video:
      return 2;
    case GalleryMediaType.audio:
      return 3;
    case GalleryMediaType.gif:
      return 4;
    default:
      return 1;
  }
}

int itemViewSourceToId(ItemViewSource source) {
  switch (source) {
    case ItemViewSource.normal:
      return 1;
    case ItemViewSource.promotion:
      return 2;
  }
}

int userViewSourceTypeToId(UserViewSourceType source) {
  switch (source) {
    case UserViewSourceType.post:
      return 1;
    case UserViewSourceType.reel:
      return 2;
    case UserViewSourceType.story:
      return 2;
  }
}

PaymentType paymentTypeFromId(int id) {
  switch (id) {
    case 1:
      return PaymentType.package;
    case 2:
      return PaymentType.award;
    case 3:
      return PaymentType.withdrawal;
    case 4:
      return PaymentType.withdrawalRefund;
    case 5:
      return PaymentType.liveTvSubscribe;
    case 6:
      return PaymentType.gift;
    case 7:
      return PaymentType.redeemCoin;
    case 8:
      return PaymentType.eventTicket;
    case 9:
      return PaymentType.eventTicketRefund;
    case 10:
      return PaymentType.datingSubscription;
    case 11:
      return PaymentType.promotion;
    case 12:
      return PaymentType.promotionRefund;
    case 15:
      return PaymentType.fundRaising;
    case 16:
      return PaymentType.featureAd;
    case 17:
      return PaymentType.bannerAd;
  }
  return PaymentType.package;
}

String paymentTypeStringFromId(PaymentType type) {
  switch (type) {
    case PaymentType.package:
      return boughtCoinsString.tr;
    case PaymentType.award:
      return awardedString.tr;
    case PaymentType.withdrawal:
      return withdrawalString.tr;
    case PaymentType.withdrawalRefund:
      return withdrawalRefundString.tr;
    case PaymentType.liveTvSubscribe:
      return subscribedTvString.tr;
    case PaymentType.gift:
      return giftsReceivedString.tr;
    case PaymentType.redeemCoin:
      return redeemString.tr;
    case PaymentType.eventTicket:
      return evenTicketString.tr;
    case PaymentType.eventTicketRefund:
      return evenTicketRefundString.tr;
    case PaymentType.datingSubscription:
      return datingSubscriptionString.tr;
    case PaymentType.promotion:
      return postPromotionString.tr;
    case PaymentType.promotionRefund:
      return postPromotionRefundString.tr;
    case PaymentType.fundRaising:
      return donationString.tr;
    case PaymentType.featureAd:
      return promotedAdString.tr;
    case PaymentType.bannerAd:
      return promotedAdString.tr;
  }
}

PaymentMode paymentModeFromId(int id) {
  switch (id) {
    case 1:
      return PaymentMode.inAppPurchase;
    case 2:
      return PaymentMode.paypal;
    case 3:
      return PaymentMode.wallet;
    case 4:
      return PaymentMode.stripe;
    case 5:
      return PaymentMode.razorpay;
    case 9:
      return PaymentMode.flutterWave;
  }
  return PaymentMode.inAppPurchase;
}

TransactionType transactionTypeFromId(int id) {
  if (id == 1) {
    return TransactionType.credit;
  }
  return TransactionType.debit;
}

int messageTypeId(MessageContentType type) {
  switch (type) {
    case MessageContentType.text:
      return 1;
    case MessageContentType.photo:
      return 2;
    case MessageContentType.video:
      return 3;
    case MessageContentType.audio:
      return 4;
    case MessageContentType.gif:
      return 5;
    case MessageContentType.sticker:
      return 6;
    case MessageContentType.contact:
      return 7;
    case MessageContentType.location:
      return 8;
    case MessageContentType.reply:
      return 9;
    case MessageContentType.forward:
      return 10;
    case MessageContentType.post:
      return 11;
    case MessageContentType.story:
      return 12;
    case MessageContentType.drawing:
      return 13;
    case MessageContentType.profile:
      return 14;
    case MessageContentType.group:
      return 15;
    case MessageContentType.file:
      return 16;
    case MessageContentType.textReplyOnStory:
      return 17;
    case MessageContentType.reactedOnStory:
      return 18;
    case MessageContentType.groupAction:
      return 100;
    case MessageContentType.gift:
      return 200;
  }
}

int uploadMediaTypeId(UploadMediaType type) {
  switch (type) {
    case UploadMediaType.shop:
      return 1;
    case UploadMediaType.storyOrHighlights:
      return 3;
    case UploadMediaType.chat:
      return 5;
    case UploadMediaType.club:
      return 5;
    case UploadMediaType.verification:
      return 12;
    case UploadMediaType.uploadResume:
      return 28;
  }
}
