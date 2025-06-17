import 'package:flame/game.dart';
import 'package:planea/domain/entities/planea_type.dart';
import 'package:planea/domain/entities/game_mode.dart';
import 'package:planea/domain/entities/match_phase.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/bloc/multiplayer/multiplayer_state.dart';
import 'package:planea/presentation/bloc/singleplayer/singleplayer_game_cubit.dart';
import 'package:planea/presentation/bloc/leaderboard/leaderboard_cubit.dart';
import 'package:planea/presentation/bloc/multiplayer/multiplayer_cubit.dart';
import 'package:planea/presentation/planea_game.dart';
import 'package:planea/presentation/presentation_utils.dart';
import 'package:planea/presentation/widget/game_back_button.dart';
import 'package:planea/presentation/widget/multiplayer_scoreboard.dart';
import 'package:planea/presentation/widget/tap_to_play.dart';
import 'package:planea/presentation/widget/top_score.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'parts/multiplayer_died_overlay.dart';

class MultiPlayerGamePage extends StatefulWidget {
  const MultiPlayerGamePage({super.key, required this.matchId});

  final String matchId;

  @override
  State<MultiPlayerGamePage> createState() => _MultiPlayerGamePageState();
}

class _MultiPlayerGamePageState extends State<MultiPlayerGamePage> {
  late PlaneaGame? _planeaGame;

  late SingleplayerGameCubit singleplayerCubit;
  late MultiplayerCubit multiplayerCubit;
  late LeaderboardCubit leaderboardCubit;

  PlaneaType get planeaType {
    final userId = multiplayerCubit.state.currentUserId;
    return PlaneaType.fromUserId(userId);
  }

  @override
  void initState() {
    singleplayerCubit = BlocProvider.of<SingleplayerGameCubit>(context);
    multiplayerCubit = BlocProvider.of<MultiplayerCubit>(context);
    leaderboardCubit = BlocProvider.of<LeaderboardCubit>(context);
    _planeaGame = PlaneaGame(
      const MultiplayerGameMode(),
      singleplayerCubit,
      multiplayerCubit,
      leaderboardCubit,
    );
    multiplayerCubit.onGamePageOpened(widget.matchId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MultiplayerCubit, MultiplayerState>(
      listenWhen: (previous, current) =>
          previous.matchState?.currentPhase != current.matchState?.currentPhase,
      listener: (context, state) {
        if (state.matchState != null &&
            state.matchState!.currentPhase == MatchPhase.finished) {
          _onGameFinished();
          multiplayerCubit.refreshLastMatchOverview();
        }
      },
      child: BlocBuilder<MultiplayerCubit, MultiplayerState>(
        builder: (context, state) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            body: Stack(
              children: [
                if (_planeaGame != null)
                  GameWidget(
                    game: _planeaGame!,
                    backgroundBuilder: (_) {
                      return Container(color: AppColors.backgroundColor);
                    },
                  ),
                if (state.currentPlayingState.isGameOver)
                  const MultiplayerDiedOverlayWidget(),
                if (state.currentPlayingState.isIdle)
                  const Align(alignment: Alignment(0, 0.2), child: TapToPlay()),
                SafeArea(
                  child: Column(
                    children: [
                      TopScore(
                        currentScore: state.currentScore,
                        customColor: AppColors.getPlaneaColor(planeaType),
                      ),
                      _RemainingPlayingTimer(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: PresentationConstants.defaultPadding,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const GameBackButton(),
                              Expanded(child: Container(height: 0)),
                              const _ScoreboardSection(),
                            ],
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
      ),
    );
  }

  @override
  void dispose() {
    multiplayerCubit.stopPlaying(widget.matchId);
    super.dispose();
  }

  void _onGameFinished() {
    _planeaGame!.onGameFinished();
    _planeaGame = null;
    final matchId = multiplayerCubit.state.matchId;
    context.go('/multi_player/$matchId/result');
  }
}

class _RemainingPlayingTimer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiplayerCubit, MultiplayerState>(
      builder: (context, state) {
        return Text(
          PresentationUtils.formatSeconds(state.matchPlayingRemainingSeconds),
          style: const TextStyle(color: Colors.black, fontSize: 18, height: 1),
        );
      },
    );
  }
}

class _ScoreboardSection extends StatelessWidget {
  const _ScoreboardSection();

  List<MultiplayerScore> getSortedScores(MultiplayerState state) {
    final sortedPlayers = state.matchState!.players.entries
        .map((e) => e.value)
        .toList();
    sortedPlayers.sort((a, b) => b.score.compareTo(a.score));

    return sortedPlayers.asMap().entries.map((e) {
      final rank = e.key + 1;
      final player = e.value;
      final planeaType = PlaneaType.fromUserId(player.userId);
      return MultiplayerScore(
        playerId: player.userId,
        score: player.score,
        displayName: player.displayName,
        planeaType: planeaType,
        rank: rank,
        isMe: player.userId == state.currentUserId,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiplayerCubit, MultiplayerState>(
      builder: (context, state) {
        if (state.matchState == null) {
          return const SizedBox();
        }
        return MultiplayerScoreBoard(scores: getSortedScores(state));
      },
    );
  }
}
