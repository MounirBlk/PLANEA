// ignore_for_file: unused_import

import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:planea/audio_helper.dart';
import 'package:planea/presentation/bloc/game/game_cubit.dart';
import 'package:planea/presentation/bloc/game/game_state.dart';
import 'package:planea/presentation/components/pipe_pair.dart';
import 'package:planea/presentation/components/planea.dart';
import 'package:planea/presentation/components/planea_parallax_background.dart';
import 'package:planea/presentation/components/planea_root_component.dart';
import 'package:planea/service_locator.dart';

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
  Future<void> onLoad() async {
    await super.onLoad();
    await getIt.get<AudioHelper>().initialize();
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
