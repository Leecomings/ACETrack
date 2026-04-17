import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/constants.dart';
import '../services/scoring_provider.dart';

class ScoringScreen extends StatelessWidget {
  const ScoringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A73E8), Color(0xFF4FC3F7)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('全局计分', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: Consumer<ScoringProvider>(
                    builder: (context, scoring, _) {
                      return ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Match Status
                          _buildMatchStatusCard(scoring),
                          const SizedBox(height: 16),

                          // Score Display
                          _buildScoreDisplay(context, scoring),
                          const SizedBox(height: 16),

                          // Score Buttons
                          _buildScoreButtons(context, scoring),
                          const SizedBox(height: 16),

                          // Game History
                          _buildGameHistory(scoring),
                          const SizedBox(height: 16),

                          // Stats
                          _buildStatsCard(scoring),
                          const SizedBox(height: 20),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatchStatusCard(ScoringProvider scoring) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF4FC3F7)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                scoring.isMatchInProgress ? '比赛进行中' : '未开始',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                scoring.isMatchInProgress ? '${scoring.currentSet} · ${scoring.serverName}发球' : '点击下方按钮开始比赛',
                style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.8)),
              ),
            ],
          ),
          if (scoring.isMatchInProgress)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.greenAccent, shape: BoxShape.circle)),
                  const SizedBox(width: 4),
                  const Text('LIVE', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScoreDisplay(BuildContext context, ScoringProvider scoring) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          // Set Score
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPlayerScore(
                name: scoring.playerAName,
                sets: scoring.setsA,
                games: scoring.gamesA,
                points: scoring.pointsA,
                color: AppColors.primary,
                isServing: scoring.isServerA,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const Text('VS', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPlaceholder, letterSpacing: 2)),
                    const SizedBox(height: 8),
                    Text(
                      scoring.isMatchInProgress ? _getPointLabel(scoring) : '-',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.accent),
                    ),
                  ],
                ),
              ),
              _buildPlayerScore(
                name: scoring.playerBName,
                sets: scoring.setsB,
                games: scoring.gamesB,
                points: scoring.pointsB,
                color: AppColors.accent,
                isServing: !scoring.isServerA,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScore({
    required String name,
    required int sets,
    required int games,
    required int points,
    required Color color,
    required bool isServing,
  }) {
    return Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isServing)
              Container(
                width: 6,
                height: 6,
                margin: const EdgeInsets.only(right: 4),
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
            Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('$sets', style: TextStyle(fontSize: 36, fontWeight: FontWeight.w800, color: color)),
            const SizedBox(width: 4),
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text('-$games', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: color.withOpacity(0.7))),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('$points', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: color.withOpacity(0.5))),
      ],
    );
  }

  String _getPointLabel(ScoringProvider scoring) {
    final pA = scoring.pointsA;
    final pB = scoring.pointsB;
    if (pA >= 3 && pB >= 3) {
      if (pA == pB) return 'Deuce';
      return pA > pB ? 'Ad-${scoring.playerAName}' : 'Ad-${scoring.playerBName}';
    }
    const labels = ['0', '15', '30', '40'];
    return '${labels[pA.clamp(0, 3)]}-${labels[pB.clamp(0, 3)]}';
  }

  Widget _buildScoreButtons(BuildContext context, ScoringProvider scoring) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: scoring.isMatchInProgress ? () => scoring.playerWinsPoint('A') : scoring.startMatch,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              scoring.isMatchInProgress ? '${scoring.playerAName} 得分' : '开始比赛',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            onPressed: scoring.isMatchInProgress ? () => scoring.playerWinsPoint('B') : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              disabledBackgroundColor: AppColors.accent.withOpacity(0.3),
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(
              '${scoring.playerBName} 得分',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: scoring.isMatchInProgress ? Colors.white : Colors.white54,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGameHistory(ScoringProvider scoring) {
    if (scoring.gameHistory.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
        child: const Center(
          child: Text('比赛开始后将显示局分记录', style: TextStyle(fontSize: 13, color: AppColors.textSecondary)),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('局分记录', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              TextButton(
                onPressed: () => scoring.undoLastPoint(),
                child: const Text('撤销', style: TextStyle(fontSize: 13, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: scoring.gameHistory.map((g) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.bgGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  g,
                  style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCard(ScoringProvider scoring) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('比赛统计', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Row(
            children: [
              _statItem('${scoring.totalPointsA}', '${scoring.playerAName}总得分', AppColors.primary),
              _statItem('${scoring.totalPointsB}', '${scoring.playerBName}总得分', AppColors.accent),
              _statItem('${scoring.totalPointsA + scoring.totalPointsB}', '总分数', AppColors.textSecondary),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }
}
