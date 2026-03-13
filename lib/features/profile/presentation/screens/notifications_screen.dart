import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../../../core/constants/app_colors.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(PhosphorIconsRegular.caretLeft),
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: _notifications.length,
        separatorBuilder: (context, index) => const Gap(16),
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return _buildNotificationItem(context, notification);
        },
      ),
    );
  }

  Widget _buildNotificationItem(BuildContext context, _NotificationItem item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: item.isRead ? Colors.white : AppColors.primary.withOpacity(0.03),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: item.isRead ? AppColors.border.withOpacity(0.5) : AppColors.primary.withOpacity(0.1),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.typeColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(item.icon, color: item.typeColor, size: 20),
          ),
          const Gap(16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.title,
                      style: TextStyle(
                        fontWeight: item.isRead ? FontWeight.w600 : FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      item.time,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                    ),
                  ],
                ),
                const Gap(4),
                Text(
                  item.message,
                  style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationItem {
  final String title;
  final String message;
  final String time;
  final IconData icon;
  final Color typeColor;
  final bool isRead;

  _NotificationItem({
    required this.title,
    required this.message,
    required this.time,
    required this.icon,
    required this.typeColor,
    this.isRead = false,
  });
}

final List<_NotificationItem> _notifications = [
  _NotificationItem(
    title: 'Attendance Confirmed',
    message: 'Your attendance for Computer Science 101 has been recorded.',
    time: '2m ago',
    icon: PhosphorIconsFill.checkCircle,
    typeColor: AppColors.success,
  ),
  _NotificationItem(
    title: 'Upcoming Session',
    message: 'Database Systems starts in 30 minutes in Room 03.',
    time: '1h ago',
    icon: PhosphorIconsFill.calendar,
    typeColor: AppColors.primary,
  ),
  _NotificationItem(
    title: 'New Grade Available',
    message: 'Your attendance report for last month is now available.',
    time: 'Yesterday',
    icon: PhosphorIconsFill.fileText,
    typeColor: AppColors.info,
    isRead: true,
  ),
  _NotificationItem(
    title: 'System Update',
    message: 'Version 1.0.2 is now available with performance improvements.',
    time: '2 days ago',
    icon: PhosphorIconsFill.info,
    typeColor: AppColors.warning,
    isRead: true,
  ),
];
