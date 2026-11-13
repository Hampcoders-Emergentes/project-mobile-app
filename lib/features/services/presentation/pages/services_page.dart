import 'package:flutter/material.dart';
import 'package:mobile_app_electrolink/core/theme/app_theme.dart';
import 'package:mobile_app_electrolink/features/service_request/presentation/pages/service_request_page.dart';
import 'package:mobile_app_electrolink/features/services/presentation/pages/service_tracking_page.dart';

class ServicesPage extends StatelessWidget {
  final VoidCallback? onMenuTap;

  const ServicesPage({super.key, this.onMenuTap});

  void _openNewRequest(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const ServiceRequestPage()),
    );
  }

  void _openServiceDetail(BuildContext context, String serviceId) {
    if (serviceId == 'hvac-compressor-failure') {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const ServiceTrackingPage()),
      );
      return;
    }
    // TODO: vista de detalle del resto de servicios (pendiente de diseño).
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(context),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 24),
                _buildTitleRow(context),
                const SizedBox(height: 28),
                _buildSectionHeader(
                  title: 'Active Services',
                  trailing: const Text(
                    '2 IN PROGRESS',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grayText,
                      letterSpacing: 0.6,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _ActiveServiceCard(
                  accentColor: const Color(0xFFF59E0B),
                  badgeLabel: 'CRITICAL',
                  badgeBackground: const Color(0xFF231B00),
                  badgeTextColor: const Color(0xFFF59E0B),
                  statusLabel: 'In Progress',
                  statusDotColor: const Color(0xFF006C49),
                  title: 'HVAC Compressor Failure',
                  subtitle: 'Sector 4, Main Building',
                  technicianTile: const _TechnicianTile(
                    name: 'David Chen',
                    detail: '4.9 (120+ jobs)',
                    showRating: true,
                    showPhone: true,
                  ),
                  progress: _ServiceProgress.working,
                  onTap: () => _openServiceDetail(context, 'hvac-compressor-failure'),
                ),
                const SizedBox(height: 20),
                _ActiveServiceCard(
                  accentColor: AppColors.lightBlueText,
                  badgeLabel: 'ROUTINE',
                  badgeBackground: AppColors.darkNavy,
                  badgeTextColor: Colors.white,
                  statusLabel: 'Scheduled',
                  statusDotColor: AppColors.darkNavy,
                  title: 'Quarterly Meter\nCalibration',
                  subtitle: 'All Zones',
                  technicianTile: const _TechnicianTile(
                    name: 'Pending Assignment',
                    detail: 'Est. Arrival: Tomorrow, 09:00 AM',
                    showRating: false,
                    showPhone: false,
                  ),
                  progress: _ServiceProgress.pending,
                  onTap: () => _openServiceDetail(context, 'quarterly-meter-calibration'),
                ),
                const SizedBox(height: 32),
                _buildSectionHeader(
                  title: 'Service History',
                  trailing: GestureDetector(
                    onTap: () {},
                    child: const Text(
                      'View All',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.darkText,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildHistoryCard(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.appBarBg,
        border: Border(bottom: BorderSide(color: AppColors.borderLight)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: onMenuTap,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.profileBg,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const Icon(Icons.person, size: 20, color: AppColors.darkNavy),
            ),
          ),
          const Spacer(),
          const Icon(Icons.notifications_none, size: 24, color: AppColors.darkText),
        ],
      ),
    );
  }

  Widget _buildTitleRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Services',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
            letterSpacing: -0.3,
          ),
        ),
        GestureDetector(
          onTap: () => _openNewRequest(context),
          child: Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.darkText,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.add, color: Colors.white, size: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader({required String title, required Widget trailing}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.darkText,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: trailing,
        ),
      ],
    );
  }

  Widget _buildHistoryCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const _HistoryItem(
            icon: Icons.build_outlined,
            title: 'Smart Thermostat Installation',
            detail: 'Completed • Oct 12, 2023 • Tech: Sarah J.',
          ),
          Container(
            height: 1,
            color: AppColors.borderLight.withValues(alpha: 0.4),
          ),
          const _HistoryItem(
            icon: Icons.bolt_outlined,
            title: 'Emergency Power Audit',
            detail: 'Completed • Sep 28, 2023 • Tech: Marcus T.',
          ),
        ],
      ),
    );
  }
}

enum _ServiceProgress { working, pending }

class _ActiveServiceCard extends StatelessWidget {
  final Color accentColor;
  final String badgeLabel;
  final Color badgeBackground;
  final Color badgeTextColor;
  final String statusLabel;
  final Color statusDotColor;
  final String title;
  final String subtitle;
  final _TechnicianTile technicianTile;
  final _ServiceProgress progress;
  final VoidCallback? onTap;

  const _ActiveServiceCard({
    required this.accentColor,
    required this.badgeLabel,
    required this.badgeBackground,
    required this.badgeTextColor,
    required this.statusLabel,
    required this.statusDotColor,
    required this.title,
    required this.subtitle,
    required this.technicianTile,
    required this.progress,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 6, color: accentColor),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildBadge(),
                            _buildStatusPill(),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkText,
                            height: 1.25,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          subtitle,
                          style: const TextStyle(
                            fontSize: 15,
                            color: AppColors.grayText,
                          ),
                        ),
                        const SizedBox(height: 16),
                        technicianTile,
                        const SizedBox(height: 16),
                        Container(
                          height: 1,
                          color: AppColors.borderLight.withValues(alpha: 0.4),
                        ),
                        const SizedBox(height: 16),
                        _ProgressStepper(progress: progress),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: badgeBackground,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        badgeLabel,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: badgeTextColor,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildStatusPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.6)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: statusDotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            statusLabel,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.darkText,
            ),
          ),
        ],
      ),
    );
  }
}

class _TechnicianTile extends StatelessWidget {
  final String name;
  final String detail;
  final bool showRating;
  final bool showPhone;

  const _TechnicianTile({
    required this.name,
    required this.detail,
    required this.showRating,
    required this.showPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: showPhone ? AppColors.profileBg : AppColors.borderLight,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              size: 22,
              color: showPhone ? AppColors.darkNavy : Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    if (showRating) ...[
                      const Icon(Icons.star, size: 14, color: Color(0xFFF59E0B)),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        detail,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.grayText,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          if (showPhone) ...[
            const SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.borderLight),
              ),
              child: const Icon(Icons.phone_outlined,
                  size: 18, color: AppColors.darkText),
            ),
          ],
        ],
      ),
    );
  }
}

class _ProgressStepper extends StatelessWidget {
  final _ServiceProgress progress;

  const _ProgressStepper({required this.progress});

  static const _green = Color(0xFF006C49);
  static const _gray = Color(0xFFC6C6CE);
  static const _grayText = Color(0xFF76777D);

  @override
  Widget build(BuildContext context) {
    final isActive = progress == _ServiceProgress.working;
    return Column(
      children: [
        Row(
          children: [
            _circle(done: isActive, current: !isActive),
            Expanded(child: _line(active: isActive)),
            _circle(done: isActive, current: false),
            Expanded(child: _line(active: isActive)),
            _circle(done: false, current: isActive),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _label('Assigned', isActive ? _green : _grayText,
                bold: isActive),
            _label('In Transit', isActive ? _green : _grayText,
                bold: isActive),
            _label('Working', isActive ? AppColors.darkText : _grayText,
                bold: isActive),
          ],
        ),
      ],
    );
  }

  Widget _circle({required bool done, required bool current}) {
    if (done) {
      return Container(
        width: 24,
        height: 24,
        decoration: const BoxDecoration(color: _green, shape: BoxShape.circle),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }
    final ringColor = current && progress == _ServiceProgress.working ? _green : _gray;
    final showDot = current;
    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: ringColor, width: 2),
      ),
      alignment: Alignment.center,
      child: showDot
          ? Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: ringColor == _green ? _green : _grayText,
                shape: BoxShape.circle,
              ),
            )
          : null,
    );
  }

  Widget _line({required bool active}) {
    return Container(
      height: 2,
      color: active ? _green : _gray.withValues(alpha: 0.6),
    );
  }

  Widget _label(String text, Color color, {required bool bold}) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: bold ? FontWeight.w600 : FontWeight.w500,
        color: color,
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String detail;

  const _HistoryItem({
    required this.icon,
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF2F4F6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight.withValues(alpha: 0.5)),
            ),
            child: Icon(icon, size: 22, color: AppColors.darkText),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  detail,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.grayText,
                  ),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.borderLight),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.picture_as_pdf_outlined,
                          size: 16, color: AppColors.darkText),
                      SizedBox(width: 8),
                      Text(
                        'View Report',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
