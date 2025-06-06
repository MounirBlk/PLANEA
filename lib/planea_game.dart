import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planea/bloc/game/game_cubit.dart';
import 'package:planea/bloc/game/game_state.dart';
import 'package:planea/components/pipe_pair.dart';
import 'package:planea/components/planea.dart';
import 'package:planea/components/planea_parallax_background.dart';

class PlaneaGame extends FlameGame<PlaneaWorld>
    with KeyboardEvents, HasCollisionDetection {
  PlaneaGame(this.gameCubit)
    : super(
        world: PlaneaWorld(),
        camera: CameraComponent.withFixedResolution(width: 600, height: 1000),
      );

  final GameCubit gameCubit;

  @override
  KeyEventResult onKeyEvent(
    KeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is KeyDownEvent;
    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    if (isSpace && isKeyDown) {
      world.onSpaceDown();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  void onRemove() {
    // Clean up resources or save state if necessary
    // This is called when the game is removed from the widget tree
    // For example, you might want to save the game state or dispose of resources
    super.onRemove();
  }

  @override
  void onGameResize(Vector2 size) {
    // Adjust camera or other components based on the new size if needed
    super.onGameResize(size);
  }

  @override
  Future<void> onLoad() async {
    // Load initial game components here
    // For example, you can add a background or initial entities
    await super.onLoad();
    debugMode = false; // Enable debug mode for visual debugging
  }

  @override
  void onMount() {
    // implement onMount
    super.onMount();
  }

  @override
  void update(double dt) {
    // Update game logic here
    super.update(dt);
  }

  @override
  void render(Canvas canvas) {
    // Render game components here
    super.render(canvas);
  }
}

class PlaneaWorld extends World
    with TapCallbacks, HasGameReference<PlaneaGame> {
  late PlaneaRootComponent _rootComponent;
  @override
  void onLoad() {
    super.onLoad();
    add(
      FlameBlocProvider<GameCubit, GameState>(
        create: () => game.gameCubit,
        children: [_rootComponent = PlaneaRootComponent()],
      ),
    );
  }

  void onSpaceDown() => _rootComponent.onSpaceDown();

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    _rootComponent.onTapDown(event);
  }
}

class PlaneaRootComponent extends Component
    with HasGameReference<PlaneaGame>, FlameBlocReader<GameCubit, GameState> {
  late PlanePosition _planea;
  late PipePairPosition _lastPipe;
  static const _pipesDistance = 400.0;
  late TextComponent _scoreText;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    add(PlaneaParallaxBackground());
    add(_planea = PlanePosition());
    _generatePipes(fromX: 500);
    game.camera.viewfinder.add(
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
    );
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
    if (bloc.state.currentPlayingState == PlayingState.none) {
      bloc.startPlaying();
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    _scoreText.text = 'Score: ${bloc.state.currentScore.toString()}';
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
