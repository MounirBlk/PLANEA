import 'dart:ui';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:planea/domain/entities/planea_type.dart';
import 'package:planea/domain/entities/game_mode.dart';
import 'package:planea/domain/entities/playing_state.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:flutter/material.dart';
import 'package:planea/presentation/components/hidden_coin.dart';
import 'package:planea/presentation/components/outlined_text_component.dart';
import 'package:planea/presentation/components/pipe.dart';
import 'package:planea/presentation/components/planea/auto_jump_planea.dart';
import 'package:planea/presentation/components/planea_root_component.dart';
import 'package:planea/presentation/planea_game.dart';

class Planea extends PositionComponent
    with CollisionCallbacks, HasGameReference<PlaneaGame> {
  Planea({
    required this.speed,
    required this.playerId,
    required this.displayName,
    required this.isMe,
    this.autoJump = false,
    super.priority,
  }) : type = PlaneaType.fromUserId(playerId),
       super(
         position: Vector2(0, 0),
         size: Vector2.all(80.0),
         anchor: Anchor.center,
       );

  final String playerId;
  final String displayName;
  final bool isMe;
  final PlaneaType type;
  late final Sprite _sprite;
  OutlinedTextComponent? _nameComponent;

  double _velocityY = 0;

  double get velocityY => _velocityY;

  double get gravity => game.world.rootComponent.gravity;

  double get jumpForce => _jumpForce;

  final double _jumpForce = -500;
  final double speed;

  late double _multiplayerCorrectPositionAfter;

  UpdatePlaneaStateEffect? _smoothUpdatingPositionEffect;

  bool _isNameVisible = true;

  bool get isNameVisible => _isNameVisible;

  final bool autoJump;

  AutoJumpPlanea? _autoJumpPlanea;

  set isNameVisible(bool value) {
    _isNameVisible = value;
    if (value) {
      _nameComponent?.text = displayName;
    } else {
      _nameComponent?.text = '';
    }
  }

  late bool visibleOnIdle;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    visibleOnIdle = isMe;
    _sprite = await game.loadSprite(type.flamePngAssetName);
    final radius = size.x / 2;
    final center = size / 2;
    if (isMe) {
      add(
        CircleHitbox(
          radius: radius * 0.75,
          position: center * 1.1,
          anchor: Anchor.center,
          collisionType: isMe ? CollisionType.active : CollisionType.inactive,
        ),
      );
      if (autoJump) {
        add(_autoJumpPlanea = AutoJumpPlanea());
      }
    }
    add(
      _nameComponent = OutlinedTextComponent(
        text: _isNameVisible ? displayName : '',
        position: Vector2(size.x / 2, 0),
        textStyle: TextStyle(
          fontSize: 24,
          fontFamily: 'Chewy',
          fontWeight: FontWeight.bold,
          letterSpacing: 2,
          color: AppColors.getPlaneaColor(type),
        ),
      ),
    );
    _resetCorrectPositionAfter();
  }

  void _resetCorrectPositionAfter() {
    if (game.gameMode is! MultiplayerGameMode) {
      return;
    }
    _multiplayerCorrectPositionAfter =
        (game.gameMode as MultiplayerGameMode).gameConfig.correctPositionEvery *
        PlaneaRootComponent.gameSpeedMultiplier;
  }

  PlayingState get currentPlayingState =>
      game.getCurrentPlayingState(otherPlayerId: isMe ? null : playerId);

  @override
  void update(double dt) {
    super.update(dt);
    if (currentPlayingState.isNotPlaying) {
      return;
    }
    if (isMe) {
      _updatePositionNormally(dt);
    } else {
      if (_smoothUpdatingPositionEffect == null) {
        _updatePositionNormally(dt);
      }
    }

    _checkIfPlaneaIsOutOfBounds();
    _checkToDispatchMyPosition(dt);
  }

  void _updatePositionNormally(double dt) {
    _velocityY += gravity * dt;
    position.y += _velocityY * dt;
    position.x += speed * dt;
  }

  void _checkIfPlaneaIsOutOfBounds() {
    if (!isMe) {
      return;
    }
    if (position.y.abs() > (game.size.y / 2) + 20) {
      game.gameOver(x, y, _velocityY);
    }
  }

  void _checkToDispatchMyPosition(double dt) {
    if (!isMe) {
      return;
    }
    if (game.gameMode is! MultiplayerGameMode) {
      return;
    }

    _multiplayerCorrectPositionAfter -= dt;
    if (_multiplayerCorrectPositionAfter > 0) {
      return;
    }
    game.multiplayerCubit.dispatchCorrectPosition(x, y, _velocityY);
    _resetCorrectPositionAfter();
  }

  void jump() {
    if (currentPlayingState.isNotPlaying) {
      return;
    }
    _velocityY = _jumpForce;
  }

  @override
  void renderTree(Canvas canvas) {
    if (!isMe &&
        currentPlayingState.isNotPlaying &&
        currentPlayingState.isNotIdle) {
      return;
    }
    if (!visibleOnIdle && currentPlayingState.isIdle) {
      return;
    }
    super.renderTree(canvas);
    if (game.gameMode is MultiplayerGameMode && !isMe) {
      final worldWidth = game.worldWidth;
      final visibleWidth = game.camera.visibleWorldRect.size.width;
      if (x < visibleWidth) {
        // mirror for the right side
        canvas.save();
        canvas.translate(game.worldWidth, 0);
        super.renderTree(canvas);
        canvas.restore();
      } else if (x > worldWidth - visibleWidth) {
        // mirror for the left side
        canvas.save();
        canvas.translate(-game.worldWidth, 0);
        super.renderTree(canvas);
        canvas.restore();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _sprite.render(canvas, size: size);
  }

  void resetVelocity() {
    _velocityY = 0;
  }

  void updateState(
    double positionX,
    double positionY,
    double velocityY, {
    double duration = 0.15,
  }) {
    assert(game.gameMode is MultiplayerGameMode && !isMe);
    final xDiff = (positionX - x).abs();
    if (xDiff > 200 || duration == 0) {
      x = positionX;
      y = positionY;
      _velocityY = velocityY;
    } else {
      final scaledDuration = duration * PlaneaRootComponent.gameSpeedMultiplier;
      final newX = positionX + (speed * scaledDuration);
      final newVelocity = velocityY + gravity * scaledDuration;
      final newY = positionY + (newVelocity * scaledDuration);
      _smoothUpdatingPositionEffect?.removeFromParent();
      add(
        _smoothUpdatingPositionEffect = UpdatePlaneaStateEffect(
          EffectController(duration: scaledDuration),
          positionX: newX,
          positionY: newY,
          velocityY: newVelocity,
          onComplete: () {
            _smoothUpdatingPositionEffect?.removeFromParent();
            _smoothUpdatingPositionEffect = null;
          },
        ),
      );
    }
  }

  @override
  void onCollision(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollision(intersectionPoints, other);
    if (currentPlayingState.isNotPlaying) {
      return;
    }
    if (other is HiddenCoin) {
      game.increaseScore(x, y, _velocityY);
      other.removeFromParent();
    } else if (other is Pipe) {
      game.gameOver(x, y, _velocityY);
      _autoJumpPlanea?.onPlaneaDied();
    }
  }
}

class UpdatePlaneaStateEffect extends ComponentEffect<Planea> {
  UpdatePlaneaStateEffect(
    super.controller, {
    required this.positionX,
    required this.positionY,
    required this.velocityY,
    super.onComplete,
  });

  final double positionX;
  final double positionY;
  final double velocityY;

  late final double initialX;
  late final double initialY;
  late final double initialVelocityY;

  @override
  void onMount() {
    super.onMount();
    initialX = target.x;
    initialY = target.y;
    initialVelocityY = target.velocityY;
  }

  @override
  void apply(double progress) {
    final newX = lerpDouble(initialX, positionX, progress)!;
    final newY = lerpDouble(initialY, positionY, progress)!;
    final newVelocityY = lerpDouble(initialVelocityY, velocityY, progress)!;
    target.updateState(newX, newY, newVelocityY, duration: 0);
  }
}
