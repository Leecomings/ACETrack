import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'recording_screen.dart';
import 'scoring_screen.dart';
import 'video_screen.dart';
import 'profile_screen.dart';
import '../utils/constants.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const _SafeRecordingScreen(),
    const ScoringScreen(),
    const VideoScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildTabItem(0, '首页', Icons.home_outlined, Icons.home),
                _buildTabItem(1, '录制', Icons.videocam_outlined, Icons.videocam),
                _buildTabItem(2, '计分', Icons.sports_tennis_outlined, Icons.sports_tennis),
                _buildTabItem(3, '回放', Icons.play_circle_outline, Icons.play_circle),
                _buildTabItem(4, '我的', Icons.person_outline, Icons.person),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(int index, String label, IconData icon, IconData activeIcon) {
    final isActive = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textPlaceholder,
              size: 24,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isActive ? AppColors.primary : AppColors.textPlaceholder,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 安全包装 RecordingScreen，防止相机初始化崩溃导致整个 app 黑屏
class _SafeRecordingScreen extends StatelessWidget {
  const _SafeRecordingScreen();

  @override
  Widget build(BuildContext context) {
    return ErrorBoundary(child: const RecordingScreen());
  }
}

/// 简单的错误边界 Widget
class ErrorBoundary extends StatefulWidget {
  final Widget child;
  const ErrorBoundary({super.key, required this.child});

  @override
  State<ErrorBoundary> createState() => _ErrorBoundaryState();
}

class _ErrorBoundaryState extends State<ErrorBoundary> {
  Object? _error;

  @override
  void initState() {
    super.initState();
    // 捕获异步错误
    FlutterError.onError = (details) {
      if (mounted) {
        setState(() => _error = details.exception);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.videocam, size: 64, color: Colors.white24),
              const SizedBox(height: 12),
              const Text('录制功能加载失败', style: TextStyle(color: Colors.white54, fontSize: 14)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => setState(() => _error = null),
                child: const Text('重试'),
              ),
            ],
          ),
        ),
      );
    }
    return widget.child;
  }
}
