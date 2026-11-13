import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../utils/format.dart';

/// Reemplaza el badge estático "Live": la comunicación es REST (polling),
/// así que se muestra honestamente cuándo llegó el último dato.
class UpdatedAgoLabel extends StatefulWidget {
  final DateTime updatedAt;

  const UpdatedAgoLabel({super.key, required this.updatedAt});

  @override
  State<UpdatedAgoLabel> createState() => _UpdatedAgoLabelState();
}

class _UpdatedAgoLabelState extends State<UpdatedAgoLabel> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 10), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFF2F4F6),
        border: Border.all(color: AppColors.borderLight),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        'Actualizado ${IotFormat.relative(widget.updatedAt)}',
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: AppColors.grayText,
        ),
      ),
    );
  }
}
