import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/presentation/bloc/leaderboard/leaderboard_cubit.dart';
import 'package:planea/presentation/bloc/leaderboard/leaderboard_state.dart';

class BlurredBackground extends StatelessWidget {
  const BlurredBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LeaderboardCubit, LeaderboardState>(
      builder: (leaderboardContext, leaderboardState) {
        final record = leaderboardState.leaderboardEntity?.ownerRecord;
        final score = int.tryParse(record?.score ?? '') ?? 0;
        final codeBackground = score >= 600
            ? '1_3'
            : score >= 450 && score <= 599
            ? '1_2'
            : score >= 300 && score <= 449
            ? '1_1'
            : score >= 150 && score <= 299
            ? '2_3'
            : score >= 0 && score <= 149
            ? '2_2'
            : '2_2';
        return Stack(
          children: [
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
              child: Image.asset(
                'assets/images/background/clouds/clouds_background$codeBackground/orig.png',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ),
            Container(
              color: Colors.black.withAlpha(
                (0.1 * 255).toInt(),
              ), // ← contrôle l’assombrissement
              width: double.infinity,
              height: double.infinity,
            ),
          ],
        );
      },
    );
  }
}
