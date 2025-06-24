import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:planea/domain/entities/planea_type.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/bloc/account/account_cubit.dart';
import 'package:planea/presentation/widget/outline_text.dart';

class TapToPlay extends StatelessWidget {
  const TapToPlay({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        final userId = state.currentAccount?.user.id;
        final planeaType = userId == null
            ? PlaneaType.flutterPlanea
            : PlaneaType.fromUserId(userId);
        return IgnorePointer(
          child:
              OutlineText(
                    Text(
                      'Jouer',
                      style: TextStyle(
                        color: AppColors.getPlaneaColor(planeaType),
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                        letterSpacing: 4,
                      ),
                    ),
                    strokeColor: Colors.black,
                    strokeWidth: 4,
                  )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .scale(
                    begin: const Offset(1.0, 1.0),
                    end: const Offset(1.2, 1.2),
                    duration: const Duration(milliseconds: 500),
                  ),
        );
      },
    );
  }
}
