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
    final client = getNakamaClient(
      host: dotenv.get('NAKAMA_HOST', fallback: '127.0.0.1'),
      ssl: false,
      serverKey: dotenv.get('NAKAMA_SERVER_KEY', fallback: 'defaultkey'),
      grpcPort: int.parse(
        dotenv.get('NAKAMA_GRPC_PORT', fallback: '7349'),
      ), // optional
      httpPort: int.parse(
        dotenv.get('NAKAMA_HTTP_PORT', fallback: '7350'),
      ), // optional
    );
    final session = await client.authenticateDevice(
      deviceId: 'test-device-id',
      username: 'lumi',
    );
    print('Session is: ${session.token}');

    final group = await client.createGroup(
      session: session,
      name: 'Flutter devs',
      description: 'This is a cool group for Flutter devs!',
    );
    print('Group is created: ${group.id}');
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
