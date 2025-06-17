import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/presentation/bloc/settings/settings_cubit.dart';
import 'package:planea/presentation/bloc/settings/settings_state.dart';

class AppVersionWidget extends StatelessWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        if (state.appVersion == null) {
          return Container();
        }
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'v${state.appVersion!.$1}',
              style: const TextStyle(fontFamily: 'RobotoMono', fontSize: 12),
            ),
          ),
        );
      },
    );
  }
}
