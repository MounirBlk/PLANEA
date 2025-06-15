// ignore_for_file: unused_import
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planea/audio_helper.dart';
import 'package:planea/domain/repositories/game_repository.dart';
import 'package:planea/presentation/bloc/game/game_state.dart';
import 'package:nakama/nakama.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._audioHelper, this._gameRepository)
    : super(const GameState()) {
    _init();
  }

  final AudioHelper _audioHelper;
  final GameRepository _gameRepository;

  void startPlaying() {
    _audioHelper.playBackgroundAudio();
    emit(
      state.copyWith(
        currentPlayingState: PlayingState.playing,
        currentScore: 0,
      ),
    );
  }

  void increaseScore() {
    _audioHelper.playScoreCollectSound();
    emit(state.copyWith(currentScore: state.currentScore + 1));
  }

  void gameOver() async {
    _audioHelper.stopBackgroundAudio();
    emit(state.copyWith(currentPlayingState: PlayingState.gameOver));
    await _gameRepository.submitScore(state.currentScore);
    await _refreshLeaderboard();
  }

  void restartGame() {
    emit(
      state.copyWith(currentPlayingState: PlayingState.idle, currentScore: 0),
    );
  }

  void _init() async {
    await _refreshLeaderboard();
    await _refreshCurrentUserAccount();
  }

  Future<void> _refreshCurrentUserAccount() async {
    final account = await _gameRepository.getCurrentUserAccount();
    emit(state.copyWith(currentUserAccount: account));
  }

  Future<void> _refreshLeaderboard() async {
    final leaderboard = await _gameRepository.getLeaderboard();
    emit(state.copyWith(leaderboardEntity: leaderboard));
  }

  void updateUserDisplayName(String newUserDisplayName) async {
    await _gameRepository.updateUserDisplayName(newUserDisplayName);
    await _refreshLeaderboard();
    await _refreshCurrentUserAccount();
  }

  void onLeaderboardPageOpen() async {
    await _refreshLeaderboard();
  }
}
