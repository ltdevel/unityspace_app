import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MainFormLogoWidget extends StatelessWidget {
  const MainFormLogoWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Spacer(),
        SvgPicture.asset(
          'assets/icons/app_icon.svg',
          width: 42,
          height: 42,
        ),
        const SizedBox(width: 10),
        Text(
          'Пространства',
          style: TextStyle(
            fontSize: 24,
            color: Colors.white.withOpacity(0.9),
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
