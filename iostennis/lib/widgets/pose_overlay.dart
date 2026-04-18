import 'package:flutter/material.dart';
import '../models/tennis_data.dart';

/// 姿态检测覆盖层 - 在摄像头画面上叠加骨骼/关键点
class PoseOverlay extends StatelessWidget {
  final PoseAnalysis? poseAnalysis;
  final bool showSkeleton;
  final bool showLabels;

  const PoseOverlay({
    super.key,
    this.poseAnalysis,
    this.showSkeleton = true,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    if (poseAnalysis == null) {
      return const SizedBox.shrink();
    }

    return CustomPaint(
      painter: _PosePainter(
        poseAnalysis: poseAnalysis!,
        showSkeleton: showSkeleton,
        showLabels: showLabels,
      ),
      size: Size.infinite,
    );
  }
}

class _PosePainter extends CustomPainter {
  final PoseAnalysis poseAnalysis;
  final bool showSkeleton;
  final bool showLabels;

  _PosePainter({
    required this.poseAnalysis,
    required this.showSkeleton,
    required this.showLabels,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (showSkeleton) {
      _drawSkeleton(canvas, size);
    }
    if (showLabels) {
      _drawLabels(canvas, size);
    }
  }

  void _drawSkeleton(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke;

    final jointPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    // 模拟关键点 (归一化坐标 0-1)
    final keypoints = _getMockKeypoints();

    // 绘制骨骼连线
    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4], // 头 -> 右臂
      [1, 5], [5, 6], [6, 7], // 左臂
      [1, 8], [8, 9], [9, 10], // 右腿
      [1, 11], [11, 12], [12, 13], // 左腿
    ];

    for (final conn in connections) {
      final p1 = keypoints[conn[0]];
      final p2 = keypoints[conn[1]];
      canvas.drawLine(
        Offset(p1[0] * size.width, p1[1] * size.height),
        Offset(p2[0] * size.width, p2[1] * size.height),
        paint,
      );
    }

    // 绘制关节点
    for (final kp in keypoints) {
      canvas.drawCircle(
        Offset(kp[0] * size.width, kp[1] * size.height),
        5,
        jointPaint,
      );
    }
  }

  void _drawLabels(Canvas canvas, Size size) {
    // 绘制挥拍轨迹指示
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: 12,
      shadows: [Shadow(blurRadius: 2, color: Colors.black)],
    );

    final tp = TextPainter(
      text: TextSpan(
        text: '挥拍速度: ${poseAnalysis.swingSpeed.toStringAsFixed(1)} km/h',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(canvas, Offset(16, size.height - 80));

    final tp2 = TextPainter(
      text: TextSpan(
        text: '身体平衡: ${poseAnalysis.bodyBalance.toStringAsFixed(0)}%',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp2.paint(canvas, Offset(16, size.height - 60));

    final tp3 = TextPainter(
      text: TextSpan(
        text: '击球点高度: ${poseAnalysis.contactHeight.toStringAsFixed(1)} m',
        style: textStyle,
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp3.paint(canvas, Offset(16, size.height - 40));
  }

  List<List<double>> _getMockKeypoints() {
    // 14个关键点 [x, y] 归一化
    return [
      [0.5, 0.1],  // 0: 头顶
      [0.5, 0.2],  // 1: 颈部
      [0.6, 0.18], // 2: 右肩
      [0.7, 0.28], // 3: 右肘
      [0.65, 0.38], // 4: 右手(持拍)
      [0.4, 0.18], // 5: 左肩
      [0.3, 0.28], // 6: 左肘
      [0.25, 0.38], // 7: 左手
      [0.55, 0.45], // 8: 右髋
      [0.58, 0.62], // 9: 右膝
      [0.57, 0.8],  // 10: 右脚
      [0.45, 0.45], // 11: 左髋
      [0.42, 0.62], // 12: 左膝
      [0.43, 0.8],  // 13: 左脚
    ];
  }

  @override
  bool shouldRepaint(covariant _PosePainter oldDelegate) {
    return oldDelegate.poseAnalysis != poseAnalysis;
  }
}

/// 球落点标记覆盖层
class BallLandOverlay extends StatelessWidget {
  final List<BallLandPoint> landPoints;
  final bool showHeatMap;

  const BallLandOverlay({
    super.key,
    required this.landPoints,
    this.showHeatMap = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _BallLandPainter(
        landPoints: landPoints,
        showHeatMap: showHeatMap,
      ),
      size: Size.infinite,
    );
  }
}

class _BallLandPainter extends CustomPainter {
  final List<BallLandPoint> landPoints;
  final bool showHeatMap;

  _BallLandPainter({
    required this.landPoints,
    required this.showHeatMap,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 绘制半场区域
    final courtPaint = Paint()
      ..color = Colors.white.withOpacity(0.15)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    // 外框
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      courtPaint,
    );
    // 中线
    canvas.drawLine(
      Offset(size.width / 2, 0),
      Offset(size.width / 2, size.height),
      courtPaint,
    );
    // 发球线
    canvas.drawLine(
      Offset(0, size.height * 0.4),
      Offset(size.width, size.height * 0.4),
      courtPaint,
    );
    canvas.drawLine(
      Offset(0, size.height * 0.6),
      Offset(size.width, size.height * 0.6),
      courtPaint,
    );

    // 绘制落点
    for (int i = 0; i < landPoints.length; i++) {
      final point = landPoints[i];
      final color = point.isInBound ? Colors.greenAccent : Colors.redAccent;
      final offset = Offset(
        point.x * size.width,
        point.y * size.height,
      );

      final dotPaint = Paint()
        ..color = color.withOpacity(0.8)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(offset, showHeatMap ? 8 : 5, dotPaint);

      // 标记序号
      if (!showHeatMap) {
        final tp = TextPainter(
          text: TextSpan(
            text: '${i + 1}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout();
        tp.paint(canvas, Offset(offset.dx - 4, offset.dy - 5));
      }
    }
  }

  @override
  bool shouldRepaint(covariant _BallLandPainter oldDelegate) {
    return oldDelegate.landPoints != landPoints;
  }
}

/// 球速仪表盘覆盖层
class SpeedGaugeOverlay extends StatelessWidget {
  final double speedKmh;
  final double maxSpeed;

  const SpeedGaugeOverlay({
    super.key,
    required this.speedKmh,
    this.maxSpeed = 200,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _SpeedGaugePainter(
        speedKmh: speedKmh,
        maxSpeed: maxSpeed,
      ),
      size: const Size(120, 70),
    );
  }
}

/// 迷你姿态覆盖层 - 用于录制界面小窗显示
class PoseOverlayMini extends StatelessWidget {
  const PoseOverlayMini({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black54,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white24, width: 1),
      ),
      child: CustomPaint(
        painter: _MiniPosePainter(),
        size: Size.infinite,
      ),
    );
  }
}

class _MiniPosePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.greenAccent
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    final jointPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.fill;

    // 简化骨骼关键点
    final w = size.width;
    final h = size.height;
    final keypoints = [
      Offset(w * 0.5, h * 0.08),  // 头
      Offset(w * 0.5, h * 0.2),   // 颈
      Offset(w * 0.65, h * 0.18), // 右肩
      Offset(w * 0.75, h * 0.3),  // 右肘
      Offset(w * 0.7, h * 0.4),   // 右手
      Offset(w * 0.35, h * 0.18), // 左肩
      Offset(w * 0.25, h * 0.3),  // 左肘
      Offset(w * 0.3, h * 0.4),   // 左手
      Offset(w * 0.55, h * 0.45), // 右髋
      Offset(w * 0.58, h * 0.65), // 右膝
      Offset(w * 0.57, h * 0.85), // 右脚
      Offset(w * 0.45, h * 0.45), // 左髋
      Offset(w * 0.42, h * 0.65), // 左膝
      Offset(w * 0.43, h * 0.85), // 左脚
    ];

    // 连线
    final connections = [
      [0, 1], [1, 2], [2, 3], [3, 4],
      [1, 5], [5, 6], [6, 7],
      [1, 8], [8, 9], [9, 10],
      [1, 11], [11, 12], [12, 13],
    ];

    for (final conn in connections) {
      canvas.drawLine(keypoints[conn[0]], keypoints[conn[1]], paint);
    }

    // 关节点
    for (final kp in keypoints) {
      canvas.drawCircle(kp, 2.5, jointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SpeedGaugePainter extends CustomPainter {
  final double speedKmh;
  final double maxSpeed;

  _SpeedGaugePainter({required this.speedKmh, required this.maxSpeed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2 - 4;

    // 背景弧
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.3)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159, // pi
      3.14159, // pi
      false,
      bgPaint,
    );

    // 速度弧
    final ratio = (speedKmh / maxSpeed).clamp(0.0, 1.0);
    final speedColor = ratio < 0.5
        ? Colors.greenAccent
        : ratio < 0.8
            ? Colors.orangeAccent
            : Colors.redAccent;

    final speedPaint = Paint()
      ..color = speedColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      3.14159,
      3.14159 * ratio,
      false,
      speedPaint,
    );

    // 速度文字
    final tp = TextPainter(
      text: TextSpan(
        text: '${speedKmh.toStringAsFixed(0)}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    tp.paint(
      canvas,
      Offset(center.dx - tp.width / 2, center.dy - 28),
    );

    final unitTp = TextPainter(
      text: const TextSpan(
        text: 'km/h',
        style: TextStyle(color: Colors.white70, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    unitTp.paint(
      canvas,
      Offset(center.dx - unitTp.width / 2, center.dy - 12),
    );
  }

  @override
  bool shouldRepaint(covariant _SpeedGaugePainter oldDelegate) {
    return oldDelegate.speedKmh != speedKmh;
  }
}
