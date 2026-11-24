import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/widgets/app_dialog.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/movie_reminder.dart';
import 'package:movie_discovery_app/features/notifications/domain/entities/notification_settings.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_cubit.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_state.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  Future<void> _confirmClearAll(BuildContext context) async {
    final confirmed = await AppDialog.show(
      context: context,
      title: 'notifications.clear_all_title'.tr(),
      message: 'notifications.clear_all_message'.tr(),
      confirmText: 'notifications.clear_all'.tr(),
      cancelText: 'notifications.cancel'.tr(),
      icon: Icons.delete_sweep_rounded,
      isDestructive: true,
    );
    if (confirmed == true && context.mounted) {
      context.read<NotificationsCubit>().clearAllReminders();
    }
  }

  Future<void> _pickCustomTime(
    BuildContext context,
    MovieReminder reminder,
  ) async {
    final now = DateTime.now();
    final initialDate = reminder.scheduledTime.isAfter(now)
        ? reminder.scheduledTime
        : now;

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: now,
      lastDate: now.add(const Duration(days: 730)),
    );
    if (pickedDate == null || !context.mounted) return;

    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDate),
    );
    if (pickedTime == null || !context.mounted) return;

    final newDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    await context.read<NotificationsCubit>().rescheduleMovie(
          reminder: reminder,
          newScheduledTime: newDateTime,
          notificationTitle:
              '${reminder.title} — ${'notifications.reminder_title'.tr()}',
          notificationBody: 'notifications.reminder_body'.tr(),
        );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F131D) : const Color(0xFFF8FAFC);
    final cardColor = isDark ? const Color(0xFF171B26) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF262A35) : const Color(0xFFE2E8F0);
    final textColor =
        isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: textColor),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: Row(
          children: [
            Container(
              width: 34.r,
              height: 34.r,
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.notifications_none_rounded,
                color: AppColors.primaryColor,
                size: 19.sp,
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              'notifications.title'.tr(),
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),
          ],
        ),
      ),
      body: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (context, state) {
          if (state is NotificationsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final loaded = state is NotificationsLoaded
              ? state
              : const NotificationsLoaded([]);
          final reminders = loaded.reminders;
          final settings = loaded.settings;

          return CustomScrollView(
            slivers: [
              // Quick Controls: Enable Switch + Default Timing
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: _QuickSettingsCard(
                    settings: settings,
                    cardColor: cardColor,
                    borderColor: borderColor,
                    textColor: textColor,
                    secondaryColor: secondaryColor,
                  ),
                ),
              ),

              // Section Header: Active Reminders + Clear All
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
                  child: Row(
                    children: [
                      Text(
                        'notifications.active_reminders'.tr(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: secondaryColor,
                          letterSpacing: 0.4,
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor.withValues(alpha: 0.18),
                          borderRadius: BorderRadius.circular(9999.r),
                        ),
                        child: Text(
                          '${reminders.length}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: isDark
                                ? const Color(0xFFD2BBFF)
                                : AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (reminders.isNotEmpty)
                        GestureDetector(
                          onTap: () => _confirmClearAll(context),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 6.h,
                            ),
                            decoration: BoxDecoration(
                              color: cardColor,
                              borderRadius: BorderRadius.circular(9999.r),
                              border: Border.all(color: borderColor),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.delete_sweep_outlined,
                                  size: 14.sp,
                                  color: AppColors.errorLightColor,
                                ),
                                SizedBox(width: 4.w),
                                Text(
                                  'notifications.clear_all'.tr(),
                                  style: TextStyle(
                                    fontSize: 11.5.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.errorLightColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),

              if (reminders.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _AnimatedEmptyReminders(
                    textColor: textColor,
                    secondaryColor: secondaryColor,
                  ),
                )
              else ...[
                // Swipe hint
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Icon(
                          Icons.swipe_left_rounded,
                          size: 13.sp,
                          color: secondaryColor,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'notifications.swipe_to_dismiss'.tr(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: secondaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 28.h),
                  sliver: SliverList.separated(
                    itemCount: reminders.length,
                    separatorBuilder: (_, _) => SizedBox(height: 12.h),
                    itemBuilder: (context, index) {
                      final reminder = reminders[index];
                      return _ReminderFeedCard(
                        reminder: reminder,
                        isDark: isDark,
                        cardColor: cardColor,
                        borderColor: borderColor,
                        textColor: textColor,
                        secondaryColor: secondaryColor,
                        onDismissed: () => context
                            .read<NotificationsCubit>()
                            .cancelReminder(reminder.movieId),
                        onViewMovie: () => Navigator.pushNamed(
                          context,
                          AppRoutes.movieDetailsRouteName,
                          arguments: reminder.movieId,
                        ),
                        onPickTime: () => _pickCustomTime(context, reminder),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _QuickSettingsCard extends StatelessWidget {
  final NotificationSettings settings;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color secondaryColor;

  const _QuickSettingsCard({
    required this.settings,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.secondaryColor,
  });

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<NotificationsCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'notifications.enable_reminders'.tr(),
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    Text(
                      'notifications.enable_reminders_sub'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: secondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              Switch.adaptive(
                value: settings.remindersEnabled,
                activeTrackColor: AppColors.primaryColor,
                activeThumbColor: Colors.white,
                onChanged: (val) => cubit.updateSettings(
                  settings.copyWith(remindersEnabled: val),
                  notificationTitleSuffix: 'notifications.reminder_title'.tr(),
                  notificationBody: 'notifications.reminder_body'.tr(),
                ),
              ),
            ],
          ),
          Divider(color: borderColor, height: 22.h),
          Text(
            'notifications.default_timing'.tr(),
            style: TextStyle(
              fontSize: 12.5.sp,
              fontWeight: FontWeight.w600,
              color: secondaryColor,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            children: [
              Expanded(
                child: _TimingChip(
                  label: 'notifications.timing_release_day'.tr(),
                  selected:
                      settings.defaultTiming == ReminderTiming.onReleaseDay,
                  isDark: isDark,
                  borderColor: borderColor,
                  textColor: textColor,
                  onTap: () => cubit.updateSettings(
                    settings.copyWith(
                      defaultTiming: ReminderTiming.onReleaseDay,
                    ),
                    notificationTitleSuffix:
                        'notifications.reminder_title'.tr(),
                    notificationBody: 'notifications.reminder_body'.tr(),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: _TimingChip(
                  label: 'notifications.timing_day_before'.tr(),
                  selected:
                      settings.defaultTiming == ReminderTiming.oneDayBefore,
                  isDark: isDark,
                  borderColor: borderColor,
                  textColor: textColor,
                  onTap: () => cubit.updateSettings(
                    settings.copyWith(
                      defaultTiming: ReminderTiming.oneDayBefore,
                    ),
                    notificationTitleSuffix:
                        'notifications.reminder_title'.tr(),
                    notificationBody: 'notifications.reminder_body'.tr(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimingChip extends StatelessWidget {
  final String label;
  final bool selected;
  final bool isDark;
  final Color borderColor;
  final Color textColor;
  final VoidCallback onTap;

  const _TimingChip({
    required this.label,
    required this.selected,
    required this.isDark,
    required this.borderColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryColor
              : (isDark ? const Color(0xFF1E2230) : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: selected ? AppColors.primaryColor : borderColor,
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 11.5.sp,
            fontWeight: FontWeight.w600,
            color: selected ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }
}

class _ReminderFeedCard extends StatelessWidget {
  final MovieReminder reminder;
  final bool isDark;
  final Color cardColor;
  final Color borderColor;
  final Color textColor;
  final Color secondaryColor;
  final VoidCallback onDismissed;
  final VoidCallback onViewMovie;
  final VoidCallback onPickTime;

  const _ReminderFeedCard({
    required this.reminder,
    required this.isDark,
    required this.cardColor,
    required this.borderColor,
    required this.textColor,
    required this.secondaryColor,
    required this.onDismissed,
    required this.onViewMovie,
    required this.onPickTime,
  });

  @override
  Widget build(BuildContext context) {
    final scheduledFormatted =
        DateFormat('MMM d, h:mm a', context.locale.languageCode)
            .format(reminder.scheduledTime);

    return Dismissible(
      key: ValueKey(reminder.movieId),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismissed(),
      background: Container(
        alignment: AlignmentDirectional.centerEnd,
        padding: EdgeInsetsDirectional.only(end: 20.w),
        decoration: BoxDecoration(
          color: AppColors.errorLightColor.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(18.r),
        ),
        child: Icon(
          Icons.delete_outline_rounded,
          color: AppColors.errorLightColor,
          size: 24.sp,
        ),
      ),
      child: Container(
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: borderColor),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster with badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: reminder.posterUrl.isNotEmpty
                      ? Image.network(
                          reminder.posterUrl,
                          width: 66.w,
                          height: 92.h,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => _posterFallback(),
                        )
                      : _posterFallback(),
                ),
                Positioned(
                  bottom: 4.h,
                  left: 4.w,
                  right: 4.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 2.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.72),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      'CINEMA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 8.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 7.r,
                        height: 7.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFF34C759),
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Expanded(
                        child: Text(
                          reminder.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onDismissed,
                        child: Icon(
                          Icons.delete_outline_rounded,
                          size: 18.sp,
                          color: secondaryColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    '${'notifications.release_date'.tr()}: ${reminder.releaseDate}',
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: secondaryColor,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: GestureDetector(
                          onTap: onPickTime,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.schedule_rounded,
                                size: 13.sp,
                                color: AppColors.primaryColor,
                              ),
                              SizedBox(width: 4.w),
                              Flexible(
                                child: Text(
                                  scheduledFormatted,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: onViewMovie,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF262A35)
                                : const Color(0xFFE2E8F0),
                            borderRadius: BorderRadius.circular(9999.r),
                          ),
                          child: Text(
                            'notifications.view_movie'.tr(),
                            style: TextStyle(
                              fontSize: 11.sp,
                              fontWeight: FontWeight.w700,
                              color: textColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _posterFallback() {
    return Container(
      width: 66.w,
      height: 92.h,
      color: AppColors.primaryColor.withValues(alpha: 0.14),
      child: Icon(
        Icons.notifications_active_rounded,
        color: AppColors.primaryColor,
        size: 26.sp,
      ),
    );
  }
}

class _AnimatedEmptyReminders extends StatefulWidget {
  final Color textColor;
  final Color secondaryColor;

  const _AnimatedEmptyReminders({
    required this.textColor,
    required this.secondaryColor,
  });

  @override
  State<_AnimatedEmptyReminders> createState() =>
      _AnimatedEmptyRemindersState();
}

class _AnimatedEmptyRemindersState extends State<_AnimatedEmptyReminders>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _floatAnim;
  late final Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _floatAnim = Tween<double>(begin: -6, end: 6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _pulseAnim = Tween<double>(begin: 0.92, end: 1.08).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 24.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: Transform.scale(
                    scale: _pulseAnim.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 88.r,
                height: 88.r,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryColor.withValues(alpha: 0.12),
                  border: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.3),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.notifications_none_rounded,
                  size: 40.sp,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            SizedBox(height: 18.h),
            Text(
              'notifications.empty_title'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: widget.textColor,
              ),
            ),
            SizedBox(height: 6.h),
            Text(
              'notifications.empty'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                height: 1.45,
                color: widget.secondaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
