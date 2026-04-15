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

  VideoClip({
    required this.id,
    required this.timeRange,
    required this.duration,
    required this.title,
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
