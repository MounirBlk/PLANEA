import 'package:get_it/get_it.dart';
import 'package:planea/audio_helper.dart';
import 'package:planea/data/local/device_data_source.dart';
import 'package:planea/data/remote/nakama_data_source.dart';
import 'package:planea/domain/repositories/game_repository.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  getIt.registerLazySingleton<AudioHelper>(() => AudioHelper());
  getIt.registerLazySingleton<NakamaDataSource>(() => NakamaDataSource());
  getIt.registerLazySingleton<DeviceDataSource>(() => DeviceDataSource());
  getIt.registerLazySingleton<GameRepository>(
    () => GameRepository(
      getIt.get<DeviceDataSource>(),
      getIt.get<NakamaDataSource>(),
    ),
  );
}
