import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../utils/constants.dart';
import '../widgets/court_map.dart';
import '../widgets/pose_overlay.dart';
import '../services/recording_provider.dart';

class RecordingScreen extends StatefulWidget {
  const RecordingScreen({super.key});

  @override
  State<RecordingScreen> createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> with WidgetsBindingObserver {
  CameraController? _cameraController;
  List<CameraDescription> _cameras = [];
  bool _isCameraReady = false;
  String _cameraError = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _cameraController?.dispose();
    WakelockPlus.disable();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _cameraController;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      setState(() => _isCameraReady = false);
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _cameraError = '未找到可用摄像头');
        return;
      }
      _cameraController = CameraController(
        _cameras[0],
        ResolutionPreset.high,
        enableAudio: true,
      );
      await _cameraController!.initialize();
      if (mounted) {
        setState(() => _isCameraReady = true);
      }
    } catch (e) {
      setState(() => _cameraError = '摄像头初始化失败: $e');
    }
  }

  Future<void> _toggleRecording() async {
    final provider = Provider.of<RecordingProvider>(context, listen: false);
    if (provider.isRecording) {
      await provider.stopRecording();
      WakelockPlus.disable();
    } else {
      if (_cameraController != null && _cameraController!.value.isInitialized) {
        try {
          await _cameraController!.startVideoRecording();
          provider.startRecording();
          WakelockPlus.enable();
        } catch (e) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('录制启动失败: $e'), behavior: SnackBarBehavior.floating),
            );
          }
        }
      } else {
        // 无摄像头时使用模拟模式
        provider.startRecording();
        WakelockPlus.enable();
      }
    }
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    final currentIndex = _cameras.indexOf(_cameraController!.description);
    final nextIndex = (currentIndex + 1) % _cameras.length;
    await _cameraController?.dispose();
    setState(() => _isCameraReady = false);
    _cameraController = CameraController(
      _cameras[nextIndex],
      ResolutionPreset.high,
      enableAudio: true,
    );
    await _cameraController!.initialize();
    if (mounted) setState(() => _isCameraReady = true);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RecordingProvider>(
      builder: (context, recording, _) {
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
                      Row(
                        children: [
                          if (recording.isRecording) ...[
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            recording.isRecording ? 'REC ${_formatDuration(recording.duration)}' : '录制',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: recording.isRecording ? AppColors.error : Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.switch_camera, color: Colors.white),
                        onPressed: _switchCamera,
                      ),
                    ],
                  ),
                ),

                // Camera Preview
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Stack(
                        children: [
                          // Camera or Placeholder
                          if (_isCameraReady && _cameraController != null)
                            CameraPreview(_cameraController!)
                          else
                            Center(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.videocam, size: 64, color: Colors.white24),
                                  const SizedBox(height: 12),
                                  Text(
                                    _cameraError.isEmpty ? '正在初始化摄像头...' : _cameraError,
                                    style: const TextStyle(color: Colors.white38, fontSize: 14),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),

                          // Real-time analysis overlay
                          if (recording.isRecording) ...[
                            // Speed indicator
                            Positioned(
                              top: 12,
                              right: 12,
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
                                      recording.currentSpeed > 0 ? '${recording.currentSpeed.round()}' : '--',
                                      style: const TextStyle(fontSize: 36, fontWeight: FontWeight.w700, color: Colors.white),
                                    ),
                                    const Text('km/h', style: TextStyle(fontSize: 12, color: Colors.white54)),
                                  ],
                                ),
                              ),
                            ),

                            // Shot count
                            Positioned(
                              top: 12,
                              left: 12,
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
                                    Text('${recording.shotCount}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white)),
                                  ],
                                ),
                              ),
                            ),

                            // Pose overlay (AI placeholder)
                            const Positioned(
                              bottom: 12,
                              right: 12,
                              child: PoseOverlayMini(),
                            ),

                            // Recording indicator
                            Positioned(
                              bottom: 12,
                              left: 12,
                              child: Row(
                                children: [
                                  Container(
                                    width: 10,
                                    height: 10,
                                    decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    _formatDuration(recording.duration),
                                    style: const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
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
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('从相册选择视频'), behavior: SnackBarBehavior.floating),
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.photo_library, color: Colors.white, size: 24),
                        ),
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
                              width: recording.isRecording ? 28 : 56,
                              height: recording.isRecording ? 28 : 56,
                              decoration: BoxDecoration(
                                color: AppColors.error,
                                borderRadius: recording.isRecording ? BorderRadius.circular(6) : null,
                                shape: recording.isRecording ? BoxShape.rectangle : BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // AI Analysis
                      GestureDetector(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('AI分析将在录制结束后自动进行'), behavior: SnackBarBehavior.floating),
                          );
                        },
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.auto_awesome, color: Colors.white, size: 24),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }
}
