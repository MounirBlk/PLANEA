// ignore_for_file: unused_import
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:planea/presentation/bloc/game/game_cubit.dart';
import 'package:planea/presentation/bloc/game/game_state.dart';
import 'package:planea/presentation/components/pipe_pair.dart';
import 'package:planea/presentation/components/planea.dart';
import 'package:planea/presentation/components/planea_parallax_background.dart';
import 'package:planea/presentation/planea_game.dart';

class PlaneaRootComponent extends Component
    with HasGameReference<PlaneaGame>, FlameBlocReader<GameCubit, GameState> {
  late PlanePosition _planea;
  late PipePairPosition _lastPipe;
  static const _pipesDistance = 400.0;
  //late TextComponent _scoreText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(PlaneaParallaxBackground());
    add(_planea = PlanePosition());
    _generatePipes(fromX: 500);
    /*game.camera.viewfinder.add(
      _scoreText = TextComponent(
        position: Vector2(0, -(game.size.y / 2)),
        textRenderer: TextPaint(
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );*/
  }

  void onSpaceDown() {
    _checkToStartGame();
    _planea.jump();
  }

  void onTapDown(TapDownEvent event) {
    _checkToStartGame();
    _planea.jump();
  }

  void _checkToStartGame() {
    if (bloc.state.currentPlayingState.isIdle) {
      bloc.startPlaying();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    //_scoreText.text = 'Score: ${bloc.state.currentScore.toString()}';
    if (_planea.x >= _lastPipe.x) {
      _generatePipes(fromX: _pipesDistance);
      _removeOldPipes();
    }
    game.camera.viewfinder.zoom = 1;
  }

  void _generatePipes({
    int count = 20,
    double fromX = 0.0,
    double distance = 400.0,
  }) {
    for (var i = 0; i < count; i++) {
      final area = 600.0; // Vertical area for pipe pairs
      final y = (Random().nextDouble() * area) - (area / 2);
      add(
        _lastPipe = PipePairPosition(
          position: Vector2(fromX + (i * distance), y),
        ),
      );
    }
  }

  void _removeOldPipes() {
    final pipes = children.whereType<PipePairPosition>();
    final shouldBeRemoved = max(pipes.length - 5, 0);
    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
  }
}
