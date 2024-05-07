import 'dart:io';
import 'package:flutter_video_info/flutter_video_info.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:giphy_get/giphy_get.dart';
import '../../helper/imports/common_import.dart';
import '../../util/constant_util.dart';
import '../chat/drawing_screen.dart';
import '../chat/media.dart';
import '../chat/voice_record.dart';
import '../settings_menu/settings_controller.dart';

enum PostContext { none, dailyDrop, challenge, riverRun, chat }

class PostOptionsPopup extends StatelessWidget {
  final SettingsController _settingsController = Get.find();
  final Function(List<Media>)? selectedMediaList;
  final Function(Media)? selectGif;
  final Function(Media)? recordedAudio;
  final ImagePicker _picker = ImagePicker();

  PostOptionsPopup({
    Key? key,
    this.selectedMediaList,
    this.selectGif,
    this.recordedAudio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> options = [];

    options.add(cameraButton());

    if (_settingsController.setting.value!.enableImagePost) {
      options.add(galleryButton());
    }
    if (_settingsController.setting.value!.enableVideoPost) {
      options.add(videoButton());
    }

    options.add(drawButton());
    options.add(audioButton());
    options.add(gifButton());

    return Container(
      height: 120,
      color: AppColorConstants.cardColor,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: options,
        ),
      ),
    ).topRounded(40);
  }

  Widget cameraButton() {
    return ModalComponents(
      check: true,
      icon: ThemeIcon.camera,
      // name: isInTabBar ? null : LocalizationString.cameraModal,
      onPress: () async {
        selectPhoto(
          source: ImageSource.camera,
        );
      },
    );
  }

  Widget galleryButton() {
    return ModalComponents(
      check: true,
      icon: ThemeIcon.gallery,
      // name: isInTabBar ? null : LocalizationString.cameraModal,
      onPress: () async {
        selectPhoto(
          source: ImageSource.gallery,
        );
      },
    );
  }

  Widget videoButton() {
    return ModalComponents(
      check: true,
      icon: ThemeIcon.videoCamera,
      // name: isInTabBar ? null : LocalizationString.cameraModal,
      onPress: () async {
        selectVideo(
          source: ImageSource.gallery,
        );
      },
    );
  }

  Widget drawButton() {
    return ModalComponents(
      check: true,
      icon: ThemeIcon.drawing,
      imageUrl: 'assets/images/dashboard/draw_icon.svg',
      // name: isInTabBar ? null : LocalizationString.draw,
      onPress: () {
        openDrawingBoard();
      },
    );
  }

  Widget audioButton() {
    return ModalComponents(
      check: true,
      icon: ThemeIcon.mic,
      // name: isInTabBar ? null : LocalizationString.audio,
      onPress: () {
        openVoiceRecord();
      },
    );
  }

  Widget gifButton() {
    return ModalComponents(
      check: true,
      icon: ThemeIcon.gif,
      // name: isInTabBar ? null : LocalizationString.gifModal,
      onPress: () {
        // Get.back();
        openGify();
      },
    );
  }

  void openVoiceRecord() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        builder: (context) => FractionallySizedBox(
              heightFactor: 0.7,
              child: VoiceRecord(
                recordingCallback: (media) {
                  if (recordedAudio != null) {
                    recordedAudio!(media);
                  }
                },
              ),
            ));
  }

  void openGify() async {
    String randomId = 'hsvcewd78djhbejkd';

    GiphyGif? gif = await GiphyGet.getGif(
      context: Get.context!,
      //Required
      apiKey: _settingsController.setting.value!.giphyApiKey!,
      //Required.
      lang: GiphyLanguage.english,
      //Optional - Language for query.
      randomID: randomId,
      // Optional - An ID/proxy for a specific user.
      tabColor: Colors.teal, // Optional- default accent color.
    );

    if (gif != null) {
      Media media = Media();
      media.filePath = 'https://i.giphy.com/media/${gif.id}/200.gif';
      media.mediaType = GalleryMediaType.gif;
      if (selectGif != null) {
        selectGif!(media);
      }
    }
  }

  void openDrawingBoard() {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: Get.context!,
        // isDismissible: false,
        isScrollControlled: true,
        // enableDrag: false,
        builder: (context) => FractionallySizedBox(
            heightFactor: 0.9,
            child: DrawingScreen(
              drawingCompleted: (media) {
                if (selectedMediaList != null) {
                  // Navigator.of(context).pop();
                  Loader.show(status: loadingString);
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Loader.dismiss();
                    selectedMediaList!([media]);
                  });
                }
              },
            )));
  }

  selectPhoto({
    required ImageSource source,
  }) async {
    if (source == ImageSource.camera) {
      XFile? image = await _picker.pickImage(source: ImageSource.camera);

      if (image != null) {
        convertToMedias(files: [image], mediaType: GalleryMediaType.photo);
      }
    } else {
      List<XFile> images = await _picker.pickMultiImage();
      // print('images ${images.length}');
      convertToMedias(files: images, mediaType: GalleryMediaType.photo);
    }
  }

  selectVideo({
    required ImageSource source,
  }) async {
    XFile? file = await _picker.pickVideo(source: source);

    if (file != null) {
      convertToMedias(files: [file], mediaType: GalleryMediaType.video);
    }
  }

  convertToMedias(
      {required List<XFile> files, required GalleryMediaType mediaType}) async {
    List<Media> medias = [];
    for (XFile mediaFile in files) {
      Media media = Media();
      media.mediaType = mediaType;
      File file = File(mediaFile.path);
      media.file = file;

      if (mediaType == GalleryMediaType.video) {
        final videoInfo = await FlutterVideoInfo().getVideoInfo(mediaFile.path);

        media.size =
            Size(videoInfo!.width!.toDouble(), videoInfo.height!.toDouble());

        media.thumbnail = await VideoThumbnail.thumbnailData(
          video: mediaFile.path,
          imageFormat: ImageFormat.JPEG,
          maxWidth: 500,
          // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
          quality: 25,
        );
      }

      media.id = randomId();
      medias.add(media);
    }

    selectedMediaList!(medias);
  }
}

class ModalComponents extends StatelessWidget {
  final bool check;
  final String? imageUrl;
  final ThemeIcon icon;
  final String? name;
  final VoidCallback? onPress;

  const ModalComponents(
      {Key? key,
      required this.check,
      this.imageUrl,
      required this.icon,
      this.name,
      this.onPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ThemeIconWidget(icon).ripple(() {
          onPress!();
        }),
        if (name != null)
          Text(
            name!,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w400,
                letterSpacing: 0.5,
                color: AppColorConstants.iconColor),
          ),
      ],
    );
  }
}
