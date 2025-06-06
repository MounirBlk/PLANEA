import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/bloc/game/game_cubit.dart';
import 'package:planea/bloc/game/game_state.dart';
import 'package:planea/planea_game.dart';
import 'package:planea/widget/game_over_widget.dart';

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
        if (state.currentPlayingState == PlayingState.none &&
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
              GameWidget(game: _planeaGame),
              if (state.currentPlayingState == PlayingState.gameOver)
                const GameOverWidget(),
              if (state.currentPlayingState == PlayingState.none)
                const Align(
                  alignment: Alignment(0, 0.2),
                  child: Text(
                    'PRESS TO START',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
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
