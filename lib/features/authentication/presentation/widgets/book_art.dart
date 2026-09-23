import 'package:flutter/material.dart';
import '../../../../app/theme.dart';

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
