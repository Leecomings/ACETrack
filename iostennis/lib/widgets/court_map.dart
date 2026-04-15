import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../utils/mock_data.dart';

/// 网球场落点分布热力图组件
/// 复刻Android端的court-map自定义组件
class CourtMapWidget extends StatelessWidget {
  final bool showDots;

  const CourtMapWidget({super.key, this.showDots = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // 标题行
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    '实时落点',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.circle, size: 6, color: AppColors.success),
                    SizedBox(width: 4),
                    Text('实时', style: TextStyle(fontSize: 11, color: AppColors.success)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 球场图
          AspectRatio(
            aspectRatio: 1.5,
            child: CustomPaint(
              painter: CourtPainter(
                landingPoints: MockData.landingZones,
                showDots: showDots,
              ),
              size: Size.infinite,
            ),
          ),
          const SizedBox(height: 8),
          // 图例
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _legendItem(Colors.red, '高密度'),
              const SizedBox(width: 12),
              _legendItem(Colors.orange, '中密度'),
              const SizedBox(width: 12),
              _legendItem(Colors.blue.withOpacity(0.6), '低密度'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
      ],
    );
  }
}

/// 球场绘制器 - 绘制网球场标线和落点
class CourtPainter extends CustomPainter {
  final List<Map<String, dynamic>> landingPoints;
  final bool showDots;

  CourtPainter({required this.landingPoints, this.showDots = false});

  @override
  void paint(Canvas canvas, Size size) {
    final courtPaint = Paint()
      ..color = AppColors.courtGreen
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = AppColors.courtLine
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final netPaint = Paint()
      ..color = AppColors.courtNet
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    // 球场区域边距
    final margin = size.width * 0.06;
    final courtW = size.width - margin * 2;
    final courtH = size.height - margin * 2;
    final left = margin;
    final top = margin;
    final right = left + courtW;
    final bottom = top + courtH;

    // 绘制球场背景
    final courtRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, top, courtW, courtH),
      const Radius.circular(4),
    );
    canvas.drawRRect(courtRect, courtPaint);

    // 双打边线区域（左右各10%宽度）
    final doublesMargin = courtW * 0.10;

    // 单打边线
    final singleLeft = left + doublesMargin;
    final singleRight = right - doublesMargin;

    // 发球线位置（上下各25%）
    final serviceTop = top + courtH * 0.25;
    final serviceBottom = bottom - courtH * 0.25;
    final centerX = left + courtW / 2;

    // 绘制外边框
    canvas.drawRect(Rect.fromLTWH(left, top, courtW, courtH), linePaint);

    // 绘制双打边线
    canvas.drawLine(Offset(singleLeft, top), Offset(singleLeft, bottom), linePaint);
    canvas.drawLine(Offset(singleRight, top), Offset(singleRight, bottom), linePaint);

    // 绘制中线（发球区分隔线）
    canvas.drawLine(Offset(singleLeft, serviceTop), Offset(singleRight, serviceTop), linePaint);
    canvas.drawLine(Offset(singleLeft, serviceBottom), Offset(singleRight, serviceBottom), linePaint);

    // 绘制中间T字线
    canvas.drawLine(Offset(centerX, serviceTop), Offset(centerX, serviceBottom), linePaint);

    // 绘制球网
    canvas.drawLine(Offset(left, (top + bottom) / 2), Offset(right, (top + bottom) / 2), netPaint);

    // 绘制球网支柱
    final postSize = 4.0;
    canvas.drawCircle(Offset(left - 2, (top + bottom) / 2), postSize, linePaint..style = PaintingStyle.fill);
    canvas.drawCircle(Offset(right + 2, (top + bottom) / 2), postSize, linePaint..style = PaintingStyle.fill);
    linePaint.style = PaintingStyle.stroke;

    // 绘制落点
    if (showDots) {
      for (final point in landingPoints) {
        final px = left + (point['left'] as double) / 100 * courtW;
        final py = top + (point['top'] as double) / 100 * courtH;
        final intensity = point['intensity'] as String;

        Color dotColor;
        double dotRadius;
        switch (intensity) {
          case 'high':
            dotColor = Colors.red.withOpacity(0.7);
            dotRadius = 6;
            break;
          case 'medium':
            dotColor = Colors.orange.withOpacity(0.6);
            dotRadius = 5;
            break;
          default:
            dotColor = Colors.blue.withOpacity(0.5);
            dotRadius = 4;
        }

        // 绘制光晕
        canvas.drawCircle(
          Offset(px, py),
          dotRadius + 3,
          Paint()..color = dotColor.withOpacity(0.2)..style = PaintingStyle.fill,
        );
        // 绘制点
        canvas.drawCircle(
          Offset(px, py),
          dotRadius,
          Paint()..color = dotColor..style = PaintingStyle.fill,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CourtPainter oldDelegate) {
    return landingPoints != oldDelegate.landingPoints;
  }
}
