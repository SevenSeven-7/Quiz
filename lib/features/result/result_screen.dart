import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../core/constants/app_colors.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int stars;
  final String partId;

  const ResultScreen({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.stars,
    required this.partId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildStarRating(context),
              const SizedBox(height: 32),
              _buildScoreSummary(context),
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

  Widget _buildStarRating(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return Icon(
          Icons.star,
          size: 60,
          color: index < stars ? Colors.amber : Colors.grey.withOpacity(0.3),
        ).animate(delay: (500 + (index * 200)).ms).fadeIn().scale();
      }),
    );
  }

  Widget _buildScoreSummary(BuildContext context) {
    return Column(
      children: [
        Text(
          'Skor Anda',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '$score / $totalQuestions',
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 48,
                color: AppColors.primary,
              ),
        ).animate().fadeIn(delay: 1200.ms).scale(),
      ],
    );
  }

  Widget _buildMessage(BuildContext context) {
    String message = "Luar Biasa!";
    if (score < (totalQuestions * 0.5)) {
      message = "Terus Berlatih!";
    } else if (score < totalQuestions) {
      message = "Bagus Sekali!";
    }

    return Column(
      children: [
        Text(
          message,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 32,
              ),
        ).animate().fadeIn(delay: 1500.ms).scale(),
        const SizedBox(height: 12),
        const Text(
          'Level telah selesai. Kamu mendapatkan bintang berdasarkan kecepatanmu!',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
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
            child: const Text('Ke Daftar Level'),
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
