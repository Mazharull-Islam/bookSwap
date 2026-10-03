import 'package:flutter/material.dart';
import '../../../../app/app_colors.dart';
import '../../domain/models/achievement_badge.dart';

/// Inserts a self-dismissing banner into the app's root overlay — works
/// from anywhere (not tied to a Scaffold/ScaffoldMessenger), since a badge
/// can be earned on any screen, not just while Profile happens to be open.
void showBadgeEarnedToast(BuildContext context, BadgeInfo info) {
  final overlay = Overlay.of(context, rootOverlay: true);
  late OverlayEntry entry;
  entry = OverlayEntry(
    builder: (context) => _BadgeToast(info: info, onDone: () => entry.remove()),
  );
  overlay.insert(entry);
}

class _BadgeToast extends StatefulWidget {
  const _BadgeToast({required this.info, required this.onDone});
  final BadgeInfo info;
  final VoidCallback onDone;

  @override
  State<_BadgeToast> createState() => _BadgeToastState();
}

class _BadgeToastState extends State<_BadgeToast> {
  // A screen-reader user needs longer to hear it than a sighted user needs to
  // read it, and reduced-motion users get no slide/fade.
  late Duration _fade;
  late Duration _hold;
  bool _visible = false;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    final media = MediaQuery.of(context);
    _fade = media.disableAnimations
        ? Duration.zero
        : const Duration(milliseconds: 300);
    _hold = media.accessibleNavigation
        ? const Duration(seconds: 8)
        : const Duration(milliseconds: 2800);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) setState(() => _visible = true);
    });
    Future.delayed(_fade + _hold, () {
      if (mounted) setState(() => _visible = false);
    });
    Future.delayed(_fade + _hold + _fade, widget.onDone);
  }

  @override
  Widget build(BuildContext context) => Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: AnimatedSlide(
            duration: _fade,
            curve: Curves.easeOut,
            offset: _visible ? Offset.zero : const Offset(0, -1),
            child: AnimatedOpacity(
              duration: _fade,
              opacity: _visible ? 1 : 0,
              child: Semantics(
                liveRegion: true,
                container: true,
                label: 'Badge earned: ${widget.info.label}',
                excludeSemantics: true,
                child: Material(
                  elevation: 6,
                  color: context.colors.brand,
                  borderRadius: BorderRadius.circular(999),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.info.emoji,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Badge earned: ${widget.info.label}',
                          style: TextStyle(
                            color: context.colors.onBrand,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
