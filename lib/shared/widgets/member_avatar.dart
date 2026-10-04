import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/app_colors.dart';
import '../../core/services/public_profile_service.dart';
import '../../core/utils/cached_image.dart';
import '../../core/utils/photo_url.dart';

/// A round avatar: the photo when there is one, otherwise the person's
/// initial. The initial sits underneath the photo, so it also shows while the
/// image loads and if it fails to load.
///
/// Decorative: the person's name is always written next to it, so screen
/// readers skip the avatar.
class AvatarCircle extends StatelessWidget {
  const AvatarCircle({
    super.key,
    required this.name,
    this.photoUrl,
    this.radius = 18,
  });

  final String name;
  final String? photoUrl;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final trimmed = name.trim();
    final initial = trimmed.isEmpty ? '?' : trimmed[0].toUpperCase();
    final thumb = avatarUrl(photoUrl, size: radius * 2);
    return ExcludeSemantics(
      child: CircleAvatar(
        radius: radius,
        backgroundColor: context.colors.surfaceSoft,
        foregroundImage: thumb == null ? null : cachedImage(thumb),
        onForegroundImageError: thumb == null ? null : (_, _) {},
        child: Text(
          initial,
          style: TextStyle(
            fontSize: radius * 0.9,
            fontWeight: FontWeight.w600,
            color: context.colors.textMuted,
          ),
        ),
      ),
    );
  }
}

/// An [AvatarCircle] for a member, looked up from the public profiles the app
/// already has loaded (so showing avatars adds no extra reads).
class MemberAvatar extends ConsumerWidget {
  const MemberAvatar({
    super.key,
    required this.userId,
    required this.name,
    this.radius = 18,
  });

  final String userId;
  final String name;
  final double radius;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final photo = ref.watch(
      allPublicProfilesProvider.select((p) => p.valueOrNull?[userId]?.photoUrl),
    );
    return AvatarCircle(name: name, photoUrl: photo, radius: radius);
  }
}
