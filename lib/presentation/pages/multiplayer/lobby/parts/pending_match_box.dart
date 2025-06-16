import 'package:flutter/material.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/widget/big_button.dart';
import 'package:planea/presentation/widget/planea_player_box.dart';
import 'package:planea/presentation/widget/transparent_content_box';

class PendingMatchBox extends StatelessWidget {
  const PendingMatchBox({super.key, required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return TransparentContentBox(
      child: Stack(
        children: [
          Column(
            children: [
              const SizedBox(height: 16),
              const Text(
                '12:34',
                style: TextStyle(color: AppColors.whiteTextColor, fontSize: 36),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Align(
                  alignment: const Alignment(0, -0.5),
                  child: Stack(
                    fit: StackFit.loose,
                    alignment: Alignment.topLeft,
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                          left: horizontalPadding,
                          right: horizontalPadding,
                          top: 0,
                          bottom: 32,
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 174,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 3,
                            ),
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          return PlaneaPlayerBox(playerName: 'Player $index');
                        },
                      ),
                      Transform.translate(
                        offset: Offset(horizontalPadding, -32),
                        child: const Text(
                          '15 Joined',
                          style: TextStyle(
                            color: AppColors.whiteTextColor,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: BigButton(
                  strokeColor: Colors.white,
                  bgColor: AppColors.blueButtonBgColor,
                  onPressed: () {},
                  child: const Text(
                    'JOIN',
                    style: TextStyle(color: Colors.white, fontSize: 42),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ],
      ),
    );
  }
}
