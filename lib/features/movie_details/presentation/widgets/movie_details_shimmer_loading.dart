import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MovieDetailsShimmerLoading extends StatefulWidget {
  const MovieDetailsShimmerLoading({super.key});

  @override
  State<MovieDetailsShimmerLoading> createState() =>
      _MovieDetailsShimmerLoadingState();
}

class _MovieDetailsShimmerLoadingState extends State<MovieDetailsShimmerLoading>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor =
        isDark ? const Color(0xFF1E2330) : const Color(0xFFE2E8F0);
    final highlightColor =
        isDark ? const Color(0xFF2A3142) : const Color(0xFFF1F5F9);

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final shimmerColor = Color.lerp(
          baseColor,
          highlightColor,
          _controller.value,
        )!;

        return ListView(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            // Hero Shimmer (16/10)
            AspectRatio(
              aspectRatio: 16 / 10,
              child: Container(
                color: shimmerColor,
              ),
            ),
            SizedBox(height: 16.h),

            // Title & Score Shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 200.w,
                        height: 24.h,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                      ),
                      SizedBox(height: 8.h),
                      Container(
                        width: 120.w,
                        height: 14.h,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: 70.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 16.h),

            // Action Buttons Shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 48.h,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(9999.r),
                ),
              ),
            ),

            SizedBox(height: 18.h),

            // Segmented Tabs Shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 40.h,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(9999.r),
                ),
              ),
            ),

            SizedBox(height: 20.h),

            // Storyline Card Shimmer
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Container(
                height: 120.h,
                decoration: BoxDecoration(
                  color: shimmerColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
