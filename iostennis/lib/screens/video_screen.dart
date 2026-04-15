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
  final _shotTypeOptions = ['全部', '正手', '反手', '发球'];

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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Text('视频回放', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
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
      height: 200,
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        children: [
          const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.play_circle_outline, size: 56, color: Colors.white54),
                SizedBox(height: 8),
                Text('点击播放视频', style: TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
          ),
          Positioned(
            bottom: 12,
            left: 16,
            right: 16,
            child: Row(
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
      ],
    );
  }

  Widget _buildClipList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('视频切片', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
        const SizedBox(height: 10),
        ...MockData.videoClips.asMap().entries.map((entry) {
          final i = entry.key;
          final clip = entry.value;
          final isSelected = _selectedClipIndex == i;
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
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: isSelected ? AppColors.primary : AppColors.bgGrey, borderRadius: BorderRadius.circular(10)),
                    child: Center(
                      child: Icon(Icons.play_arrow, color: isSelected ? Colors.white : AppColors.textSecondary, size: 22),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(clip['title'] as String, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: isSelected ? AppColors.primary : AppColors.textPrimary)),
                        const SizedBox(height: 2),
                        Text('${clip['timeRange']}  |  ${clip['duration']}', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                      ],
                    ),
                  ),
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
        Row(children: [Text('AI 智能建议', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)), const SizedBox(width: 6), Text('🤖', style: TextStyle(fontSize: 16))]),
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
