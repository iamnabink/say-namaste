import 'package:foap/helper/imports/common_import.dart';
import 'package:foap/helper/list_extension.dart';
import 'package:foap/model/data_wrapper.dart';
import '../../api_handler/apis/post_api.dart';
import '../../model/post_model.dart';
import '../../model/post_search_query.dart';

class PostController extends GetxController {
  RxList<PostModel> posts = <PostModel>[].obs;
  RxList<PostModel> videos = <PostModel>[].obs;

  RxList<PostModel> mentions = <PostModel>[].obs;
  RxList<UserModel> likedByUsers = <UserModel>[].obs;

  Rx<PostInsight?> insight = Rx<PostInsight?>(null);

  int totalPages = 100;

  DataWrapper postDataWrapper = DataWrapper();
  DataWrapper mentionsDataWrapper = DataWrapper();
  DataWrapper videosDataWrapper = DataWrapper();

  PostSearchQuery? postSearchQuery;
  MentionedPostSearchQuery? mentionedPostSearchQuery;

  DataWrapper postLikedByDataWrapper = DataWrapper();

  clear() {
    totalPages = 100;
    postDataWrapper = DataWrapper();

    posts.value = [];

    clearVideos();
    clearMentions();
    clearPostLikedByUsers();
    update();
  }

  clearMentions() {
    mentions.value = [];
    mentionsDataWrapper = DataWrapper();
  }

  clearVideos() {
    videos.clear();
    videosDataWrapper = DataWrapper();
  }

  clearPostLikedByUsers() {
    likedByUsers.clear();
    postLikedByDataWrapper = DataWrapper();
  }

  addPosts(List<PostModel> postsList, int? startPage, int? totalPages) {
    mentionsDataWrapper.page = startPage ?? 1;
    postDataWrapper.page = startPage ?? 1;
    this.totalPages = totalPages ?? 100;

    posts.addAll(postsList);
    posts.unique((e) => e.id);
    update();
  }

  setPostSearchQuery(
      {required PostSearchQuery query, required VoidCallback callback}) {
    if (query != postSearchQuery) {
      clear();
    }
    update();
    postSearchQuery = query;
    getPosts(callback);
  }

  setMentionedPostSearchQuery(MentionedPostSearchQuery query) {
    mentionedPostSearchQuery = query;
    getMyMentions();
  }

  removePostFromList(PostModel post) {
    posts.removeWhere((element) => element.id == post.id);
    mentions.removeWhere((element) => element.id == post.id);

    posts.refresh();
    mentions.refresh();
  }

  removeUsersAllPostFromList(PostModel post) {
    posts.removeWhere((element) => element.user.id == post.user.id);
    mentions.removeWhere((element) => element.user.id == post.user.id);

    posts.refresh();
    mentions.refresh();
  }

  void getPosts(VoidCallback callback) async {
    if (postDataWrapper.haveMoreData.value == true &&
        totalPages > postDataWrapper.page) {
      if (postDataWrapper.page == 1) {
        postDataWrapper.isLoading.value = true;
      }

      PostApi.getPosts(
          userId: postSearchQuery!.userId,
          isPopular: postSearchQuery!.isPopular,
          isFollowing: postSearchQuery!.isFollowing,
          isSold: postSearchQuery!.isSold,
          isMine: postSearchQuery!.isMine,
          isRecent: postSearchQuery!.isRecent,
          title: postSearchQuery!.title,
          hashtag: postSearchQuery!.hashTag,
          page: postDataWrapper.page,
          resultCallback: (result, metadata) {
            posts.addAll(result);
            posts.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            posts.unique((e) => e.id);

            postDataWrapper.processCompletedWithData(metadata);

            callback();
            update();
          });
    } else {
      callback();
    }
  }

  void getVideos(VoidCallback callback) async {
    if (videosDataWrapper.haveMoreData.value == true &&
        totalPages > videosDataWrapper.page) {
      videosDataWrapper.isLoading.value = true;

      PostApi.getPosts(
          userId: postSearchQuery!.userId,
          isPopular: postSearchQuery!.isPopular,
          isFollowing: postSearchQuery!.isFollowing,
          isSold: postSearchQuery!.isSold,
          isMine: postSearchQuery!.isMine,
          isRecent: postSearchQuery!.isRecent,
          title: postSearchQuery!.title,
          hashtag: postSearchQuery!.hashTag,
          page: videosDataWrapper.page,
          resultCallback: (result, metadata) {
            posts.addAll(result);
            posts.sort((a, b) => b.createDate!.compareTo(a.createDate!));
            posts.unique((e) => e.id);

            videosDataWrapper.processCompletedWithData(metadata);

            callback();

            update();
          });
    } else {
      callback();
    }
  }

  void getMyMentions() {
    if (mentionsDataWrapper.haveMoreData.value) {
      PostApi.getMentionedPosts(
          page: mentionsDataWrapper.page,
          userId: mentionedPostSearchQuery!.userId,
          resultCallback: (result, metadata) {
            mentions.addAll(result);
            mentions.unique((e) => e.id);
            mentionsDataWrapper.processCompletedWithData(metadata);
            update();
          });
    }
  }

  void reportPost(int postId) {
    PostApi.reportPost(
        postId: postId,
        resultCallback: () {
          AppUtil.showToast(
              message: postReportedSuccessfullyString.tr, isSuccess: true);
        });
  }

  viewInsight(int postId) {
    PostApi.getPostInsight(postId, resultCallback: (result) {
      insight.value = result;
      insight.refresh();
    });
  }

  void getPostLikedByUsers(
      {required int postId, required VoidCallback callback}) async {
    if (postLikedByDataWrapper.haveMoreData.value == true) {
      postLikedByDataWrapper.isLoading.value = true;

      PostApi.postLikedByUsers(
          postId: postId,
          page: postLikedByDataWrapper.page,
          resultCallback: (result, metadata) {
            likedByUsers.addAll(result);
            likedByUsers.unique((e) => e.id);

            postLikedByDataWrapper.processCompletedWithData(metadata);

            callback();

            update();
          });
    }
  }
}
