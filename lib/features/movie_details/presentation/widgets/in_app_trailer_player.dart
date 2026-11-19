import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class InAppTrailerPlayer {
  InAppTrailerPlayer._();

  static Future<void> show({
    required BuildContext context,
    required String videoKey,
    required String title,
  }) async {
    final controller = YoutubePlayerController(
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
        mute: false,
        enableCaption: false,
      ),
    )..loadVideoById(videoId: videoKey);

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final cardColor =
            isDark ? AppColors.cardDarkColor : AppColors.cardLightColor;
        final textColor =
            isDark ? AppColors.textDarkColor : AppColors.textLightColor;
        final secondaryTextColor = isDark
            ? AppColors.secondaryTextDarkColor
            : AppColors.secondaryTextLightColor;

        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 14.w),
          child: Container(
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black54,
                  blurRadius: 24,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(dialogContext),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF222838)
                                : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            size: 18.sp,
                            color: textColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Player
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: YoutubePlayer(
                    controller: controller,
                    aspectRatio: 16 / 9,
                  ),
                ),

                // Footer
                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Official Trailer',
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: secondaryTextColor,
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () => launchYouTube(videoKey),
                        icon: const Icon(Icons.open_in_new_rounded, size: 15),
                        label: Text(
                          'Open in YouTube',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    controller.close();
  }

  static Future<void> launchYouTube(String videoKey) async {
    final Uri appUri = Uri.parse('vnd.youtube:$videoKey');
    final Uri webUri =
        Uri.parse('https://www.youtube.com/watch?v=$videoKey');

    try {
      if (await canLaunchUrl(appUri)) {
        await launchUrl(appUri);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      await launchUrl(webUri, mode: LaunchMode.externalApplication);
    }
  }
}

