import 'package:flutter/material.dart';
import 'package:planea/domain/entities/planea_type.dart';
import 'package:planea/domain/extensions/string_extension.dart';
import 'package:planea/presentation/app_style.dart';
import 'package:planea/presentation/widget/outline_text.dart';
import 'package:planea/presentation/widget/planea_image.dart';

class PlaneaPlayerBox extends StatelessWidget {
  const PlaneaPlayerBox({
    super.key,
    required this.playerUserId,
    required this.playerName,
    required this.isMe,
  });

  final String playerUserId;
  final String playerName;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.maxWidth;
        final iconSize = boxWidth * 0.25;
        final planeaType = PlaneaType.fromUserId(playerUserId);
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              PresentationConstants.defaultBorderRadiusSmall,
            ),
            border: Border.all(color: AppColors.playerBoxStrokeColor, width: 2),
            color: isMe ? AppColors.boxBgColor : null,
          ),
          child: Row(
            children: [
              SizedBox(width: boxWidth * 0.04),
              PlaneaImage(size: iconSize, planeaType: planeaType),
              SizedBox(width: boxWidth * 0.04),
              Expanded(
                child: OutlineText(
                  Text(
                    playerName.isNotBlank ? playerName : planeaType.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.getPlaneaColor(planeaType),
                      fontSize: boxWidth * 0.10,
                    ),
                  ),
                  strokeWidth: 2,
                  strokeColor: Colors.black,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
