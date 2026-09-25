import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/services/public_profile_service.dart';

/// Resolves an ownerId to a display name via the member-readable
/// public_profiles collection. Never shows contact details — those aren't
/// fetched here at all, only a first name.
class OwnerLabel extends ConsumerWidget {
  const OwnerLabel({super.key, required this.ownerId, this.style});
  final String ownerId;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(displayNameProvider(ownerId));
    return Text(
      name.when(
        data: (name) => name ?? 'A member',
        loading: () => '...',
        error: (_, _) => 'A member',
      ),
      style: style,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}
