import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:planea/domain/entities/planea_type.dart';
import 'package:planea/domain/entities/debug/debug_message.dart';
import 'package:planea/domain/entities/match_event.dart';
import 'package:planea/domain/entities/player_state.dart';
import 'package:planea/domain/extensions/string_extension.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/bloc/multiplayer/multiplayer_cubit.dart';
import 'package:planea/presentation/bloc/multiplayer/multiplayer_state.dart';
import 'package:planea/presentation/components/planea/planea.dart';
import 'package:planea/presentation/components/planea_root_component.dart';
import 'package:flutter/foundation.dart';
import 'package:planea/presentation/planea_game.dart';

import 'planea/planea_spawn_effect.dart';
import 'planea/planea_spawn_portal.dart';

class MultiplayerController extends Component
    with ParentIsA<PlaneaRootComponent>, HasGameReference<PlaneaGame> {
  MultiplayerController({super.priority});

  late StreamSubscription<MultiplayerState> _stateStreamSubscription;
  late StreamSubscription<MatchEvent> _eventStreamSubscription;

  final Map<String, _OtherPlaneaBundle> _otherPlaneaes = {};

  MultiplayerState? _previousState;
  late MultiplayerCubit _cubit;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    _cubit = game.multiplayerCubit;
    _stateStreamSubscription = _cubit.stream.listen(_onNewState);
    _eventStreamSubscription = _cubit.matchEvents.listen(_onNewEvent);
  }

  void _onNewState(MultiplayerState state) {
    if (mapEquals(
      _previousState?.matchState?.players,
      state.matchState?.players,
    )) {
      _onPlayersUpdated(state.matchState?.players);
    }

    _previousState = state;
  }

  void _onPlayersUpdated(Map<String, PlayerState>? players) {
    if (players == null) {
      _otherPlaneaes.forEach(
        (_, planeaBundle) => planeaBundle.planea.removeFromParent(),
      );
      _otherPlaneaes.clear();
      return;
    }

    // Remove players that are no longer in the game
    for (final entry in _otherPlaneaes.entries.toList()) {
      if (!players.containsKey(entry.key)) {
        entry.value.planea.removeFromParent();
        _otherPlaneaes.remove(entry.key);
      }
    }

    // Add new players that don't have a planea yet
    final myId = _cubit.state.currentAccount!.user.id;
    final otherPlayers = players.entries.where((entry) => entry.key != myId);
    for (final otherPlayer in otherPlayers) {
      if (!_otherPlaneaes.containsKey(otherPlayer.key)) {
        final playerState = otherPlayer.value;
        final planeaType = PlaneaType.fromUserId(playerState.userId);
        final planea = Planea(
          playerId: playerState.userId,
          displayName: playerState.displayName.isNotBlank
              ? playerState.displayName
              : planeaType.name,
          isMe: false,
          speed: game.gameMode.gameConfig.planeaMoveSpeed,
        );
        add(planea);
        planea.position.x = playerState.lastKnownX;
        _otherPlaneaes[playerState.userId] = _OtherPlaneaBundle(
          planea: planea,
          playerState: playerState,
        );
      }
    }
  }

  void _onNewEvent(MatchEvent event) {
    final senderId = event.sender?.userId;
    if (senderId == null) {
      // We don't care about events without a sender id (server events)
      return;
    }

    if (senderId == _cubit.state.currentAccount!.user.id) {
      // It's my own event
      return;
    }
    if (!_otherPlaneaes.containsKey(senderId)) {
      // We don't have a planea for this player yet
      return;
    }
    //print('Controller received event: $event');
    switch (event) {
      case PlayerStartedEvent():
        final planea = _otherPlaneaes[event.sender!.userId]!.planea;
        planea.updateState(
          event.planeaX,
          event.planeaY,
          event.planeaVelocityY,
          duration: 0.0,
        );
        planea.jump();
        break;
      case PlayerJumpedEvent():
        final planea = _otherPlaneaes[event.sender!.userId]!.planea;
        planea.updateState(
          event.planeaX,
          event.planeaY,
          event.planeaVelocityY,
          duration: 0.0,
        );
        planea.jump();
        break;
      case PlayerDiedEvent():
        // Die animation? (state is automatically updated)
        final planea = _otherPlaneaes[event.sender!.userId]!.planea;
        planea.updateState(
          event.planeaX,
          event.planeaY,
          event.planeaVelocityY,
          duration: 0.0,
        );
        break;
      case PlayerWillSpawnAtEvent():
        final player = _cubit.state.matchState!.players[event.sender!.userId]!;
        final spawnsAt = player.spawnsAgainAt;
        final spawnsAfter =
            spawnsAt.difference(DateTime.now()).inMilliseconds / 1000;
        final newPos = Vector2(player.lastKnownX, player.lastKnownY);
        _spawnPortalAndPlayer(
          playerId: event.sender!.userId,
          position: newPos,
          spawnsAfter: spawnsAfter * PlaneaRootComponent.gameSpeedMultiplier,
        );
        break;
      case PlayerCorrectPositionEvent():
        // We just mutate the position of the planea
        final planea = _otherPlaneaes[event.sender!.userId]!.planea;
        if (_cubit
            .state
            .matchState!
            .players[event.sender!.userId]!
            .playingState
            .isNotPlaying) {
          return;
        }
        planea.updateState(event.planeaX, event.planeaY, event.planeaVelocityY);
        break;
      // We don't care about these events at the moment
      case PlayerIsIdleEvent():
      case PlayerKickedFromTheLobbyEvent():
      case PlayerScoredEvent():
      case PlayerJoinedTheLobby():
      case MatchFinishedEvent():
      case MatchStartedEvent():
      case MatchPresencesUpdatedEvent():
      case MatchWaitingTimeIncreasedEvent():
      case MatchWelcomeEvent():
      case MatchPongEvent():
        break;
    }
  }

  void _spawnPortalAndPlayer({
    required String playerId,
    required Vector2 position,
    required double spawnsAfter,
  }) async {
    final planea = _otherPlaneaes[playerId]!.planea;
    planea.updateState(position.x, position.y, 0.0, duration: 0.0);
    planea.scale = Vector2.all(0.0);

    // It's okay to show the other planea while it's idle after spawning,
    // Because we choose a correct place to spawn in the middle of pipes
    // But the first spawn, is random so we don't show the planea
    planea.visibleOnIdle = true;

    _cubit.addDebugMessage(
      DebugFunctionCallEvent(
        'MultiplayerController',
        '_spawnPortalAndPlayer - portal spawned',
        {
          'playerId': playerId.split('-')[0],
          'position': position.toStringWithMaxPrecision(2),
          'spawnsAfter': spawnsAfter.toStringAsFixed(2),
        },
      ),
    );
    add(
      SpawningPortal(
        position: position,
        size: Vector2.all(planea.size.x),
        color: AppColors.getPlaneaColor(
          PlaneaType.fromUserId(playerId),
        ).darken(0.2),
        priority: -1,
        hideAfter: spawnsAfter - 0.5,
        onHide: () {
          _cubit.addDebugMessage(
            DebugFunctionCallEvent(
              'MultiplayerController',
              '_spawnPortalAndPlayer - portal hidden',
              {
                'playerId': playerId.split('-')[0],
                'planea.position': planea.position.toStringWithMaxPrecision(2),
                'planea.visibleOnIdle': planea.visibleOnIdle.toString(),
              },
            ),
          );
          planea.isNameVisible = false;
          planea.add(
            PlaneaSpawnEffect(onComplete: () => planea.isNameVisible = true),
          );
        },
      ),
    );
  }

  @override
  void onRemove() {
    super.onRemove();
    _stateStreamSubscription.cancel();
    _eventStreamSubscription.cancel();
  }
}

class _OtherPlaneaBundle with EquatableMixin {
  final Planea planea;
  final PlayerState playerState;

  _OtherPlaneaBundle({required this.planea, required this.playerState});

  @override
  List<Object?> get props => [planea, playerState];
}
