import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/responsive/screen_size.dart';
import 'package:planea/presentation/widget/big_button.dart';
import 'package:planea/presentation/widget/blurred_background.dart';
import 'package:planea/presentation/widget/game_title.dart';
import 'package:planea/presentation/widget/github_button.dart';
import 'package:planea/presentation/widget/gradient_text.dart';
import 'package:planea/presentation/widget/outline_text.dart';
import 'package:planea/presentation/widget/profile_overlay.dart';
import 'package:planea/presentation/widget/credits.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

part 'parts/single_player_button.dart';

part 'parts/multi_player_button.dart';

class GamePage extends StatelessWidget {
  const GamePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize.fromContext(context);
    final titleBottomSpace = switch (screenSize) {
      ScreenSize.extraSmall => 16.0,
      ScreenSize.small => 24.0,
      ScreenSize.medium => 32.0,
      ScreenSize.large => 40.0,
      ScreenSize.extraLarge => 48.0,
    };
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        fit: StackFit.expand,
        children: [
          const BlurredBackground(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(flex: 2, child: Container()),
                  GameTitle(screenSize: screenSize),
                  SizedBox(height: titleBottomSpace),
                  SinglePlayerButton(
                    onPressed: () => context.push('/single_player'),
                  ),
                  const SizedBox(height: 18),
                  MultiPlayerButton(
                    onPressed: () => context.push('/lobby:test-match-id'),
                  ),
                  const SizedBox(height: 8),
                  Expanded(flex: 3, child: Container()),
                  CreditsWidget(screenSize: screenSize),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(
                  top: PresentationConstants.defaultPadding,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GithubButton(screenSize: screenSize),
                    Expanded(child: Container(height: 0)),
                    const ProfileOverlay(),
                    const SizedBox(width: PresentationConstants.defaultPadding),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
