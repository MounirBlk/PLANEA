part of '../home.dart';

class MultiPlayerButton extends StatelessWidget {
  const MultiPlayerButton({
    super.key,
    required this.onPressed,
    this.showLoading = false,
  });

  final VoidCallback onPressed;
  final bool showLoading;

  @override
  Widget build(BuildContext context) {
    return BigButton(
      bgColor: AppColors.greenButtonBgColor,
      strokeColor: AppColors.greenButtonStrokeColor,
      showLoading: showLoading,
      onPressed: onPressed,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset("assets/images/multi_planea.svg", height: 58),
          const SizedBox(width: 8),
          const GradientText(
            'Mode multi',
            gradient: LinearGradient(colors: AppColors.multiColorGradient),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
