import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter_audio_waveforms/flutter_audio_waveforms.dart';

import '../helper/imports/common_import.dart';
import '../manager/player_manager.dart';

class AudioProgressBar extends StatelessWidget {
  final String id;
  final PlayerManager _playerManager = Get.find();

  AudioProgressBar({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // return RectangleWaveform(
      //   maxDuration:
      //       _playerManager.progress.value?.total ?? const Duration(seconds: 0),
      //   elapsedDuration: _playerManager.currentlyPlayingAudio.value?.id == id
      //       ? _playerManager.progress.value?.current ??
      //           const Duration(seconds: 0)
      //       : const Duration(seconds: 0),
      //   samples: [0, 5, 10, 20, 5, 4, 8, 20, 4, 2, 6, 7, 8, 1, 10, -10],
      //   height: 20,
      //   width: Get.width - (2 * DesignConstants.horizontalPadding),
      // );
      return ProgressBar(
        thumbColor: AppColorConstants.themeColor.darken(),
        progressBarColor: AppColorConstants.iconColor,
        baseBarColor: AppColorConstants.backgroundColor.lighten(),
        thumbRadius: 8,
        barHeight: 2,
        progress: _playerManager.currentlyPlayingAudio.value?.id == id
            ? _playerManager.progress.value?.current ??
                const Duration(seconds: 0)
            : const Duration(seconds: 0),
        // buffered: value.buffered,
        total:
            _playerManager.progress.value?.total ?? const Duration(seconds: 0),
        timeLabelPadding: 5,
        timeLabelTextStyle: TextStyle(
            fontSize: FontSizes.b4,
            fontWeight: TextWeight.bold,
            color: AppColorConstants.mainTextColor),
        onDragUpdate: (detail) {
          _playerManager.pauseAudio();
          _playerManager
              .updateProgress(Duration(seconds: detail.timeStamp.inSeconds));
        },
        onDragEnd: () {
          // _playerManager.playAudio(audio);
        },
        // onSeek: pageManager.seek,
      );
    });
  }
}
