import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/bloc/game/game_cubit.dart';
import 'package:planea/presentation/bloc/game/game_state.dart';
import 'package:planea/presentation/dialogs/app_dialogs.dart';
import 'package:planea/presentation/planea_game.dart';
import 'package:planea/presentation/widget/best_score_overlay.dart';
import 'package:planea/presentation/widget/game_over_widget.dart';
import 'package:planea/presentation/widget/profile_overlay.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GameState();
}

class _GameState extends State<GamePage> {
  late PlaneaGame _planeaGame;
  late GameCubit gameCubit;
  PlayingState? _latestState;

  @override
  void initState() {
    gameCubit = BlocProvider.of<GameCubit>(context);
    _planeaGame = PlaneaGame(gameCubit);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GameCubit, GameState>(
      listener: (context, state) {
        if (state.currentPlayingState.isIdle &&
            _latestState == PlayingState.gameOver) {
          setState(() {
            _planeaGame = PlaneaGame(gameCubit);
          });
        }
        _latestState = state.currentPlayingState;
      },
      builder: (context, state) {
        return Scaffold(
          body: Stack(
            children: [
              GameWidget(
                game: _planeaGame,
                backgroundBuilder: (BuildContext context) {
                  return Container(color: AppColors.backgroundColor);
                },
              ),
              if (state.currentPlayingState.isGameOver) const GameOverWidget(),
              if (state.currentPlayingState.isIdle)
                Align(
                  alignment: Alignment(0, 0.2),
                  child: IgnorePointer(
                    child:
                        Text(
                              'TAP TO PLAY',
                              style: TextStyle(
                                color: Color(0xFF2387FC),
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                letterSpacing: 4.0,
                              ),
                            )
                            .animate(
                              onPlay: (controller) =>
                                  controller.repeat(reverse: true),
                            )
                            .scale(
                              begin: Offset(1.0, 1.0),
                              end: Offset(1.2, 1.2),
                              duration: const Duration(milliseconds: 500),
                            ),
                  ),
                ),
              if (!state.currentPlayingState.isGameOver)
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 24.0),
                    child: Text(
                      state.currentScore.toString(),
                      style: TextStyle(color: Colors.black, fontSize: 38),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const ProfileOverlay(),
                    const SizedBox(height: 8),
                    BestScoreOverlay(
                      onTap: () => AppDialogs.showLeaderboard(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
