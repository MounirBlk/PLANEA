import 'package:flame/game.dart';
import 'package:planea/presentation/bloc/game/game_cubit.dart';
import 'package:planea/presentation/bloc/game/game_state.dart';
import 'package:planea/presentation/dialogs/app_dialogs.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/planea_game.dart';
import 'package:planea/presentation/widget/best_score_overlay.dart';
import 'package:planea/presentation/widget/game_back_button.dart';
import 'package:planea/presentation/widget/game_over_widget.dart';
import 'package:planea/presentation/widget/profile_overlay.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/presentation/widget/tap_to_play.dart';
import 'package:planea/presentation/widget/top_score.dart';

class SinglePlayerGamePage extends StatefulWidget {
  const SinglePlayerGamePage({super.key});

  @override
  State<SinglePlayerGamePage> createState() => _SinglePlayerGamePageState();
}

class _SinglePlayerGamePageState extends State<SinglePlayerGamePage> {
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
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
              GameWidget(
                game: _planeaGame,
                backgroundBuilder: (_) {
                  return Container(color: AppColors.backgroundColor);
                },
              ),
              if (state.currentPlayingState.isGameOver) const GameOverWidget(),
              if (state.currentPlayingState.isIdle)
                const Align(alignment: Alignment(0, 0.2), child: TapToPlay()),
              if (!state.currentPlayingState.isGameOver)
                const SafeArea(child: TopScore()),
              Align(
                alignment: Alignment.topCenter,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      top: PresentationConstants.defaultPadding,
                      right: PresentationConstants.defaultPadding,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const GameBackButton(),
                        Expanded(child: Container(height: 0)),
                        Padding(
                          padding: const EdgeInsets.all(0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const ProfileOverlay(),
                              const SizedBox(height: 8),
                              BestScoreOverlay(
                                onTap: () =>
                                    AppDialogs.showLeaderboard(context),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
