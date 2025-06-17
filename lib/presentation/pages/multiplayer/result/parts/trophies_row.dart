part of '../match_result_page.dart';

// ignore: unused_element
class _TrophiesRow extends StatelessWidget {
  const _TrophiesRow({required this.matchResult, required this.screenSize});

  final MatchResultEntity matchResult;
  final ScreenSize screenSize;

  @override
  Widget build(BuildContext context) {
    Animate.restartOnHotReload = true;
    final bigTrophyWidth = switch (screenSize) {
      ScreenSize.extraSmall => 80.0,
      ScreenSize.small => 120.0,
      ScreenSize.medium => 160.0,
      ScreenSize.large => 200.0,
      ScreenSize.extraLarge => 260.0,
    };
    final scores = matchResult.scores;

    ({String name, PlaneaType planeaType, int score})? firstData;
    ({String name, PlaneaType planeaType, int score})? secondData;
    ({String name, PlaneaType planeaType, int score})? thirdData;

    if (scores.isNotEmpty) {
      firstData = (
        name: scores[0].user.showingName,
        planeaType: PlaneaType.fromUserId(scores[0].user.id),
        score: scores[0].score,
      );
    }

    if (scores.length > 1) {
      secondData = (
        name: scores[1].user.showingName,
        planeaType: PlaneaType.fromUserId(scores[1].user.id),
        score: scores[1].score,
      );
    }

    if (scores.length > 2) {
      thirdData = (
        name: scores[2].user.showingName,
        planeaType: PlaneaType.fromUserId(scores[2].user.id),
        score: scores[2].score,
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _LargeRankTrophy(
          rank: 2,
          data: secondData,
          bigTrophyWidth: bigTrophyWidth,
        ),
        const SizedBox(width: 32),
        _LargeRankTrophy(
          rank: 1,
          data: firstData,
          bigTrophyWidth: bigTrophyWidth,
        ),
        const SizedBox(width: 32),
        _LargeRankTrophy(
          rank: 3,
          data: thirdData,
          bigTrophyWidth: bigTrophyWidth,
        ),
      ],
    );
  }
}
