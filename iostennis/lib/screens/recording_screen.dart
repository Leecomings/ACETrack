import 'package:flutter/material.dart';
import '../utils/constants.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  bool _isRecording = false;
  Duration _recordDuration = Duration.zero;
  int _shotCount = 0;
  double _currentSpeed = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  Text(
                    _isRecording ? 'REC ${_formatDuration(_recordDuration)}' : '录制',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _isRecording ? AppColors.error : Colors.white,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.switch_camera, color: Colors.white),
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            // Camera Preview
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white10,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Stack(
                  children: [
                    // Placeholder for camera
                    const Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.videocam, size: 64, color: Colors.white24),
                          SizedBox(height: 12),
                          Text('摄像头预览区域', style: TextStyle(color: Colors.white38, fontSize: 14)),
                        ],
                      ),
                    ),

                    // Real-time analysis overlay
                    if (_isRecording) ...[
                      // Speed indicator
                      Positioned(
                        top: 16,
                        right: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                _currentSpeed > 0 ? '${_currentSpeed.round()}' : '--',
                                style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white),
                              ),
                              const Text('km/h', style: TextStyle(fontSize: 12, color: Colors.white54)),
                            ],
                          ),
                        ),
                      ),

                      // Shot count
                      Positioned(
                        top: 16,
                        left: 16,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black54,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.sports_tennis, color: AppColors.success, size: 18),
                              const SizedBox(width: 6),
                              Text('$_shotCount', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                            ],
                          ),
                        ),
                      ),

                      // Recording indicator
                      Positioned(
                        bottom: 16,
                        left: 16,
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Text(_formatDuration(_recordDuration), style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Controls
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Gallery
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.photo_library, color: Colors.white, size: 24),
                  ),

                  // Record button
                  GestureDetector(
                    onTap: _toggleRecording,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                      ),
                      child: Center(
                        child: Container(
                          width: _isRecording ? 28 : 56,
                          height: _isRecording ? 28 : 56,
                          decoration: BoxDecoration(
                            color: AppColors.error,
                            borderRadius: _isRecording ? BorderRadius.circular(6) : null,
                            shape: _isRecording ? BoxShape.rectangle : BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Upload
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.upload, color: Colors.white, size: 24),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _startMockUpdates();
      }
    });
  }

  void _startMockUpdates() {
    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted || !_isRecording) return;
      setState(() {
        _recordDuration += const Duration(seconds: 1);
        if (_recordDuration.inSeconds % 3 == 0) {
          _shotCount++;
          _currentSpeed = 80 + (_shotCount * 7) % 100 + 0.0;
        }
      });
      _startMockUpdates();
    });
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
