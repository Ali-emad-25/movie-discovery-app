import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';
import 'package:movie_discovery_app/features/movie_details/presentation/widgets/in_app_trailer_player.dart';

class TrailersSection extends StatefulWidget {
  final MovieDetails movie;

  const TrailersSection({
    super.key,
    required this.movie,
  });

  @override
  State<TrailersSection> createState() => _TrailersSectionState();
}

class _TrailersSectionState extends State<TrailersSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    // Only display official / main trailers
    final videos = widget.movie.videos;
    if (videos.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    final cardColor =
        isDark ? AppColors.cardDarkColor : AppColors.cardLightColor;
    final borderColor =
        isDark ? AppColors.borderDarkColor : AppColors.borderLightColor;

    final currentVideo = videos[_selectedIndex.clamp(0, videos.length - 1)];

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trailers',
                style: TextStyle(
                  color: textColor,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.3,
                ),
              ),
              Text(
                '${videos.length} ${videos.length == 1 ? "Video" : "Videos"}',
                style: TextStyle(
                  color: secondaryTextColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Main Trailer Card (Tap anywhere to play in-app)
          GestureDetector(
            onTap: () {
              InAppTrailerPlayer.show(
                context: context,
                videoKey: currentVideo.key,
                title: currentVideo.name,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: cardColor,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(color: borderColor),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Thumbnail
                    Image.network(
                      currentVideo.youtubeThumbnailUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          widget.movie.backdropPath != null &&
                                  widget.movie.backdropPath!.isNotEmpty
                              ? Image.network(
                                  widget.movie.backdropUrl,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  color: isDark
                                      ? const Color(0xFF1E2330)
                                      : const Color(0xFFE2E8F0),
                                ),
                    ),

                    // Dark Gradient
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withValues(alpha: 0.15),
                            Colors.black.withValues(alpha: 0.45),
                            Colors.black.withValues(alpha: 0.85),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),

                    // Center Play Button
                    Center(
                      child: Container(
                        width: 58.r,
                        height: 58.r,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.55),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.8),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.4),
                              blurRadius: 14,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: Colors.white,
                          size: 36.sp,
                        ),
                      ),
                    ),

                    // Bottom Info Overlay inside the thumbnail
                    Positioned(
                      left: 14.w,
                      right: 14.w,
                      bottom: 12.h,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  currentVideo.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13.5.sp,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -0.2,
                                  ),
                                ),
                                SizedBox(height: 3.h),
                                Text(
                                  '${widget.movie.title} • ${currentVideo.type}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color:
                                        Colors.white.withValues(alpha: 0.75),
                                    fontSize: 11.sp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // HD Badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6.w,
                              vertical: 2.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.25),
                              borderRadius: BorderRadius.circular(4.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.5),
                                width: 0.8,
                              ),
                            ),
                            child: Text(
                              'HD',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Horizontal selector cards if multiple trailers exist
          if (videos.length > 1) ...[
            SizedBox(height: 12.h),
            SizedBox(
              height: 72.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: videos.length,
                separatorBuilder: (_, _) => SizedBox(width: 10.w),
                itemBuilder: (context, index) {
                  final vid = videos[index];
                  final isSelected = index == _selectedIndex;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = index;
                      });
                      InAppTrailerPlayer.show(
                        context: context,
                        videoKey: vid.key,
                        title: vid.name,
                      );
                    },
                    child: Container(
                      width: 120.w,
                      decoration: BoxDecoration(
                        color: cardColor,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : borderColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(
                            vid.youtubeThumbnailUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => Container(
                              color: isDark
                                  ? const Color(0xFF1E2330)
                                  : const Color(0xFFE2E8F0),
                            ),
                          ),
                          Container(
                            color: Colors.black.withValues(
                              alpha: isSelected ? 0.2 : 0.5,
                            ),
                          ),
                          Center(
                            child: Icon(
                              Icons.play_circle_fill_rounded,
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : Colors.white70,
                              size: 26.sp,
                            ),
                          ),
                          Positioned(
                            left: 6.w,
                            right: 6.w,
                            bottom: 4.h,
                            child: Text(
                              vid.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.5.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
