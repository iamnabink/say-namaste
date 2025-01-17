import 'package:get/get.dart';
import '../../api_handler/apis/misc_api.dart';
import '../../model/hash_tag.dart';
import 'package:foap/helper/list_extension.dart';

import '../../model/rating_model.dart';

class MiscController extends GetxController {
  RxList<Hashtag> hashTags = <Hashtag>[].obs;
  RxList<RatingModel> ratings = <RatingModel>[].obs;

  int hashtagsPage = 1;
  bool canLoadMoreHashtags = true;
  RxBool hashtagsIsLoading = false.obs;
  String _searchText = '';

  int ratingsPage = 1;
  bool canLoadMoreRatings = true;
  bool ratingsIsLoading = false;

  clear() {
    hashtagsPage = 1;
    canLoadMoreHashtags = true;
    hashtagsIsLoading.value = false;
    _searchText = '';
    hashTags.clear();
  }


  searchHashTags(String text) {
    clear();
    _searchText = text;
    loadHashTags();
  }

  loadHashTags() {
    if (canLoadMoreHashtags) {
      hashtagsIsLoading.value = true;
      MiscApi.searchHashtag(
          hashtag: _searchText,
          page: hashtagsPage,
          resultCallback: (result, metadata) {
            hashTags.addAll(result);
            hashTags.unique((e) => e.name);

            hashtagsIsLoading.value = false;
            hashtagsPage += 1;
            canLoadMoreHashtags = result.length >= metadata.perPage;
            update();
          });
    }
  }


}
