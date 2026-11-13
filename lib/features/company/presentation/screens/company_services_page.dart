
import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/app_top_bar.dart';

class CompanyServicesPage extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const CompanyServicesPage({super.key, this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppTopBar(onMenuTap: onMenuTap),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 28),
                _buildActiveSectionHeader(),
                const SizedBox(height: 16),
                _buildActiveServiceCard(
                  priority: 'CRITICAL',
                  title: 'HVAC Compressor Failure',
                  location: 'Sector 4, Main Building',
                  isCritical: true,
                  technicianName: 'David Chen',
                  technicianRating: '4.9 (120+ jobs)',
                  activeStep: 1,
                ),
                const SizedBox(height: 16),
                _buildActiveServiceCard(
                  priority: 'ROUTINE',
                  title: 'Quarterly Meter Calibration',
                  location: 'All Zones',
                  isCritical: false,
                  isScheduled: true,
                  scheduledDate: 'Tomorrow, 09:00 AM',
                  activeStep: -1,
                ),
                const SizedBox(height: 32),
                _buildHistorySectionHeader(),
                const SizedBox(height: 16),
                _buildHistoryItem(
                  title: 'Smart Thermostat Installation',
                  date: 'Oct 12, 2023',
                  technician: 'Sarah J.',
                  completed: true,
                ),
                const SizedBox(height: 12),
                _buildHistoryItem(
                  title: 'Emergency Power Audit',
                  date: 'Sep 28, 2023',
                  technician: 'Marcus T.',
                  completed: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Services',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.darkNavy,
            letterSpacing: -0.32,
          ),
        ),
        Container(
          width: 40,
          height: 40,
          decoration: const BoxDecoration(
            color: Colors.black,
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 20),
        ),
      ],
    );
  }

  Widget _buildActiveSectionHeader() {
    return Row(
      children: [
        Text(
          'Active Services',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkNavy,
          ),
        ),
        const SizedBox(width: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.accentYellow.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            '2 IN PROGRESS',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.darkNavy,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActiveServiceCard({
    required String priority,
    required String title,
    required String location,
    required bool isCritical,
    bool isScheduled = false,
    String? technicianName,
    String? technicianRating,
    String? scheduledDate,
    required int activeStep,
  }) {
    final accentColor = isCritical ? const Color(0xFFF97316) : const Color(0xFFBEC6E0);
    final priorityBg = isCritical ? const Color(0xFF2A1700) : const Color(0xFF131B2E);
    final priorityText = isCritical ? const Color(0xFFFFB95F) : const Color(0xFFBEC6E0);

    return SizedBox(
      width: double.infinity,
      child: Row(
        children: [
          Container(
            width: 4,
            height: 240,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                bottomLeft: Radius.circular(6),
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriorityBadge(priorityBg, priorityText, priority),
                  const SizedBox(height: 8),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF182442),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 14, color: AppColors.grayText.withValues(alpha: 0.6)),
                      const SizedBox(width: 4),
                      Text(
                        location,
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.grayText.withValues(alpha: 0.7),
                        ),
                      ),
                      const Spacer(),
                      if (isScheduled)
                        _buildStatusBadge('Scheduled', AppColors.lightGray,
                            AppColors.grayText)
                      else
                        _buildStatusBadge('In Progress', AppColors.greenBg,
                            AppColors.green),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (isScheduled) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.schedule,
                              size: 14, color: Color(0xFF45464E)),
                          SizedBox(width: 6),
                          Text(
                            'Pending Assignment',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF45464E),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 6),
                    if (scheduledDate != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 4),
                        child: Text(
                          'Est. Arrival: $scheduledDate',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.grayText.withValues(alpha: 0.6),
                          ),
                        ),
                      ),
                  ] else ...[
                    Row(
                      children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8EEF7),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person,
                              size: 18, color: Color(0xFF182442)),
                        ),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              technicianName ?? '',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF182442),
                              ),
                            ),
                            Text(
                              technicianRating ?? '',
                              style: TextStyle(
                                fontSize: 11,
                                color: AppColors.grayText.withValues(alpha: 0.6),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.phone_outlined,
                            size: 18,
                            color: Color(0xFF1E40AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 14),
                  _buildTimeline(activeStep),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(Color bg, Color text, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: text,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildStatusBadge(
      String label, Color bg, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeline(int activeStep) {
    final steps = ['Assigned', 'In Transit', 'Working'];
    return Row(
      children: List.generate(steps.length, (i) {
        final isActive = i <= activeStep;
        final isLast = i == steps.length - 1;
        return Expanded(
          child: Row(
            children: [
              Column(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isActive
                          ? AppColors.darkNavy
                          : AppColors.lightGray,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    steps[i],
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight:
                          isActive ? FontWeight.w600 : FontWeight.w400,
                      color: isActive
                          ? AppColors.darkNavy
                          : AppColors.grayText.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    height: 2,
                    color: i < activeStep
                        ? AppColors.darkNavy
                        : AppColors.lightGray,
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildHistorySectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Service History',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.darkNavy,
          ),
        ),
        TextButton(
          onPressed: () {},
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'View All',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem({
    required String title,
    required String date,
    required String technician,
    required bool completed,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF10B981),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF182442),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Completed $date • Tech: $technician',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.grayText.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.08),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              'View Report',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
    );
  }
}