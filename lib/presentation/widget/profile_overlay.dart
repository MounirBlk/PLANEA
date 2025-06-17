import 'package:planea/domain/entities/planea_type.dart';
import 'package:planea/domain/extensions/string_extension.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/bloc/account/account_cubit.dart';
import 'package:planea/presentation/dialogs/nickname_dialog.dart';
import 'package:planea/presentation/responsive/screen_size.dart';
import 'package:planea/presentation/widget/outline_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'box_overlay.dart';
import 'planea_image.dart';

class ProfileOverlay extends StatelessWidget {
  const ProfileOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = ScreenSize.fromContext(context);
    final multiplier = switch (screenSize) {
      ScreenSize.extraSmall => 0.6,
      ScreenSize.small => 0.7,
      ScreenSize.medium => 1.0,
      ScreenSize.large => 1.1,
      ScreenSize.extraLarge => 1.2,
    };
    double relative(double value) => value * multiplier;
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        final displayName = state.currentAccount?.user.displayName;
        final userId = state.currentAccount?.user.id;
        final planeaType = userId == null
            ? PlaneaType.flutterPlanea
            : PlaneaType.fromUserId(userId);
        return BoxOverlay(
          padding: EdgeInsets.symmetric(
            horizontal: relative(12.0),
            vertical: relative(6.0),
          ),
          onTap: () => NicknameDialog.show(context),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              PlaneaImage(size: relative(48), planeaType: planeaType),
              SizedBox(width: relative(6)),
              OutlineText(
                Text(
                  displayName?.isNotNullOrBlank == true
                      ? displayName!
                      : planeaType.name,
                  style: TextStyle(
                    color: AppColors.getPlaneaColor(planeaType),
                    fontSize: relative(24),
                  ),
                ),
                strokeWidth: relative(2),
                strokeColor: Colors.black,
              ),
            ],
          ),
        );
      },
    );
  }
}
