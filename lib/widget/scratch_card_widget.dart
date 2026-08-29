import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';
import 'package:paynow/widget/custom_text.dart';

class ScratchCardWidget extends StatefulWidget {
  final String rewardAmount;
  final String rewardType;
  final String rewardSubtitle;
  final VoidCallback? onRevealed;

  const ScratchCardWidget({
    super.key,
    required this.rewardAmount,
    required this.rewardType,
    required this.rewardSubtitle,
    this.onRevealed,
  });

  @override
  State<ScratchCardWidget> createState() => _ScratchCardWidgetState();
}

class _ScratchCardWidgetState extends State<ScratchCardWidget> {
  bool _isRevealed = false;
  double _dragDistance = 0.0;
  final double _scratchThreshold = 120.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      height: 260,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Stack(
          children: [
            // Revealed Reward Layer (Underneath)
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: AppColors.tintPurple,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard,
                        color: AppColors.primaryGradientEnd,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomText.body(
                      widget.rewardType.toUpperCase(),
                      color: AppColors.primaryGradientEnd,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    CustomText.header(
                      widget.rewardAmount,
                      color: AppColors.primary,
                      fontSize: 28,
                    ),
                    const SizedBox(height: 8),
                    CustomText.subtitle(
                      widget.rewardSubtitle,
                      fontSize: 12,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Unrevealed Cover Layer (On top, fades out when scratched)
            AnimatedOpacity(
              opacity: _isRevealed ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 400),
              curve: Curves.easeOut,
              onEnd: () {
                if (_isRevealed && widget.onRevealed != null) {
                  widget.onRevealed!();
                }
              },
              child: IgnorePointer(
                ignoring: _isRevealed,
                child: GestureDetector(
                  onPanUpdate: (details) {
                    setState(() {
                      _dragDistance += details.delta.dx.abs() + details.delta.dy.abs();
                      if (_dragDistance >= _scratchThreshold) {
                        _isRevealed = true;
                      }
                    });
                  },
                  child: Container(
                    color: Theme.of(context).cardColor,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.stars,
                              color: AppColors.white,
                              size: 48,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomText.title(
                            'Scratch to Win',
                            color: AppColors.primary,
                            fontSize: 16,
                          ),
                          const SizedBox(height: 8),
                          CustomText.subtitle(
                            'Drag or swipe to scratch card',
                            fontSize: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
