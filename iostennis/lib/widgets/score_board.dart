import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 比分板组件
/// 复刻Android端的score-board组件，显示实时比分
class ScoreBoardWidget extends StatelessWidget {
  final int scoreA;
  final int scoreB;
  final String currentSet;
  final String status;

  const ScoreBoardWidget({
    super.key,
    required this.scoreA,
    required this.scoreB,
    required this.currentSet,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 状态标签
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: status == '进行中'
                      ? AppColors.success.withOpacity(0.1)
                      : AppColors.textPlaceholder.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    if (status == '进行中')
                      Container(
                        width: 6,
                        height: 6,
                        margin: const EdgeInsets.only(right: 6),
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                    Text(
                      status,
                      style: TextStyle(
                        fontSize: 12,
                        color: status == '进行中' ? AppColors.success : AppColors.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                currentSet,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 比分显示
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 选手A
              _buildPlayerSide(
                label: '选手 A',
                score: scoreA,
                isLeading: scoreA > scoreB,
                color: AppColors.primary,
              ),

              // VS
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPlaceholder,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ':',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w300,
                        color: AppColors.textPlaceholder.withOpacity(0.5),
                      ),
                    ),
                  ],
                ),
              ),

              // 选手B
              _buildPlayerSide(
                label: '选手 B',
                score: scoreB,
                isLeading: scoreB > scoreA,
                color: AppColors.accent,
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 局分进度条
          _buildScoreBar(),
        ],
      ),
    );
  }

  Widget _buildPlayerSide({
    required String label,
    required int score,
    required bool isLeading,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            gradient: isLeading
                ? LinearGradient(
                    colors: [color, color.withOpacity(0.7)],
                  )
                : null,
            color: isLeading ? null : AppColors.bgGrey,
            borderRadius: BorderRadius.circular(16),
            border: isLeading ? null : Border.all(color: AppColors.border),
          ),
          child: Center(
            child: Text(
              '$score',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isLeading ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildScoreBar() {
    final total = scoreA + scoreB;
    if (total == 0) return const SizedBox.shrink();

    final ratioA = scoreA / total;

    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            height: 6,
            child: Row(
              children: [
                Expanded(
                  flex: (ratioA * 100).round(),
                  child: Container(color: AppColors.primary),
                ),
                Expanded(
                  flex: ((1 - ratioA) * 100).round(),
                  child: Container(color: AppColors.accent),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '胜率 ${(ratioA * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 11, color: AppColors.primary),
            ),
            Text(
              '胜率 ${((1 - ratioA) * 100).toStringAsFixed(0)}%',
              style: const TextStyle(fontSize: 11, color: AppColors.accent),
            ),
          ],
        ),
      ],
    );
  }
}
