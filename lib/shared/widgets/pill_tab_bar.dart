import 'package:flutter/material.dart';
import '../../app/theme.dart';

/// A floating, pill-shaped alternative to a top [TabBar] — meant to sit in
/// a [Scaffold.floatingActionButton] slot with
/// [FloatingActionButtonLocation.centerFloat], driving the same
/// [TabController] a [TabBarView] listens to.
class PillTabBar extends StatelessWidget {
  const PillTabBar({super.key, required this.controller, required this.labels});

  final TabController controller;
  final List<String> labels;

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: controller,
    builder: (context, _) => Material(
      color: Colors.white,
      elevation: 6,
      shadowColor: Colors.black45,
      borderRadius: BorderRadius.circular(999),
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < labels.length; i++)
              _PillSegment(
                label: labels[i],
                selected: controller.index == i,
                onTap: () => controller.animateTo(i),
              ),
          ],
        ),
      ),
    ),
  );
}

class _PillSegment extends StatelessWidget {
  const _PillSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: selected ? forest : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : ink,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    ),
  );
}
