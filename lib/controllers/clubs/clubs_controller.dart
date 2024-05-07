import 'package:foap/api_handler/apis/club_api.dart';
import 'package:foap/helper/imports/club_imports.dart';
import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/model/data_wrapper.dart';
import '../../model/category_model.dart';
import 'package:foap/helper/list_extension.dart';

class ClubsController extends GetxController {
  RxList<ClubModel> clubs = <ClubModel>[].obs;
  RxList<ClubModel> topClubs = <ClubModel>[].obs;
  RxList<ClubModel> trendingClubs = <ClubModel>[].obs;

  RxList<CategoryModel> categories = <CategoryModel>[].obs;
  RxList<ClubMemberModel> members = <ClubMemberModel>[].obs;
  RxList<ClubInvitation> invitations = <ClubInvitation>[].obs;

  RxBool isLoadingCategories = false.obs;

  DataWrapper clubsDataWrapper = DataWrapper();
  DataWrapper topClubsDataWrapper = DataWrapper();
  DataWrapper invitationsDataWrapper = DataWrapper();

  int trendingClubsPage = 1;
  bool canLoadMoreTrendingClubs = true;
  RxBool isLoadingTrendingClubs = false.obs;

  int membersPage = 1;
  bool canLoadMoreMembers = true;
  bool isLoadingMembers = false;

  RxInt segmentIndex = (0).obs;
  RxInt currentSliderIndex = (0).obs;

  String? _name;
  int? _categoryId;
  int? _userId;
  int? _isJoined;

  clear() {
    clubsDataWrapper = DataWrapper();
    clubs.clear();

    invitationsDataWrapper = DataWrapper();
    invitations.clear();

    // topClubsPage = 1;
    // canLoadMoreTopClubs = true;
    // isLoadingTopClubs.value = false;
    // topClubs.clear();

    trendingClubsPage = 1;
    canLoadMoreTrendingClubs = true;
    isLoadingTrendingClubs.value = false;
    trendingClubs.clear();

    segmentIndex.value = 0;
    currentSliderIndex.value = 0;

    _name = null;
    _categoryId = null;
    _userId = null;
    _isJoined = null;
  }

  clearMembers() {
    isLoadingMembers = false;
    members.value = [];
    membersPage = 1;
    canLoadMoreMembers = true;
  }

  updateSlider(int index) {
    currentSliderIndex.value = index;
  }

  refreshClubs() {
    clear();
    getClubs();
  }

  setSearchText(String? name) {
    clear();
    _name = name;
    getClubs();
  }

  setCategoryId(int? categoryId) {
    clear();

    _categoryId = categoryId;
    getClubs();
  }

  setIsJoined(int? isJoined) {
    clear();
    _isJoined = isJoined;
    getClubs();
  }

  setUserId(int? userId) {
    clear();
    _userId = userId;
    getClubs();
  }

  selectedSegmentIndex({required int index}) {
    if (clubsDataWrapper.isLoading.value == true) {
      return;
    }
    update();
    if (index == 0 && (segmentIndex.value != index)) {
      clear();
      getClubs();
    } else if (index == 1 && (segmentIndex.value != index)) {
      clear();
      setIsJoined(1);
    } else if (index == 2 && (segmentIndex.value != index)) {
      final UserProfileManager userProfileManager = Get.find();

      clear();
      setUserId(userProfileManager.user.value!.id);
    } else if (index == 3 && (segmentIndex.value != index)) {
      getClubInvitations();
    }

    segmentIndex.value = index;
  }

  getClubs() {
    if (clubsDataWrapper.haveMoreData.value) {
      ClubApi.getClubs(
          name: _name,
          categoryId: _categoryId,
          userId: _userId,
          isJoined: _isJoined,
          page: clubsDataWrapper.page,
          resultCallback: (result, metadata) {
            clubs.addAll(result);
            clubs.unique((e) => e.id);
            clubsDataWrapper.processCompletedWithData(metadata);

            update();
          });
    }
  }

  getTopClubs() {
    if (topClubsDataWrapper.haveMoreData.value) {
      ClubApi.getTopClubs(
          page: topClubsDataWrapper.page,
          resultCallback: (result) {
            topClubs.addAll(result);
            topClubs.unique((e) => e.id);
            // topClubsDataWrapper.processCompletedWithData(metaData);

            update();
          });
    }
  }

  getTrendingClubs() {
    if (canLoadMoreTrendingClubs) {
      ClubApi.getTrendingClubs(
          page: trendingClubsPage,
          resultCallback: (result, metadata) {
            trendingClubs.addAll(result);
            trendingClubs.unique((e) => e.id);
            isLoadingTrendingClubs.value = false;

            canLoadMoreTrendingClubs = result.length >= metadata.perPage;

            trendingClubsPage += 1;

            update();
          });
    }
  }

  getClubInvitations() {
    if (invitationsDataWrapper.haveMoreData.value) {
      invitationsDataWrapper.isLoading.value = true;
      ClubApi.getClubInvitations(
          page: invitationsDataWrapper.page,
          resultCallback: (result, metadata) {
            invitations.addAll(result);
            invitations.unique((e) => e.id);

            invitationsDataWrapper.processCompletedWithData(metadata);

            update();
          });
    }
  }

  clubDeleted(ClubModel club) {
    clubs.removeWhere((element) => element.id == club.id);
    clubs.refresh();
  }

  getMembers({int? clubId}) {
    if (canLoadMoreMembers) {
      isLoadingMembers = true;
      ClubApi.getClubMembers(
          clubId: clubId,
          page: membersPage,
          resultCallback: (result, metadata) {
            members.addAll(result);
            members.unique((e) => e.id);

            isLoadingMembers = false;

            membersPage += 1;
            canLoadMoreMembers = result.length >= metadata.perPage;

            update();
          });
    }
  }

  getCategories() {
    isLoadingCategories.value = true;
    ClubApi.getClubCategories(resultCallback: (result) {
      categories.value = result;
      isLoadingCategories.value = false;

      update();
    });
  }

  joinClub(ClubModel club) {
    if (club.isRequestBased == true) {
      clubs.value = clubs.map((element) {
        if (element.id == club.id) {
          element.isRequested = true;
        }
        return element;
      }).toList();

      clubs.refresh();

      ClubApi.sendClubJoinRequest(clubId: club.id!);
    } else {
      clubs.value = clubs.map((element) {
        if (element.id == club.id) {
          element.isJoined = true;
        }
        return element;
      }).toList();

      clubs.refresh();

      ClubApi.joinClub(clubId: club.id!, resultCallback: () {});
    }
  }

  leaveClub(ClubModel club) {
    clubs.value = clubs.map((element) {
      if (element.id == club.id) {
        element.isJoined = false;
      }
      return element;
    }).toList();

    clubs.refresh();
    ClubApi.leaveClub(clubId: club.id!);
  }

  acceptClubInvitation(ClubInvitation invitation) {
    invitations.remove(invitation);
    invitations.refresh();
    ClubApi.acceptDeclineClubInvitation(
        invitationId: invitation.id!, replyStatus: 10);
  }

  declineClubInvitation(ClubInvitation invitation) {
    invitations.remove(invitation);
    invitations.refresh();
    ClubApi.acceptDeclineClubInvitation(
        invitationId: invitation.id!, replyStatus: 3);
  }

  removeMemberFromClub(ClubModel club, ClubMemberModel member) {
    members.remove(member);
    update();

    ClubApi.removeMemberFromClub(clubId: club.id!, userId: member.id);
  }

  deleteClub({required ClubModel club, required VoidCallback callback}) {
    ClubApi.deleteClub(
      club.id!,
    );
    Get.back();
    callback();
  }
}
