import 'package:flutter/material.dart';
import 'dart:async';

/// 录制状态管理
/// 管理录制状态、计时、球速和击球计数
class RecordingProvider extends ChangeNotifier {
  bool _isRecording = false;
  Duration _duration = Duration.zero;
  int _shotCount = 0;
  double _currentSpeed = 0;
  Timer? _timer;
  Timer? _mockUpdateTimer;

  // 录制期间的事件记录
  List<Map<String, dynamic>> _events = [];

  bool get isRecording => _isRecording;
  Duration get duration => _duration;
  int get shotCount => _shotCount;
  double get currentSpeed => _currentSpeed;
  List<Map<String, dynamic>> get events => List.unmodifiable(_events);

  void startRecording() {
    _isRecording = true;
    _duration = Duration.zero;
    _shotCount = 0;
    _currentSpeed = 0;
    _events = [];

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _duration += const Duration(seconds: 1);
      notifyListeners();
    });

    // Mock data updates (will be replaced by AI service)
    _startMockAnalysis();
    notifyListeners();
  }

  Future<void> stopRecording() async {
    _isRecording = false;
    _timer?.cancel();
    _timer = null;
    _mockUpdateTimer?.cancel();
    _mockUpdateTimer = null;

    // Save recording event
    _events.add({
      'type': 'recording_end',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'duration': _duration.inSeconds,
      'shotCount': _shotCount,
      'avgSpeed': _shotCount > 0 ? _events.where((e) => e['type'] == 'shot').map((e) => e['speed'] as double).reduce((a, b) => a + b) / _shotCount : 0,
    });

    notifyListeners();
  }

  void _startMockAnalysis() {
    // Simulate shot detection every 2-5 seconds
    _mockUpdateTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (!_isRecording) return;
      _shotCount++;
      _currentSpeed = 80 + (_shotCount * 7) % 100 + 0.0;

      _events.add({
        'type': 'shot',
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'speed': _currentSpeed,
        'shotType': ['forehand', 'backhand', 'serve'][_shotCount % 3],
      });

      notifyListeners();
    });
  }

  /// 更新球速（由AI服务调用）
  void updateSpeed(double speed) {
    _currentSpeed = speed;
    notifyListeners();
  }

  /// 记录击球事件（由AI服务调用）
  void recordShot({required double speed, required String shotType}) {
    _shotCount++;
    _currentSpeed = speed;
    _events.add({
      'type': 'shot',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'speed': speed,
      'shotType': shotType,
    });
    notifyListeners();
  }

  /// 记录落点事件（由AI服务调用）
  void recordLanding({required double top, required double left, required String zone}) {
    _events.add({
      'type': 'landing',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'top': top,
      'left': left,
      'zone': zone,
    });
    notifyListeners();
  }

  /// 记录姿态事件（由AI服务调用）
  void recordPose({required Map<String, dynamic> keypoints, required double score}) {
    _events.add({
      'type': 'pose',
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'keypoints': keypoints,
      'score': score,
    });
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _mockUpdateTimer?.cancel();
    super.dispose();
  }
}
