import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  const ResultScreen({super.key, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildScoreCircle(context),
              const SizedBox(height: 40),
              _buildMessage(context),
              const SizedBox(height: 60),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScoreCircle(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: 1.0,
            strokeWidth: 12,
            color: AppColors.primary.withOpacity(0.2),
          ),
        ),
        SizedBox(
          width: 200,
          height: 200,
          child: CircularProgressIndicator(
            value: score / 30, // Assuming 30 is max for 3 questions
            strokeWidth: 12,
            color: AppColors.primary,
            strokeCap: StrokeCap.round,
          ).animate().custom(
            duration: 1500.ms,
            builder: (context, value, child) => CircularProgressIndicator(
              value: value * (score / 30),
              strokeWidth: 12,
              color: AppColors.primary,
              strokeCap: StrokeCap.round,
            ),
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Skor Anda',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 8),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: score.toDouble()),
              duration: const Duration(milliseconds: 1500),
              builder: (context, value, child) => Text(
                value.toInt().toString(),
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                    ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMessage(BuildContext context) {
    String message = "Luar Biasa!";
    if (score < 10) message = "Coba Lagi!";
    else if (score < 30) message = "Bagus Sekali!";

    return Column(
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 32,
              ),
        ).animate().fadeIn(delay: 1500.ms).scale(),
        const SizedBox(height: 8),
        const Text(
          'Anda telah menyelesaikan kuis ini.',
          textAlign: TextAlign.center,
        ).animate().fadeIn(delay: 1700.ms),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Main Lagi'),
          ),
        ).animate().fadeIn(delay: 2000.ms).slideY(begin: 0.2, end: 0),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: AppColors.primary),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              'Kembali ke Beranda',
              style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
            ),
          ),
        ).animate().fadeIn(delay: 2200.ms).slideY(begin: 0.2, end: 0),
      ],
    );
  }
}
