import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../app_colors.dart';
import '../../core/services/photo_picker.dart';
import '../../core/services/photo_uploader.dart';
import '../../core/utils/photo_url.dart';
import '../../shared/widgets/member_avatar.dart';
import '../../shared/widgets/section_heading.dart';
import '../../features/location/presentation/widgets/location_settings_card.dart';
import '../../features/reputation/presentation/widgets/reputation_card.dart';
import '../../features/authentication/domain/entities/registration.dart';
import '../../features/authentication/presentation/providers/auth_providers.dart';
import '../../features/authentication/presentation/providers/profile_photo_providers.dart';
import '../../shared/widgets/feedback.dart';
import '../../shared/widgets/secondary_button.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authControllerProvider).valueOrNull;
    final profile = user?.profile;
    return Scaffold(
      appBar: AppBar(
        // go_router's go() replaces the location, so there's no stack for
        // an automatic back arrow; this returns to the More menu.
        leading: IconButton(
          tooltip: 'Back',
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/more'),
        ),
        title: const Text('Profile'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(
                    name: profile == null
                        ? (user?.name ?? '')
                        : '${profile.firstName} ${profile.lastName}'.trim(),
                    email: user?.email ?? '',
                  ),
                  const SizedBox(height: 20),
                  if (profile != null) _AccountCard(profile: profile),
                  const SizedBox(height: 16),
                  const LocationSettingsCard(),
                  const SizedBox(height: 16),
                  const ReputationCard(),
                  const SizedBox(height: 16),
                  Card(
                    margin: EdgeInsets.zero,
                    child: ListTile(
                      leading: Icon(
                        Icons.block_outlined,
                        color: context.colors.brand,
                      ),
                      title: const Text('Manage blocked users'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => context.push('/blocked'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SecondaryButton(
                    label: 'Sign out',
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted) context.go('/login');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum _PhotoChoice { camera, gallery, remove }

class _Header extends ConsumerStatefulWidget {
  const _Header({required this.name, required this.email});
  final String name;
  final String email;

  @override
  ConsumerState<_Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<_Header> {
  bool _busy = false;

  void _say(String message) {
    if (!mounted) return;
    showMessage(context, message);
  }

  /// Runs a photo change, showing progress on the avatar and any failure as a
  /// message. [job] returns what to announce on success (null: say nothing).
  Future<void> _run(Future<String?> Function() job) async {
    setState(() => _busy = true);
    try {
      final done = await job();
      if (done != null) _say(done);
    } on PhotoUploadFailure catch (e) {
      _say(e.message);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _choose() async {
    if (_busy) return;
    final actions = ref.read(profilePhotoActionsProvider);
    if (!actions.available) {
      _say('Photos are not set up yet.');
      return;
    }
    final hasPhoto = isOurPhotoUrl(ref.read(myPhotoUrlProvider));
    final choice = await showModalBottomSheet<_PhotoChoice>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!kIsWeb)
              ListTile(
                key: const Key('photoCamera'),
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                onTap: () => Navigator.of(context).pop(_PhotoChoice.camera),
              ),
            ListTile(
              key: const Key('photoGallery'),
              leading: const Icon(Icons.photo_library_outlined),
              title: Text(kIsWeb ? 'Choose a photo' : 'Choose from gallery'),
              onTap: () => Navigator.of(context).pop(_PhotoChoice.gallery),
            ),
            if (hasPhoto)
              ListTile(
                key: const Key('photoRemove'),
                leading: const Icon(Icons.delete_outline),
                title: const Text('Remove photo'),
                onTap: () => Navigator.of(context).pop(_PhotoChoice.remove),
              ),
          ],
        ),
      ),
    );
    if (choice == null) return;
    switch (choice) {
      case _PhotoChoice.remove:
        await _run(() async {
          await actions.remove();
          return 'Photo removed.';
        });
      case _PhotoChoice.camera || _PhotoChoice.gallery:
        await _run(() async {
          final changed = await actions.change(
            choice == _PhotoChoice.camera
                ? PhotoSource.camera
                : PhotoSource.gallery,
          );
          return changed ? 'Photo updated.' : null;
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    final photo = ref.watch(myPhotoUrlProvider);
    const radius = 44.0;
    return Column(
      children: [
        Semantics(
          button: true,
          label: 'Change profile photo',
          child: InkWell(
            key: const Key('changePhoto'),
            customBorder: const CircleBorder(),
            onTap: _choose,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AvatarCircle(
                  name: widget.name,
                  photoUrl: photo,
                  radius: radius,
                ),
                if (_busy)
                  const SizedBox(
                    width: radius * 2,
                    height: radius * 2,
                    child: CircularProgressIndicator(),
                  ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: ExcludeSemantics(
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: context.colors.brand,
                      child: Icon(
                        Icons.photo_camera,
                        size: 16,
                        color: context.colors.onBrand,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          widget.name,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 2),
        Text(widget.email, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.profile});
  final ReaderProfile profile;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: context.colors.surfaceSoft,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(child: SectionHeading('Account')),
            TextButton.icon(
              key: const Key('editProfile'),
              onPressed: () => context.go('/profile/edit'),
              icon: const Icon(Icons.edit_outlined, size: 18),
              label: const Text('Edit'),
            ),
          ],
        ),
        _InfoRow(label: 'Mobile', value: profile.mobile),
        _InfoRow(label: 'Area', value: profile.address),
        _InfoRow(label: 'Genres', value: profile.preferences.join(', ')),
        if (profile.favoriteBook.isNotEmpty)
          _InfoRow(label: 'Favorite book', value: profile.favoriteBook),
      ],
    ),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 8),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        Text(value),
      ],
    ),
  );
}
