import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/theme.dart';
import '../../../../shared/widgets/primary_button.dart';
import '../widgets/book_art.dart';
import '../widgets/book_swap_brand.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
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
                  padding: EdgeInsets.all(constraints.maxWidth < 400 ? 24 : 40),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EEDF),
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
                      PrimaryButton(
                        buttonKey: const Key('getStarted'),
                        label: 'Get started  →',
                        onPressed: () => context.push('/login'),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.location_on_outlined,
                            size: 18,
                            color: forest,
                          ),
                          SizedBox(width: 8),
                          Flexible(child: Text('More stories. Fewer miles.')),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.push('/terms'),
                        child: const Text('Terms & Conditions'),
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
