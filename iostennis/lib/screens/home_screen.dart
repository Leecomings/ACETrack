import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/mock_data.dart';
import '../widgets/court_map.dart';
import '../widgets/score_board.dart';
import '../widgets/speed_table.dart';
import '../models/tennis_data.dart';
import '../widgets/pose_overlay.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('ACETrack', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner, color: Colors.white),
                          onPressed: () => Navigator.pushNamed(context, '/scan'),
                          tooltip: '扫码绑定球场',
                        ),
                        IconButton(
                          icon: const Icon(Icons.bluetooth, color: Colors.white),
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('设备连接功能开发中'), behavior: SnackBarBehavior.floating),
                            );
                          },
                          tooltip: '连接设备',
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24)),
                  ),
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      // 实时落点分布
                      const Text('  网球落点监测', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      const CourtMapWidget(),
                      const SizedBox(height: 20),

                      // 球速记录
                      const Text('  球速追踪', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      SpeedTableWidget(data: MockData.speedData),
                      const SizedBox(height: 20),

                      // 用户姿态监测
                      const Text('  姿态分析', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      PoseOverlay(
                        poseAnalysis: PoseAnalysis(
                          swingScore: 85,
                          balanceScore: 78,
                          hitPointScore: 90,
                          followThroughScore: 82,
                          swingSpeed: 120.5,
                          bodyBalance: 87.0,
                          contactHeight: 2.1,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // 比分板
                      const Text('  实时比分', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      const SizedBox(height: 10),
                      ScoreBoardWidget(
                        scoreA: MockData.scoreData['scoreA'] as int,
                        scoreB: MockData.scoreData['scoreB'] as int,
                        currentSet: MockData.scoreData['currentSet'] as String,
                        status: MockData.scoreData['status'] as String,
                      ),
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
}
