import 'package:planea/presentation/responsive/screen_size.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CreditsWidget extends StatelessWidget {
  const CreditsWidget({super.key, required this.screenSize});

  final ScreenSize screenSize;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 6.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/images/planea.svg',
              width: switch (screenSize) {
                ScreenSize.extraSmall => 44,
                ScreenSize.small ||
                ScreenSize.medium ||
                ScreenSize.large ||
                ScreenSize.extraLarge => 58,
              },
            ),
            SizedBox(
              width: switch (screenSize) {
                ScreenSize.extraSmall => 2,
                ScreenSize.small ||
                ScreenSize.medium ||
                ScreenSize.large ||
                ScreenSize.extraLarge => 6,
              },
            ),
            Text(
              'Planea bird !',
              style: TextStyle(
                fontSize: switch (screenSize) {
                  ScreenSize.extraSmall => 18,
                  ScreenSize.small ||
                  ScreenSize.medium ||
                  ScreenSize.large ||
                  ScreenSize.extraLarge => 24,
                },
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
