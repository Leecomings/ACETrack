import 'package:flutter/material.dart';
import '../models/tennis_data.dart';

/// 视频切片卡片 - 用于回放页面展示每个击球片段
class VideoClipCard extends StatelessWidget {
  final VideoClip clip;
  final VoidCallback? onTap;
  final VoidCallback? onShare;
  final VoidCallback? onDelete;

  const VideoClipCard({
    super.key,
    required this.clip,
    this.onTap,
    this.onShare,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 缩略图
              _buildThumbnail(),
              const SizedBox(width: 12),
              // 信息区
              Expanded(child: _buildInfo()),
              // 操作按钮
              _buildActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThumbnail() {
    return Container(
      width: 100,
      height: 68,
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          // 模拟缩略图
          const Center(
            child: Icon(Icons.play_circle_outline, color: Colors.white54, size: 32),
          ),
          // 时长标签
          Positioned(
            right: 4,
            bottom: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                _formatDuration(clip.duration),
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          // 击球类型角标
          Positioned(
            left: 4,
            top: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: _getShotColor(clip.shotType).withOpacity(0.9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                clip.shotType,
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          clip.title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.speed, size: 14, color: Colors.orange[400]),
            const SizedBox(width: 4),
            Text(
              '${clip.ballSpeed.toStringAsFixed(0)} km/h',
              style: TextStyle(fontSize: 12, color: Colors.orange[400]),
            ),
            const SizedBox(width: 12),
            Icon(Icons.sports_tennis, size: 14, color: Colors.green[400]),
            const SizedBox(width: 4),
            Text(
              clip.spinType,
              style: TextStyle(fontSize: 12, color: Colors.green[400]),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.access_time, size: 12, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Text(
              _formatTimestamp(clip.timestamp),
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
            const SizedBox(width: 12),
            Icon(Icons.place, size: 12, color: Colors.grey[500]),
            const SizedBox(width: 4),
            Text(
              clip.landingZone,
              style: TextStyle(fontSize: 11, color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.share, size: 18),
          onPressed: onShare,
          tooltip: '分享',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
        IconButton(
          icon: Icon(Icons.delete_outline, size: 18, color: Colors.red[300]),
          onPressed: onDelete,
          tooltip: '删除',
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
        ),
      ],
    );
  }

  Color _getShotColor(String shotType) {
    switch (shotType) {
      case '正手':
        return Colors.blue;
      case '反手':
        return Colors.purple;
      case '发球':
        return Colors.orange;
      case '截击':
        return Colors.teal;
      case '切削':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  String _formatDuration(double seconds) {
    final m = (seconds / 60).floor();
    final s = (seconds % 60).round();
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  String _formatTimestamp(DateTime dt) {
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}';
  }
}

/// 视频切片时间轴 - 用于录制页面底部展示
class VideoClipTimeline extends StatelessWidget {
  final List<VideoClip> clips;
  final int currentClipIndex;
  final ValueChanged<int>? onClipTap;
  final Duration totalDuration;

  const VideoClipTimeline({
    super.key,
    required this.clips,
    this.currentClipIndex = -1,
    this.onClipTap,
    required this.totalDuration,
  });

  @override
  Widget build(BuildContext context) {
    if (clips.isEmpty) {
      return const SizedBox.shrink();
    }

    final totalMs = totalDuration.inMilliseconds.toDouble();

    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          // 基线
          Positioned(
            left: 0,
            right: 0,
            top: 20,
            child: Container(height: 2, color: Colors.white24),
          ),
          // 切片标记
          ...List.generate(clips.length, (i) {
            final clip = clips[i];
            final startRatio = clip.startTime.inMilliseconds / totalMs;
            final endRatio = (clip.startTime.inMilliseconds + (clip.duration * 1000)) / totalMs;
            final isActive = i == currentClipIndex;

            return Positioned(
              left: startRatio * MediaQuery.of(context).size.width,
              top: 12,
              child: GestureDetector(
                onTap: () => onClipTap?.call(i),
                child: Container(
                  width: ((endRatio - startRatio) * MediaQuery.of(context).size.width).clamp(8, 80).toDouble(),
                  height: 16,
                  decoration: BoxDecoration(
                    color: isActive ? Colors.greenAccent : Colors.blueAccent.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(4),
                    border: isActive ? Border.all(color: Colors.white, width: 1.5) : null,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    clip.shotType,
                    style: const TextStyle(color: Colors.white, fontSize: 8),
                    overflow: TextOverflow.clip,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
