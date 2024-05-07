import 'package:foap/helper/date_extension.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/list_extension.dart';
import 'package:foap/model/follow_request.dart';
import '../../api_handler/apis/misc_api.dart';
import '../../model/data_wrapper.dart';
import '../../model/notification_modal.dart';

class NotificationController extends GetxController {
  List<NotificationModel> filteredNotifications = [];
  List<NotificationModel> allNotification = [];
  RxList<FollowRequestModel> followRequests = <FollowRequestModel>[].obs;

  RxList<NotificationType> selectedNotificationsTypes =
      <NotificationType>[].obs;

  RxMap<String, List<NotificationModel>> groupedNotifications =
      <String, List<NotificationModel>>{}.obs;

  DataWrapper followRequestDataWrapper = DataWrapper();

  clearFollowRequests() {
    followRequests.clear();
    followRequestDataWrapper = DataWrapper();
  }

  filterNotifications() {
    if (selectedNotificationsTypes.isNotEmpty) {
      filteredNotifications = allNotification
          .where((element) => selectedNotificationsTypes.contains(element.type))
          .toList();
    } else {
      filteredNotifications = allNotification;
    }
    filteredNotifications = filteredNotifications.map((e) {
      NotificationModel notification = e;
      if (e.date.isToday) {
        notification.notificationDate = todayString.tr;
      } else if (e.date.isThisWeek) {
        notification.notificationDate = thisWeekString.tr;
      } else if (e.date.isThisMonth) {
        notification.notificationDate = thisMonthString.tr;
      } else {
        notification.notificationDate = earlierString.tr;
      }
      return notification;
    }).toList();
    groupedNotifications.value =
        filteredNotifications.groupBy((m) => m.notificationDate);
    update();
  }

  getNotifications() {
    MiscApi.getNotifications(resultCallback: (result, metadata) {
      allNotification = result;
      filterNotifications();
    });
  }

  selectNotificationType(NotificationType type) {
    if (selectedNotificationsTypes.contains(type)) {
      selectedNotificationsTypes.remove(type);
    } else {
      selectedNotificationsTypes.add(type);
    }
  }

  refreshFollowRequests(VoidCallback callback) {
    clearFollowRequests();
    getFollowRequests(callback);
  }

  loadMoreFollowRequests(VoidCallback callback) {
    if (followRequestDataWrapper.haveMoreData.value) {
      followRequestDataWrapper.page += 1;
      getFollowRequests(callback);
    } else {
      callback();
    }
  }

  getFollowRequests(VoidCallback callback) {
    MiscApi.getFollowRequests(
        page: followRequestDataWrapper.page,
        resultCallback: (result, metadata) {
          followRequestDataWrapper.processCompletedWithData(metadata);
          followRequests.addAll(result);
          callback();
          update();
        });
  }

  acceptFollowRequest(int userId) {
    print('followRequests ${followRequests.length}');
    followRequests.removeWhere((element) => element.sender.id == userId);
    print('followRequests ${followRequests.length}');
    update();

    MiscApi.acceptFollowRequest(userId: userId);
  }

  delcineFollowRequest(int userId) {
    print('followRequests ${followRequests.length}');
    followRequests.removeWhere((element) => element.sender.id == userId);
    print('followRequests ${followRequests.length}');

    update();
    MiscApi.declineFollowRequest(userId: userId);
  }
}
