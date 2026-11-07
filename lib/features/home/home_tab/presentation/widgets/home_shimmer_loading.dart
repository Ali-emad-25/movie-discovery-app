import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeShimmerLoading extends StatefulWidget {
  const HomeShimmerLoading({super.key});

  @override
  State<HomeShimmerLoading> createState() => _HomeShimmerLoadingState();
}

class _HomeShimmerLoadingState extends State<HomeShimmerLoading>
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
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          children: [
            // Search Bar Mock
            Container(
              height: 48.h,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(24.r),
              ),
            ),

            SizedBox(height: 20.h),

            // Hero Card Mock
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: shimmerColor,
                borderRadius: BorderRadius.circular(22.r),
              ),
            ),

            SizedBox(height: 24.h),

            // Section Header Mock
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 120.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
                Container(
                  width: 50.w,
                  height: 14.h,
                  decoration: BoxDecoration(
                    color: shimmerColor,
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                ),
              ],
            ),

            SizedBox(height: 14.h),

            // Cards Mock
            SizedBox(
              height: 220.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: 4,
                separatorBuilder: (_, _) => SizedBox(width: 14.w),
                itemBuilder: (_, _) {
                  return Container(
                    width: 140.w,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

