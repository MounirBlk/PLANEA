import 'package:flame/game.dart';
import 'package:planea/domain/entities/game_mode.dart';
import 'package:planea/domain/entities/planea_type.dart';
import 'package:planea/domain/entities/playing_state.dart';
import 'package:planea/presentation/bloc/leaderboard/leaderboard_cubit.dart';
import 'package:planea/presentation/bloc/multiplayer/multiplayer_cubit.dart';
import 'package:planea/presentation/bloc/singleplayer/singleplayer_game_cubit.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/bloc/singleplayer/singleplayer_game_state.dart';
import 'package:planea/presentation/dialogs/leaderboard_dialog.dart';
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
  late SingleplayerGameCubit gameCubit;
  late MultiplayerCubit multiplayerCubit;
  late LeaderboardCubit leaderboardCubit;

  PlayingState? _latestState;

  PlaneaType get planeaType {
    final userId = multiplayerCubit.state.currentUserId;
    return PlaneaType.fromUserId(userId);
  }

  @override
  void initState() {
    gameCubit = BlocProvider.of<SingleplayerGameCubit>(context);
    multiplayerCubit = BlocProvider.of<MultiplayerCubit>(context);
    leaderboardCubit = BlocProvider.of<LeaderboardCubit>(context);
    _planeaGame = PlaneaGame(
      const SinglePlayerGameMode(),
      gameCubit,
      multiplayerCubit,
      leaderboardCubit,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SingleplayerGameCubit, SingleplayerGameState>(
      listener: (context, state) {
        if (state.currentPlayingState.isIdle &&
            _latestState == PlayingState.gameOver) {
          setState(() {
            _planeaGame = PlaneaGame(
              const SinglePlayerGameMode(),
              gameCubit,
              multiplayerCubit,
              leaderboardCubit,
            );
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
                  return Container(
                    color: AppColors.getPlaneaColor(planeaType),
                  ); // AppColors.backgroundColor;
                },
              ),
              if (state.currentPlayingState.isGameOver) const GameOverWidget(),
              if (state.currentPlayingState.isIdle)
                const Align(alignment: Alignment(0, 0.2), child: TapToPlay()),
              if (state.currentPlayingState.isNotGameOver)
                SafeArea(child: TopScore(currentScore: state.currentScore)),
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
                                onTap: () => LeaderBoardDialog.show(context),
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

  @override
  void dispose() {
    gameCubit.stopPlaying();
    super.dispose();
  }
}
