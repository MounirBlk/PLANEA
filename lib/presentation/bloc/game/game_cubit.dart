// ignore_for_file: unused_import
import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:planea/audio_helper.dart';
import 'package:planea/presentation/bloc/game/game_state.dart';
import 'package:nakama/nakama.dart';

class GameCubit extends Cubit<GameState> {
  GameCubit(this._audioHelper) : super(const GameState()) {
    _initializeNakama();
  }

  final AudioHelper _audioHelper;

  void _initializeNakama() async {
    try {
      // ignore: avoid_print
      print('INITIALIZE NAKAMA !');
      const nakameHost = String.fromEnvironment(
        'NAKAMA_HOST',
        defaultValue: '127.0.0.1',
      );
      if (nakameHost.trim().isEmpty) {
        throw Exception('Something went wrong: Nakama host not valid !');
      }
      const nakamaServerKey = String.fromEnvironment(
        'NAKAMA_SERVER_KEY',
        defaultValue: 'defaultkey',
      );
      if (nakamaServerKey.trim().isEmpty) {
        throw Exception('Something went wrong: Nakama server key not valid !');
      }
      final client = getNakamaClient(
        host: nakameHost,
        ssl: true,
        serverKey: nakamaServerKey,
        grpcPort: 8349, // optional
        httpPort: 8350, // optional
      );
      final session = await client.authenticateDevice(
        deviceId: 'test-device-id',
        username: 'lumi',
      );
      print('Session is: ${session.token}');
    } catch (e) {
      print('Nakama error: ${e.toString()}');
    }
  }

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

  void gameOver() {
    _audioHelper.stopBackgroundAudio();
    emit(state.copyWith(currentPlayingState: PlayingState.gameOver));
  }

  void restartGame() {
    emit(
      state.copyWith(currentPlayingState: PlayingState.idle, currentScore: 0),
    );
  }
}
