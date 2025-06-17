import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:planea/domain/entities/debug/debug_message.dart';
import 'package:planea/domain/entities/game_config_entity.dart';
import 'package:planea/domain/entities/game_mode.dart';
import 'package:planea/domain/entities/playing_state.dart';
import 'package:planea/presentation/bloc/multiplayer/multiplayer_cubit.dart';
import 'package:planea/presentation/bloc/multiplayer/multiplayer_state.dart';
import 'package:planea/presentation/components/multiplayer_controller.dart';
import 'package:planea/presentation/planea_game.dart';
import 'planea/planea.dart';
import 'pipe_pair.dart';

class PlaneaRootComponent extends Component with HasGameReference<PlaneaGame> {
  late Planea _;
  late PipePair _lastPipe;

  // late PlaneaParallaxBackground _background;
  late final GameConfigEntity _config;

  late final MultiplayerCubit _cubit;

  int _pipeCounter = 0;

  String get myId => game.leaderboardCubit.state.currentAccount!.user.id;

  late MultiplayerCubit multiplayerCubit;
  StreamSubscription? _multiplayerCubitSubscription;
  MultiplayerState? _latestMultiplayerState;

  // We use it for temporary debugging
  static double gameSpeedMultiplier = 1.0;

  double get gravity => 1400.0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _cubit = game.multiplayerCubit;
    if (game.gameMode == const MultiplayerGameMode()) {
      multiplayerCubit = game.multiplayerCubit;
      _multiplayerCubitSubscription = multiplayerCubit.stream.listen(
        _onMultiplayerStateChange,
      );
      add(MultiplayerController(priority: 9));
    }
    _config = game.gameMode.gameConfig;
    add(
      _ = Planea(
        playerId: myId,
        displayName: '',
        isMe: true,
        priority: 10,
        speed: _config.planeaMoveSpeed,
        autoJump: game.multiplayerCubit.state.isCurrentPlayerAutoJump,
      ),
    );

    _restartGameForNewIdle(isFirstTime: true);
    game.camera.follow(_, horizontalOnly: true);
  }

  void _onMultiplayerStateChange(MultiplayerState state) {
    final restarted =
        state.currentPlayingState.isIdle &&
        _latestMultiplayerState?.currentPlayingState == PlayingState.gameOver;
    if (restarted) {
      _restartGameForNewIdle(isFirstTime: false);
      // Auto start for auto jump
      if (state.isCurrentPlayerAutoJump) {
        onSpaceDown();
      }
    }

    _latestMultiplayerState = state;
  }

  void _restartGameForNewIdle({required bool isFirstTime}) {
    // Set a new position for the  (zero for now)
    switch (game.gameMode) {
      case SinglePlayerGameMode():
        _.x = 0.0;
        _.y = 0.0;
        _.resetVelocity();
        break;
      case MultiplayerGameMode():
        final cubit = game.multiplayerCubit;
        final state = cubit.state;
        if (isFirstTime) {
          final pipesLength = state.matchState!.pipesPositions.length;
          final pipesDistance = state.gameMode.gameConfig.pipesDistance;
          final randomX = (Random().nextInt(pipesLength) * pipesDistance)
              .toDouble();
          _.y = 0.0;
          _.x = randomX;
        } else {
          // position is randomized when  is died (to spawn in the portal)
          _.x = state.matchState!.players[myId]!.lastKnownX;
          _.y = state.matchState!.players[myId]!.lastKnownY;
        }
        _.resetVelocity();
        cubit.dispatchIdleEvent(_.x, _.y);
        break;
    }

    // Remove all pipes
    children.whereType<PipePair>().forEach((pipe) {
      pipe.removeFromParent();
    });

    // Generate new pipes
    _pipeCounter = _.x ~/ _config.pipesDistance;
    _generatePipes(fromX: _.x + _config.pipesDistance);

    if (game.gameMode is MultiplayerGameMode) {
      multiplayerCubit.addDebugMessage(
        DebugFunctionCallEvent(
          'PlaneaRootComponent',
          '_restartGameForNewIdle',
          {
            'isFirstTime': isFirstTime.toString(),
            'x': _.x.toString(),
            'y': _.y.toString(),
          },
        ),
      );
    }
  }

  double _getNewPipeYForMultiplayer(MultiplayerGameConfigEntity config) {
    final pipesPosition = _cubit.state.matchState!.pipesPositions;
    final posIndex = _pipeCounter % pipesPosition.length;
    return pipesPosition[posIndex] * _config.pipesPositionArea;
  }

  void _generatePipes({int count = 1, required double fromX}) {
    _cubit.addDebugMessage(
      DebugFunctionCallEvent('PlaneaRootComponent', '_generatePipes', {
        'count': count.toString(),
        'fromX': fromX.toString(),
      }),
    );

    for (int i = 0; i < count; i++) {
      final area = _config.pipesPositionArea;

      final y = switch (_config) {
        SinglePlayerGameConfigEntity() =>
          (Random().nextDouble() * area) - (area / 2),
        MultiplayerGameConfigEntity() => _getNewPipeYForMultiplayer(_config),
      };

      add(
        _lastPipe = PipePair(
          position: Vector2(fromX + (i * _config.pipesDistance), y),
          gap: _config.pipeHoleGap,
          pipeWidth: _config.pipeWidth,
          priority: 3,
        ),
      );
      _pipeCounter++;
    }
  }

  @override
  void updateTree(double dt) {
    super.updateTree(dt * gameSpeedMultiplier);
  }

  void _removeLastPipes() {
    final pipes = children.whereType<PipePair>();
    final shouldBeRemoved = max(pipes.length - 5, 0);
    pipes.take(shouldBeRemoved).forEach((pipe) {
      pipe.removeFromParent();
    });
  }

  void onSpaceDown() => _jump();

  void onTapDown(TapDownEvent event) => _jump();

  void _jump() {
    _checkToStart();
    if (game.getCurrentPlayingState().isNotPlaying) {
      return;
    }
    _.jump();
    game.playerJumped(_.x, _.y, _.velocityY);
  }

  void _checkToStart() {
    if (game.getCurrentPlayingState().isIdle) {
      game.onGameStarted();
    }
  }

  PipePair _removeAllPipesExceptLastOne() {
    final pipes = children.whereType<PipePair>();
    for (int i = pipes.length - 2; i >= 0; i--) {
      pipes.elementAt(i).removeFromParent();
    }
    return pipes.last;
  }

  void _tryToLoopTheGame() {
    if (_config is! MultiplayerGameConfigEntity) {
      return;
    }

    // We loop if the  is out of the screen
    if (_.x <= game.worldWidth) {
      return;
    }

    final lastPipe = _removeAllPipesExceptLastOne();
    lastPipe.x = 0.0;
    _.x = _.x - game.worldWidth;
    _pipeCounter = 0;
    _generatePipes(fromX: _config.pipesDistance);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _tryToLoopTheGame();
    if (_.x > _lastPipe.x) {
      _generatePipes(fromX: _lastPipe.x + _config.pipesDistance);
      _removeLastPipes();
    }
  }

  @override
  void onRemove() {
    _multiplayerCubitSubscription?.cancel();
    super.onRemove();
  }
}
