import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final List<AttendanceRecord> _records = [
    AttendanceRecord(
      title: 'Computer Science 101',
      date: DateTime.now().subtract(const Duration(days: 1)),
      status: 'Present',
      time: '08:05 AM',
      location: 'Hall A',
    ),
    AttendanceRecord(
      title: 'Database Systems',
      date: DateTime.now().subtract(const Duration(days: 2)),
      status: 'Late',
      time: '02:15 PM',
      location: 'Room 03',
    ),
    AttendanceRecord(
      title: 'Digital Electronics',
      date: DateTime.now().subtract(const Duration(days: 3)),
      status: 'Present',
      time: '04:32 PM',
      location: 'Lab 01',
    ),
    AttendanceRecord(
      title: 'Software Engineering',
      date: DateTime.now().subtract(const Duration(days: 4)),
      status: 'Absent',
      time: '-',
      location: 'Hall B',
    ),
    AttendanceRecord(
      title: 'Discrete Mathematics',
      date: DateTime.now().subtract(const Duration(days: 5)),
      status: 'Present',
      time: '09:02 AM',
      location: 'Room 12',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attendance History'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(PhosphorIconsRegular.funnel),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: _records.length,
        separatorBuilder: (context, index) => const Gap(16),
        itemBuilder: (context, index) {
          final record = _records[index];
          return _buildHistoryItem(record);
        },
      ),
    );
  }

  Widget _buildHistoryItem(AttendanceRecord record) {
    Color statusColor;
    IconData statusIcon;
    
    switch (record.status) {
      case 'Present':
        statusColor = AppColors.success;
        statusIcon = PhosphorIconsFill.checkCircle;
        break;
      case 'Late':
        statusColor = AppColors.warning;
        statusIcon = PhosphorIconsFill.clock;
        break;
      case 'Absent':
        statusColor = AppColors.error;
        statusIcon = PhosphorIconsFill.xCircle;
        break;
      default:
        statusColor = AppColors.textSecondary;
        statusIcon = PhosphorIconsFill.question;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border.withOpacity(0.5)),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statusIcon, color: statusColor, size: 24),
              ),
              const Gap(16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      record.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const Gap(4),
                    Text(
                      '${DateFormat('MMM d, yyyy').format(record.date)} • ${record.location}',
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  record.status,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const Gap(16),
          const Divider(height: 1),
          const Gap(16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(PhosphorIconsRegular.clock, 'Check-in: ${record.time}'),
              _buildInfoRow(PhosphorIconsRegular.qrCode, 'Method: QR Scan'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const Gap(6),
        Text(
          text,
          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
        ),
      ],
    );
  }
}

class AttendanceRecord {
  final String title;
  final DateTime date;
  final String status;
  final String time;
  final String location;

  AttendanceRecord({
    required this.title,
    required this.date,
    required this.status,
    required this.time,
    required this.location,
  });
}
