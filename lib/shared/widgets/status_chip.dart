import 'package:flutter/material.dart';
import '../../app/app_colors.dart';

/// A small, compact pill: a status ("Available", "Overdue") or a count
/// ("3 members"). Status chips are white text on a solid fill; use
/// [StatusChip.brand] for the accent-coloured count style.
class StatusChip extends StatelessWidget {
  const StatusChip({
    super.key,
    required this.label,
    required Color this.color,
    this.shrinkTapTarget = false,
  }) : _brand = false;

  /// The accent-coloured variant used for counts.
  const StatusChip.brand({
    super.key,
    required this.label,
    this.shrinkTapTarget = false,
  }) : color = null,
       _brand = true;

  final String label;
  final Color? color;
  final bool _brand;

  /// Drops the chip's minimum tap-target padding, for chips laid over a cover
  /// image where the extra space would push them out of place.
  final bool shrinkTapTarget;

  @override
  Widget build(BuildContext context) => Chip(
    label: Text(
      label,
      style: TextStyle(
        fontSize: 12,
        fontWeight: _brand ? null : FontWeight.w600,
        color: _brand ? context.colors.onBrand : Colors.white,
      ),
    ),
    backgroundColor: _brand ? context.colors.brand : color,
    padding: EdgeInsets.zero,
    visualDensity: VisualDensity.compact,
    materialTapTargetSize: shrinkTapTarget
        ? MaterialTapTargetSize.shrinkWrap
        : null,
  );
}
