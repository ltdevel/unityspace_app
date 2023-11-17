import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TabButton extends StatelessWidget {
  final String? iconAsset;
  final String title;
  final bool selected;
  final VoidCallback onPressed;

  const TabButton({
    super.key,
    required this.title,
    required this.selected,
    required this.onPressed,
    this.iconAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(8),
      clipBehavior: Clip.antiAlias,
      color: selected ? const Color(0xFF212022) : const Color(0x0D111012),
      child: InkWell(
        onTap: selected ? null : onPressed,
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
          ),
          height: 40,
          child: Row(
            children: [
              if (iconAsset != null)
                SvgPicture.asset(
                  iconAsset!,
                  width: 16,
                  height: 16,
                  theme: SvgTheme(
                    currentColor: selected
                        ? Colors.white.withOpacity(0.9)
                        : const Color(0xFF111012).withOpacity(0.8),
                  ),
                ),
              if (iconAsset != null) const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: selected
                      ? Colors.white.withOpacity(0.9)
                      : const Color(0xFF111012).withOpacity(0.8),
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
