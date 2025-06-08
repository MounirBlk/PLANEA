import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:planea/bloc/game/game_cubit.dart';
import 'package:planea/bloc/game/game_state.dart';
import 'package:planea/components/hidden_coin.dart';
import 'package:planea/components/pipe.dart';

class PipePairPosition extends PositionComponent
    with FlameBlocReader<GameCubit, GameState> {
  PipePairPosition({
    required super.position,
    this.gap = 200.0,
    this.speed = 200.0,
  });

  final double gap;
  final double speed; // Speed of the pipe pair

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    addAll([
      PipePosition(isFlipped: false, position: Vector2(0, gap / 2)),
      PipePosition(isFlipped: true, position: Vector2(0, -(gap / 2))),
      HiddenCoin(position: Vector2(30, 0)),
    ]);
  }

  @override
  void update(double dt) {
    switch (bloc.state.currentPlayingState) {
      case PlayingState.paused:
      case PlayingState.gameOver:
      case PlayingState.idle:
        break;
      case PlayingState.playing:
        position.x -= speed * dt; // Move the pipe pair to the left
        break;
    }
    super.update(dt);
  }
}
