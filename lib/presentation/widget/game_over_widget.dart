import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/presentation/bloc/singleplayer/singleplayer_game_cubit.dart';
import 'package:planea/presentation/bloc/singleplayer/singleplayer_game_state.dart';

class GameOverWidget extends StatelessWidget {
  const GameOverWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SingleplayerGameCubit, SingleplayerGameState>(
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
                    'Perdu !',
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SingleplayerGameCubit>().restartGame();
                    },
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Rejouer !',
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
