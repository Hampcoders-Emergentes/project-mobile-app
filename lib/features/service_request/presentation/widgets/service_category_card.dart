import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class ServiceCategoryCard extends StatelessWidget {
  final int index;
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final bool isDarkIcon;
  final VoidCallback onTap;

  const ServiceCategoryCard({
    super.key,
    required this.index,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.isDarkIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(isSelected ? 18 : 17),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.darkNavy : const Color(0xFFA9B1BA),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: isDarkIcon ? AppColors.brandLogoBg : AppColors.lightGray,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 18, color: isDarkIcon ? Colors.white : AppColors.idText),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkText,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.grayText,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Container(
              width: 32,
              margin: const EdgeInsets.only(left: 8),
              alignment: Alignment.centerRight,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? AppColors.darkNavy : AppColors.borderLight,
                    width: 2,
                  ),
                ),
                child: isSelected
                    ? Container(
                        margin: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                          color: AppColors.darkNavy,
                          shape: BoxShape.circle,
                        ),
                      )
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
