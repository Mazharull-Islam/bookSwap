import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/public_profile_service.dart';
import 'member_avatar.dart';

class OwnerLabel extends ConsumerWidget {
  const OwnerLabel({super.key, required this.ownerId, this.style});
  final String ownerId;
  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref
        .watch(displayNameProvider(ownerId))
        .when(
          data: (name) => name ?? 'A member',
          loading: () => '...',
          error: (_, _) => 'A member',
        );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        MemberAvatar(userId: ownerId, name: name, radius: 11),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            name,
            style: style,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
