import 'package:flutter/material.dart';
import '../utils/constants.dart';

/// 球速记录表组件
/// 复刻Android端的speed-table组件，显示双人球速对比
class SpeedTableWidget extends StatelessWidget {
  final List<Map<String, dynamic>> data;

  const SpeedTableWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 表头
          _buildHeader(),
          const SizedBox(height: 8),
          const Divider(height: 1, color: AppColors.divider),
          const SizedBox(height: 4),

          // 数据行
          ...data.map((item) => _buildRow(item)),

          const SizedBox(height: 8),

          // 底部统计
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return const Row(
      children: [
        SizedBox(width: 50, child: Text('时间', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500))),
        Expanded(
          child: Row(
            children: [
              Expanded(child: Center(child: Text('选手A', style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.w600)))),
              SizedBox(width: 8),
              Expanded(child: Center(child: Text('选手B', style: TextStyle(fontSize: 11, color: AppColors.accent, fontWeight: FontWeight.w600)))),
            ],
          ),
        ),
        SizedBox(width: 36, child: Center(child: Text('局', style: TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.w500)))),
      ],
    );
  }

  Widget _buildRow(Map<String, dynamic> item) {
    final speedA = item['speedA'] as int;
    final speedB = item['speedB'] as int;
    final maxSpeed = speedA > speedB ? speedA : speedB;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          // 时间
          SizedBox(
            width: 50,
            child: Text(
              item['time'] as String,
              style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
            ),
          ),

          // 球速条
          Expanded(
            child: Row(
              children: [
                // 选手A球速条（从右到左）
                Expanded(
                  child: Stack(
                    children: [
                      // 背景条
                      Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.bgGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      // 填充条
                      FractionallySizedBox(
                        widthFactor: speedA / 180.0, // 最大球速约180
                        child: Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: speedA >= maxSpeed
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 4),
                          child: Text(
                            '$speedA',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                // 选手B球速条
                Expanded(
                  child: Stack(
                    children: [
                      Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: AppColors.bgGrey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: speedB / 180.0,
                        child: Container(
                          height: 18,
                          decoration: BoxDecoration(
                            color: speedB >= maxSpeed
                                ? AppColors.accent
                                : AppColors.accent.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 4),
                          child: Text(
                            '$speedB',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 局数
          SizedBox(
            width: 36,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: AppColors.primaryBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item['round']}',
                  style: const TextStyle(fontSize: 10, color: AppColors.primary, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    if (data.isEmpty) return const SizedBox.shrink();

    final avgA = data.map((d) => d['speedA'] as int).reduce((a, b) => a + b) ~/ data.length;
    final avgB = data.map((d) => d['speedB'] as int).reduce((a, b) => a + b) ~/ data.length;
    final maxA = data.map((d) => d['speedA'] as int).reduce((a, b) => a > b ? a : b);
    final maxB = data.map((d) => d['speedB'] as int).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgGrey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _statItem('均速 A', '$avgA', AppColors.primary),
          _statItem('均速 B', '$avgB', AppColors.accent),
          _statItem('最高 A', '$maxA', AppColors.primary),
          _statItem('最高 B', '$maxB', AppColors.accent),
        ],
      ),
    );
  }

  Widget _statItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}
