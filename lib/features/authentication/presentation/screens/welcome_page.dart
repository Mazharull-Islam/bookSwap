import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_colors.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../../domain/repositories/auth_repository.dart';
import '../providers/auth_providers.dart';
import '../widgets/book_art.dart';
import '../widgets/book_swap_brand.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    final restoreFailure =
        !auth.isLoading && auth.error is SessionRestoreFailure
        ? auth.error as SessionRestoreFailure
        : null;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: (constraints.maxHeight - 48)
                    .clamp(0, double.infinity)
                    .toDouble(),
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 620),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(
                      constraints.maxWidth < 400 ? 24 : 40,
                    ),
                    decoration: BoxDecoration(
                      color: context.colors.surfaceSoft,
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Center(child: BookSwapBrand()),
                        const SizedBox(height: 40),
                        const BookArt(),
                        const SizedBox(height: 32),
                        Text(
                          'Good books.\nGreat neighbours.',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge,
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'A little closer to your next favourite read.\nBorrow, lend, and share stories nearby.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 17, height: 1.6),
                        ),
                        const SizedBox(height: 32),
                        if (restoreFailure != null) ...[
                          _RestoreBanner(
                            message: restoreFailure.message,
                            onRetry: () =>
                                ref.invalidate(authControllerProvider),
                          ),
                          const SizedBox(height: 16),
                        ],
                        PrimaryButton(
                          buttonKey: const Key('getStarted'),
                          label: 'Get started  →',
                          onPressed: () => context.push('/login'),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on_outlined,
                              size: 18,
                              color: context.colors.brand,
                            ),
                            SizedBox(width: 8),
                            Flexible(child: Text('More stories. Fewer miles.')),
                          ],
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
    );
  }
}

/// Shown when a saved sign-in couldn't be restored (typically no connection
/// at launch), so it doesn't look like the app forgot the member.
class _RestoreBanner extends StatelessWidget {
  const _RestoreBanner({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: context.colors.warningSurface,
      borderRadius: BorderRadius.circular(14),
    ),
    child: Semantics(
      liveRegion: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "We couldn't sign you back in automatically. $message",
            style: TextStyle(color: context.colors.warningText),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              key: const Key('retrySession'),
              onPressed: onRetry,
              child: const Text('Try again'),
            ),
          ),
        ],
      ),
    ),
  );
}
