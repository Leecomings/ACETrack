/// 核心数据模型定义

class TrainingData {
  final int totalShots;
  final double avgSpeed;
  final double winRate;
  final double trainingHours;
  final double shotsTrend;
  final double speedTrend;
  final double winRateTrend;
  final double hoursTrend;

  TrainingData({
    this.totalShots = 0,
    this.avgSpeed = 0,
    this.winRate = 0,
    this.trainingHours = 0,
    this.shotsTrend = 0,
    this.speedTrend = 0,
    this.winRateTrend = 0,
    this.hoursTrend = 0,
  });
}

class ShotTypeData {
  final String type;
  final String label;
  final int count;
  final int percent;
  final String colorClass;

  ShotTypeData({
    required this.type,
    required this.label,
    required this.count,
    required this.percent,
    required this.colorClass,
  });
}

class SkillScore {
  final String name;
  final double score;
  final String level;
  final String description;

  SkillScore({
    required this.name,
    required this.score,
    required this.level,
    required this.description,
  });
}

class LandingZone {
  final String zone;
  final double top;
  final double left;
  final int count;
  final String intensity;

  LandingZone({
    required this.zone,
    required this.top,
    required this.left,
    required this.count,
    required this.intensity,
  });
}

class TrainingSession {
  final String id;
  final String month;
  final int day;
  final String startTime;
  final String endTime;
  final int duration;
  final int totalShots;
  final int avgSpeed;
  final double winRate;

  TrainingSession({
    required this.id,
    required this.month,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.duration,
    required this.totalShots,
    required this.avgSpeed,
    required this.winRate,
  });
}

class ShotRecord {
  final String id;
  final int timestamp;
  final String timeDisplay;
  final String shotType;
  final String shotTypeLabel;
  final int? speed;
  final String zone;
  final String zoneLabel;
  final bool isWin;
  final String resultLabel;

  ShotRecord({
    required this.id,
    required this.timestamp,
    required this.timeDisplay,
    required this.shotType,
    required this.shotTypeLabel,
    this.speed,
    required this.zone,
    required this.zoneLabel,
    required this.isWin,
    required this.resultLabel,
  });
}

class SpeedData {
  final String time;
  final int speedA;
  final int speedB;
  final int round;

  SpeedData({
    required this.time,
    required this.speedA,
    required this.speedB,
    required this.round,
  });
}

class ScoreData {
  final int scoreA;
  final int scoreB;
  final String currentSet;
  final String status;

  ScoreData({
    required this.scoreA,
    required this.scoreB,
    required this.currentSet,
    required this.status,
  });
}

class VideoClip {
  final int id;
  final String timeRange;
  final String duration;
  final String title;
  final String? type;
  final bool? highlight;

  VideoClip({
    required this.id,
    required this.timeRange,
    required this.duration,
    required this.title,
    this.type,
    this.highlight,
  });
}

class AISuggestion {
  final String icon;
  final String title;
  final String desc;
  final String tag;

  AISuggestion({
    required this.icon,
    required this.title,
    required this.desc,
    required this.tag,
  });
}

/// 姿态分析数据
class PoseAnalysis {
  final double swingScore;
  final double balanceScore;
  final double hitPointScore;
  final double followThroughScore;
  final List<String> suggestions;
  final Map<String, dynamic>? keypoints;

  PoseAnalysis({
    this.swingScore = 0,
    this.balanceScore = 0,
    this.hitPointScore = 0,
    this.followThroughScore = 0,
    this.suggestions = const [],
    this.keypoints,
  });

  double get averageScore => (swingScore + balanceScore + hitPointScore + followThroughScore) / 4;
}

/// 录制事件
class RecordingEvent {
  final String type; // 'shot', 'landing', 'pose', 'recording_end'
  final int timestamp;
  final Map<String, dynamic> data;

  RecordingEvent({
    required this.type,
    required this.timestamp,
    required this.data,
  });
}

/// 网球计分数据
class TennisScore {
  final int setsA;
  final int setsB;
  final int gamesA;
  final int gamesB;
  final int pointsA;
  final int pointsB;
  final bool isServerA;

  TennisScore({
    this.setsA = 0,
    this.setsB = 0,
    this.gamesA = 0,
    this.gamesB = 0,
    this.pointsA = 0,
    this.pointsB = 0,
    this.isServerA = true,
  });

  String get pointLabel {
    const labels = ['0', '15', '30', '40'];
    if (pointsA >= 3 && pointsB >= 3) {
      if (pointsA == pointsB) return 'Deuce';
      return pointsA > pointsB ? 'Ad-A' : 'Ad-B';
    }
    return '${labels[pointsA.clamp(0, 3)]}-${labels[pointsB.clamp(0, 3)]}';
  }
}
