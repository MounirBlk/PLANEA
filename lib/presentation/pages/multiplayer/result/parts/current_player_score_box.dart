part of '../match_result_page.dart';

// ignore: unused_element
class _CurrentPlayerScoreBox extends StatelessWidget {
  const _CurrentPlayerScoreBox({required this.data});

  final ({int rank, String name, PlaneaType planeaType, int score}) data;

  @override
  Widget build(BuildContext context) {
    final planeaType = data.planeaType;
    return PlaneaContainer(
      borderColor: AppColors.getPlaneaColor(planeaType),
      borderRadius: 4.0,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(width: 8),
            ScoreTrophy(size: 24, rank: data.rank),
            const SizedBox(width: 8),
            PlaneaImage(size: 28, planeaType: planeaType),
            const SizedBox(width: 4),
            OutlineText(
              Text(
                data.name,
                style: TextStyle(
                  color: AppColors.getPlaneaColor(planeaType),
                  fontSize: 16,
                ),
              ),
              strokeWidth: 2,
              strokeColor: Colors.black,
            ),
            const SizedBox(width: 8),
            Text(
              data.score.toString(),
              style: TextStyle(
                color: AppColors.getPlaneaColor(planeaType),
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
