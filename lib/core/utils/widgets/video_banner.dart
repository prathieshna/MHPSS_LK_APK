import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../resources/all_imports.dart';

class VideoBanner extends StatefulWidget {
  final String videoUrl;

  const VideoBanner({super.key, required this.videoUrl});

  @override
  State<VideoBanner> createState() => _VideoBannerState();
}

class _VideoBannerState extends State<VideoBanner> {
  late YoutubePlayerController _youtubeController;
  late YoutubePlayerController _popupYoutubeController;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    try {
      final videoId = YoutubePlayer.convertUrlToId(widget.videoUrl);
      if (videoId == null) {
        throw Exception("Invalid YouTube URL");
      }

      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: true,
        ),
      );

      _popupYoutubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          mute: false,
        ),
      );
    } catch (e) {
      debugPrint('Error initializing YouTube player: $e');
      _hasError = true;
    }
  }

  @override
  void dispose() {
    // Restore orientation preferences when widget is disposed
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _youtubeController.dispose();
    _popupYoutubeController.dispose();
    super.dispose();
  }

  void _showVideoPopup(BuildContext context) {
    // Lock orientation to portrait when showing the dialog
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    showDialog(
      context: context,
      barrierColor: Colors.black,
      builder: (context) {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) {
            if (didPop) {
              // Pause video when dialog is closed
              _popupYoutubeController.pause();
              // Restore orientation preferences
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
                DeviceOrientation.landscapeLeft,
                DeviceOrientation.landscapeRight,
              ]);
            }
          },
          child: Dialog(
            insetPadding: const EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            child: SizedBox(
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: YoutubePlayer(
                  controller: _popupYoutubeController,
                  showVideoProgressIndicator: true,
                  progressColors: const ProgressBarColors(
                    playedColor: Colors.red,
                    handleColor: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return Container(
        height: 180,
        color: Colors.black,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error, color: Colors.red, size: 30),
            Text("failed_to_load_video".tr(),
                style: TextStyle(color: Colors.white)),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () => _showVideoPopup(context),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Stack(
            children: [
              YoutubePlayer(
                controller: _youtubeController,
                showVideoProgressIndicator: true,
                width: double.infinity,
                aspectRatio: 16 / 9,
                progressColors: const ProgressBarColors(
                  playedColor: Colors.red,
                  handleColor: Colors.white,
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
