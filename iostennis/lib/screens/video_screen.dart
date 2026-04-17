import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/mock_data.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({super.key});

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  int _selectedClipIndex = 0;
  int _shotTypeIndex = 0;
  bool _isPlaying = false;
  final _shotTypeOptions = ['全部', '正手', '反手', '发球', '截击', '高压'];

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
                child: Text('视频复盘', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
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
                      // 视频预览区
                      _buildVideoPreview(),
                      const SizedBox(height: 16),

                      // 筛选栏
                      _buildFilters(),
                      const SizedBox(height: 16),

                      // 视频切片列表
                      _buildClipList(),
                      const SizedBox(height: 16),

                      // AI建议
                      _buildAISuggestions(),
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

  Widget _buildVideoPreview() {
    return Container(
      height: 220,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          // Video player placeholder
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isPlaying = !_isPlaying),
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPlaying ? Icons.pause : Icons.play_arrow,
                      size: 36,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _isPlaying ? '播放中...' : '点击播放视频',
                  style: const TextStyle(color: Colors.white54, fontSize: 14),
                ),
              ],
            ),
          ),

          // Speed indicator on video
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.speed, color: AppColors.warning, size: 14),
                  SizedBox(width: 4),
                  Text('142 km/h', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),

          // Shot type badge
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.forehand.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text('正手', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600)),
            ),
          ),

          // Progress bar
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Row(
                  children: [
                    Text('00:00', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(value: 0.3, backgroundColor: Colors.white24, valueColor: const AlwaysStoppedAnimation(AppColors.primary), minHeight: 3),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text('15:32', style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 8),
                // Clip markers
                SizedBox(
                  height: 16,
                  child: Stack(
                    children: [
                      Container(decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(2))),
                      // Clip segments
                      Positioned(left: 0, width: 60, top: 2, bottom: 2, child: Container(decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.4), borderRadius: BorderRadius.circular(2)))),
                      Positioned(left: 80, width: 40, top: 2, bottom: 2, child: Container(decoration: BoxDecoration(color: AppColors.success.withOpacity(0.4), borderRadius: BorderRadius.circular(2)))),
                      Positioned(left: 140, width: 80, top: 2, bottom: 2, child: Container(decoration: BoxDecoration(color: AppColors.warning.withOpacity(0.4), borderRadius: BorderRadius.circular(2)))),
                      Positioned(left: 240, width: 60, top: 2, bottom: 2, child: Container(decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.4), borderRadius: BorderRadius.circular(2)))),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                value: _shotTypeIndex,
                isExpanded: true,
                items: _shotTypeOptions.asMap().entries.map((e) => DropdownMenuItem(value: e.key, child: Text(e.value, style: const TextStyle(fontSize: 13)))).toList(),
                onChanged: (v) => setState(() => _shotTypeIndex = v ?? 0),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(children: [Icon(Icons.calendar_today, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), Text('4月11日', style: TextStyle(fontSize: 13, color: AppColors.textSecondary))]),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
          child: Row(children: [Icon(Icons.sort, size: 16, color: AppColors.textSecondary), const SizedBox(width: 6), Text('最新', style: TextStyle(fontSize: 13, color: AppColors.textSecondary))]),
        ),
      ],
    );
  }

  Widget _buildClipList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('智能切片', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(8)),
              child: const Row(
                children: [
                  Icon(Icons.auto_awesome, size: 12, color: AppColors.primary),
                  SizedBox(width: 4),
                  Text('AI自动切割', style: TextStyle(fontSize: 11, color: AppColors.primary)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ...MockData.videoClips.asMap().entries.map((entry) {
          final i = entry.key;
          final clip = entry.value;
          final isSelected = _selectedClipIndex == i;
          final colors = [AppColors.primary, AppColors.success, AppColors.warning, AppColors.accent, AppColors.info];
          final color = colors[i % colors.length];
          return GestureDetector(
            onTap: () => setState(() => _selectedClipIndex = i),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBg : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: isSelected ? Border.all(color: AppColors.primary, width: 1.5) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? LinearGradient(colors: [color, color.withOpacity(0.7)])
                          : null,
                      color: isSelected ? null : AppColors.bgGrey,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.play_arrow, color: isSelected ? Colors.white : AppColors.textSecondary, size: 20),
                          Text(clip['duration'] as String, style: TextStyle(fontSize: 9, color: isSelected ? Colors.white70 : AppColors.textSecondary)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(clip['title'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text('${clip['timeRange']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
                  if (isSelected)
                    const Icon(Icons.check_circle, color: AppColors.primary, size: 20),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildAISuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [const Text('AI 智能建议', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), const SizedBox(width: 6), const Text('🤖', style: TextStyle(fontSize: 16))]),
        const SizedBox(height: 10),
        ...MockData.aiSuggestions.map((s) {
          final tagColors = {'重要': AppColors.error, '建议': AppColors.warning, '提示': AppColors.info};
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s['icon'] as String, style: const TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(s['title'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: (tagColors[s['tag']] ?? AppColors.info).withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
                            child: Text(s['tag'] as String, style: TextStyle(fontSize: 10, color: tagColors[s['tag']] ?? AppColors.info, fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(s['desc'] as String, style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    ],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
