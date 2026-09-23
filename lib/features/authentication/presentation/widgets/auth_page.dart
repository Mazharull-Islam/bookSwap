import 'package:flutter/material.dart';
import '../../../../app/theme.dart';
import 'book_swap_brand.dart';

class AuthPage extends StatelessWidget {
  const AuthPage({super.key, required this.child, this.maxWidth = 440});
  final Widget child;
  final double maxWidth;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      backgroundColor: paper,
      surfaceTintColor: Colors.transparent,
      title: const BookSwapBrand(),
      centerTitle: true,
    ),
    body: SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: (constraints.maxHeight - 64)
                  .clamp(0, double.infinity)
                  .toDouble(),
            ),
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: child,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
