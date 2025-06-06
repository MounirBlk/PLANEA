import 'dart:ui';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:planea/bloc/game/game_cubit.dart';
import 'package:planea/bloc/game/game_state.dart';
import 'package:planea/components/hidden_coin.dart';
import 'package:planea/components/pipe.dart';
import 'package:planea/planea_game.dart';

class PlanePosition extends PositionComponent
    with
        CollisionCallbacks,
        HasGameReference<PlaneaGame>,
        FlameBlocReader<GameCubit, GameState> {
  PlanePosition()
    : super(
        position: Vector2(0, 0),
        size: Vector2.all(80.0),
        anchor: Anchor.center,
        priority: 10,
      );

  late Sprite _planeaSprite;
  final Vector2 _gravity = Vector2(0, 1400.0); // Gravity effect
  Vector2 _velocity = Vector2(0, 0); // Initial velocity
  final Vector2 _jumpForce = Vector2(0, -500.0); // Force applied when jumping

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _planeaSprite = await Sprite.load('planea.png'); // Load the sprite image
    final radius = size.x / 2; // Use half the width for the circle hitbox
    final center = size / 2; // Center of the component
    add(
      CircleHitbox(
        radius: radius * 0.75, // Use half the width for the circle hitbox
        anchor: Anchor.center, // Center the hitbox
        position: center * 1.1, // Position at the center of the component
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (bloc.state.currentPlayingState != PlayingState.playing) {
      return; // Prevent jumping if the game is not in playing state
    }
    _velocity += _gravity * dt; // Apply gravity to velocity
    position += _velocity * dt; // Update position based on velocity
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _planeaSprite.render(canvas, size: size);
    //canvas.drawCircle(Offset.zero, 20, BasicPalette.red.paint());
  }

  void jump() {
    if (bloc.state.currentPlayingState != PlayingState.playing) {
      return; // Prevent jumping if the game is not in playing state
    }
    _velocity = _jumpForce;
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (bloc.state.currentPlayingState != PlayingState.playing) {
      return; // Prevent collision effects if the game is not in playing state
    }
    if (other is HiddenCoin) {
      bloc.increaseScore();
      other.removeFromParent(); // Remove the coin when collided
    } else if (other is PipePosition) {
      bloc.gameOver();
    }
  }
}
