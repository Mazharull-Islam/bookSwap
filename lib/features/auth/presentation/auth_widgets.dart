import 'package:flutter/material.dart';
import '../../../core/app_theme.dart';

class BookSwapBrand extends StatelessWidget {
  const BookSwapBrand({super.key});
  @override
  Widget build(BuildContext context) => const FittedBox(
    fit: BoxFit.scaleDown,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.auto_stories_rounded, color: forest, size: 30),
        SizedBox(width: 10),
        Text(
          'bookswap',
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -1,
            color: forest,
          ),
        ),
      ],
    ),
  );
}

class BookArt extends StatelessWidget {
  const BookArt({super.key, this.compact = false});
  final bool compact;
  @override
  Widget build(BuildContext context) => ExcludeSemantics(
    child: SizedBox(
      height: compact ? 118 : 200,
      child: FittedBox(
        child: SizedBox(
          width: 270,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 190,
                height: 190,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFFDCE5CC),
                ),
              ),
              Positioned(
                left: 39,
                top: 37,
                child: Transform.rotate(
                  angle: -0.20,
                  child: _cover(
                    const Color(0xFFB16C46),
                    Icons.wb_sunny_outlined,
                  ),
                ),
              ),
              Positioned(
                right: 38,
                top: 27,
                child: Transform.rotate(
                  angle: 0.16,
                  child: _cover(forest, Icons.eco_outlined),
                ),
              ),
              const Positioned(
                right: 21,
                top: 10,
                child: Icon(
                  Icons.auto_awesome,
                  color: Color(0xFF947238),
                  size: 27,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );

  Widget _cover(Color color, IconData icon) => Container(
    width: 100,
    height: 140,
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(8),
      boxShadow: const [
        BoxShadow(
          color: Color(0x22000000),
          blurRadius: 12,
          offset: Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: paper, size: 42),
        const SizedBox(height: 22),
        Container(width: 46, height: 3, color: paper),
        const SizedBox(height: 6),
        Container(width: 30, height: 2, color: paper),
      ],
    ),
  );
}

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

class PasswordInput extends StatefulWidget {
  const PasswordInput({
    super.key,
    required this.controller,
    required this.label,
    required this.validator,
    this.enabled = true,
    this.onSubmitted,
    this.newPassword = false,
    this.fieldKey,
  });
  final TextEditingController controller;
  final String label;
  final String? Function(String?) validator;
  final bool enabled, newPassword;
  final VoidCallback? onSubmitted;
  final Key? fieldKey;
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  final _hidden = ValueNotifier(true);
  @override
  void dispose() {
    _hidden.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
    valueListenable: _hidden,
    builder: (context, hidden, _) => TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      validator: widget.validator,
      enabled: widget.enabled,
      obscureText: hidden,
      autocorrect: false,
      enableSuggestions: false,
      autofillHints: [
        widget.newPassword ? AutofillHints.newPassword : AutofillHints.password,
      ],
      textInputAction: widget.onSubmitted == null
          ? TextInputAction.next
          : TextInputAction.done,
      onFieldSubmitted: (_) => widget.onSubmitted?.call(),
      decoration: InputDecoration(
        labelText: widget.label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          tooltip: hidden ? 'Show password' : 'Hide password',
          onPressed: widget.enabled ? () => _hidden.value = !hidden : null,
          icon: Icon(
            hidden ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          ),
        ),
      ),
    ),
  );
}
