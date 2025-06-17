import 'package:planea/domain/entities/value_wrapper.dart';
import 'package:planea/domain/repositories/settings_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/presentation/bloc/settings/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._settingsRepository) : super(const SettingsState()) {
    _initialize();
  }

  final SettingsRepository _settingsRepository;

  Future<void> _initialize() async {
    final appVersion = await _settingsRepository.getAppVersion();
    emit(state.copyWith(appVersion: ValueWrapper(appVersion)));
  }
}
