import 'package:equatable/equatable.dart';

class GameState extends Equatable {
  const GameState({
    this.currentScore = 0,
    this.currentPlayingState = PlayingState.idle,
  });

  final int currentScore;
  final PlayingState currentPlayingState;

  GameState copyWith({int? currentScore, PlayingState? currentPlayingState}) =>
      GameState(
        currentScore: currentScore ?? this.currentScore,
        currentPlayingState: currentPlayingState ?? this.currentPlayingState,
      );

  @override
  List<Object> get props => [currentScore, currentPlayingState];
}

enum PlayingState {
  idle,
  playing,
  paused,
  gameOver;

  bool get isPlaying => this == PlayingState.playing;
  bool get isNotPlaying => !isPlaying;
  bool get isGameOver => this == PlayingState.gameOver;
  bool get isIdle => this == PlayingState.idle;
  bool get isPaused => this == PlayingState.paused;
}
