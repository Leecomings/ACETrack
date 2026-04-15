import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/mock_data.dart';
import '../widgets/court_map.dart';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String _currentPeriod = 'month';
  final List<Map<String, String>> _periods = [
    {'label': '近7天', 'value': 'week'},
    {'label': '近30天', 'value': 'month'},
    {'label': '近3个月', 'value': 'quarter'},
    {'label': '全部', 'value': 'all'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF4A5FE8), Color(0xFF7B68EE)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Header
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('数据分析', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // 周期选择
                      _buildPeriodSelector(),
                      const SizedBox(height: 16),

                      // 核心指标
                      _buildCoreMetrics(),
                      const SizedBox(height: 16),

                      // 击球类型分布
                      _buildShotTypeDistribution(),
                      const SizedBox(height: 16),

                      // 落点分布
                      _buildLandingZones(),
                      const SizedBox(height: 16),

                      // 训练趋势
                      _buildTrendChart(),
                      const SizedBox(height: 16),

                      // 技能评分
                      _buildSkillScores(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
      child: Row(
        children: _periods.map((p) {
          final isActive = _currentPeriod == p['value'];
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _currentPeriod = p['value']!),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  p['label']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 13, color: isActive ? Colors.white : AppColors.textSecondary, fontWeight: isActive ? FontWeight.w600 : FontWeight.normal),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildCoreMetrics() {
    final m = MockData.coreMetrics;
    return Row(
      children: [
        _metricCard('总击球', '${m['totalShots']}', '+${m['shotsTrend']}%', Icons.sports_tennis, AppColors.primary),
        const SizedBox(width: 8),
        _metricCard('平均球速', '${m['avgSpeed']}', '${m['speedTrend']}%', Icons.speed, AppColors.backhand),
        const SizedBox(width: 8),
        _metricCard('得分率', '${m['winRate']}%', '+${m['winRateTrend']}%', Icons.emoji_events, AppColors.success),
        const SizedBox(width: 8),
        _metricCard('训练时长', '${m['trainingHours']}h', '+${m['hoursTrend']}%', Icons.timer, AppColors.warning),
      ],
    );
  }

  Widget _metricCard(String label, String value, String trend, IconData icon, Color color) {
    final isPositive = trend.startsWith('+');
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 8),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: color)),
            const SizedBox(height: 4),
            Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            const SizedBox(height: 2),
            Text(trend, style: TextStyle(fontSize: 10, color: isPositive ? AppColors.success : AppColors.error)),
          ],
        ),
      ),
    );
  }

  Widget _buildShotTypeDistribution() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('击球类型分布', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              Text('近30天', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          ...MockData.shotTypeDistribution.map((item) {
            final colors = {'forehand': AppColors.forehand, 'backhand': AppColors.backhand, 'serve': AppColors.serve, 'volley': AppColors.volley, 'smash': AppColors.smash};
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item['label'] as String, style: const TextStyle(fontSize: 13)),
                      Text('${item['count']}次 (${item['percent']}%)', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (item['percent'] as int) / 100,
                      backgroundColor: const Color(0xFFF0F0F0),
                      valueColor: AlwaysStoppedAnimation(colors[item['type']] ?? AppColors.primary),
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildLandingZones() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('落点分布', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              Text('热力图', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 12),
          const SizedBox(height: 220, child: CourtMapWidget(showDots: true)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _zoneLabel('深区', AppColors.success),
              const SizedBox(width: 12),
              _zoneLabel('底线', AppColors.warning),
              const SizedBox(width: 12),
              _zoneLabel('发球区', AppColors.info),
              const SizedBox(width: 12),
              _zoneLabel('网前', AppColors.accent),
            ],
          ),
        ],
      ),
    );
  }

  Widget _zoneLabel(String text, Color color) {
    return Row(children: [
      Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 4),
      Text(text, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    ]);
  }

  Widget _buildTrendChart() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('训练趋势', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          SizedBox(
            height: 120,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: MockData.trendData.map((d) {
                final maxShots = MockData.trendData.map((e) => e['shots'] as int).reduce((a, b) => a > b ? a : b);
                final h = (d['shots'] as int) / maxShots;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          height: (h * 90).clamp(5, 90).toDouble(),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.7),
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(d['date'] as String, style: const TextStyle(fontSize: 9, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillScores() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('技能评估', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              const Text('查看详情 ›', style: TextStyle(fontSize: 13, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          ...MockData.skillScores.map((s) {
            final levelColors = {'excellent': AppColors.success, 'good': AppColors.info, 'average': AppColors.warning, 'poor': AppColors.error};
            final color = levelColors[s['level']] ?? AppColors.info;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(s['name'] as String, style: const TextStyle(fontSize: 13)),
                      Text('${s['score']}分', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: color)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (s['score'] as double) / 10,
                      backgroundColor: const Color(0xFFF0F0F0),
                      valueColor: AlwaysStoppedAnimation(color),
                      minHeight: 6,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(s['desc'] as String, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
                ],
              ),
            );
          }),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF7B68EE)]),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('综合评分', style: TextStyle(fontSize: 14, color: Colors.white)),
                const SizedBox(width: 12),
                Text(
                  '${(MockData.skillScores.map((s) => s['score'] as double).reduce((a, b) => a + b) / MockData.skillScores.length).toStringAsFixed(1)}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white),
                ),
                const SizedBox(width: 8),
                const Text('良好 ↑', style: TextStyle(fontSize: 14, color: Colors.white70)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
