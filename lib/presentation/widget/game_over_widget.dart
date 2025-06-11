import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/presentation/bloc/game/game_cubit.dart';
import 'package:planea/presentation/bloc/game/game_state.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameCubit, GameState>(
      builder: (context, state) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Container(
            color: Colors.black54,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'GAME OVER!',
                    style: TextStyle(
                      color: Color(0xFFFFCA00),
                      fontWeight: FontWeight.bold,
                      fontSize: 48,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Score: ${state.currentScore}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () => context.read<GameCubit>().restartGame(),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text(
                        'PLAY AGAIN!',
                        style: TextStyle(fontSize: 22, letterSpacing: 2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
