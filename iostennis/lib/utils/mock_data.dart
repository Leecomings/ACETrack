import 'dart:math';

class MockData {
  static final speedData = [
    {'time': '5:20', 'speedA': 118, 'speedB': 105, 'round': 1},
    {'time': '5:18', 'speedA': 132, 'speedB': 98, 'round': 2},
    {'time': '4:30', 'speedA': 125, 'speedB': 112, 'round': 2},
    {'time': '4:15', 'speedA': 145, 'speedB': 120, 'round': 1},
    {'time': '3:45', 'speedA': 108, 'speedB': 135, 'round': 3},
    {'time': '3:30', 'speedA': 122, 'speedB': 128, 'round': 4},
    {'time': '3:10', 'speedA': 115, 'speedB': 102, 'round': 2},
    {'time': '2:55', 'speedA': 138, 'speedB': 118, 'round': 5},
  ];

  static final scoreData = {
    'scoreA': 3,
    'scoreB': 2,
    'currentSet': '第5局',
    'status': '进行中',
  };

  static final coreMetrics = {
    'totalShots': 1247,
    'avgSpeed': 118,
    'winRate': 67,
    'trainingHours': 12.5,
    'shotsTrend': 15.3,
    'speedTrend': -2.1,
    'winRateTrend': 8.5,
    'hoursTrend': 20.2,
  };

  static final shotTypeDistribution = [
    {'type': 'forehand', 'label': '正手击球', 'count': 520, 'percent': 42},
    {'type': 'backhand', 'label': '反手击球', 'count': 380, 'percent': 30},
    {'type': 'serve', 'label': '发球', 'count': 210, 'percent': 17},
    {'type': 'volley', 'label': '截击', 'count': 85, 'percent': 7},
    {'type': 'smash', 'label': '高压球', 'count': 52, 'percent': 4},
  ];

  static final skillScores = [
    {'name': '正手稳定性', 'score': 8.2, 'level': 'excellent', 'desc': '表现出色，继续保持！'},
    {'name': '反手技术', 'score': 6.5, 'level': 'good', 'desc': '表现良好，有提升空间'},
    {'name': '发球威力', 'score': 5.8, 'level': 'average', 'desc': '需要更多练习来提升'},
    {'name': '网前截击', 'score': 4.5, 'level': 'poor', 'desc': '建议加强针对性训练'},
    {'name': '步法移动', 'score': 7.1, 'level': 'good', 'desc': '表现良好，有提升空间'},
    {'name': '耐力水平', 'score': 7.8, 'level': 'good', 'desc': '表现良好，有提升空间'},
  ];

  static final landingZones = List.generate(35, (i) {
    final isDeep = Random().nextDouble() > 0.3;
    return {
      'zone': 'point-$i',
      'top': isDeep ? 10 + Random().nextDouble() * 25 : 40 + Random().nextDouble() * 45,
      'left': 10 + Random().nextDouble() * 80,
      'count': 1,
      'intensity': Random().nextDouble() > 0.6 ? 'medium' : 'low',
    };
  });

  static final trendData = List.generate(14, (i) {
    final now = DateTime.now();
    final date = now.subtract(Duration(days: 13 - i));
    return {
      'date': '${date.month}/${date.day}',
      'shots': 30 + Random().nextInt(150),
    };
  });

  static final trainingRecords = [
    {
      'id': '1',
      'month': '4月',
      'day': 11,
      'timeRange': '14:00 - 15:35',
      'duration': 95,
      'hits': 186,
      'avgSpeed': 118,
      'scoreRate': 68,
    },
    {
      'id': '2',
      'month': '4月',
      'day': 9,
      'timeRange': '09:30 - 11:00',
      'duration': 90,
      'hits': 234,
      'avgSpeed': 122,
      'scoreRate': 72,
    },
    {
      'id': '3',
      'month': '4月',
      'day': 7,
      'timeRange': '16:00 - 17:45',
      'duration': 105,
      'hits': 156,
      'avgSpeed': 112,
      'scoreRate': 65,
    },
  ];

  static final videoClips = [
    {'id': 1, 'timeRange': '14:00 - 14:15', 'duration': '15:32', 'title': '热身阶段'},
    {'id': 2, 'timeRange': '14:15 - 14:28', 'duration': '13:08', 'title': '对拉训练'},
    {'id': 3, 'timeRange': '14:28 - 14:35', 'duration': '07:45', 'title': '发球练习'},
    {'id': 4, 'timeRange': '14:35 - 14:50', 'duration': '15:10', 'title': '高能多拍回合'},
    {'id': 5, 'timeRange': '14:50 - 15:05', 'duration': '14:22', 'title': '放松整理'},
  ];

  static final aiSuggestions = [
    {'icon': '🎾', 'title': '提升正手稳定性', 'desc': '正手失误率较高，建议加强挥拍节奏练习', 'tag': '重要'},
    {'icon': '⚡', 'title': '增加发球力量', 'desc': '平均球速 118km/h，可尝试提高至 130+', 'tag': '建议'},
    {'icon': '🎯', 'title': '改善落点控制', 'desc': '底线落点偏差较大，多练习定点击球', 'tag': '建议'},
    {'icon': '🏃', 'title': '优化步法移动', 'desc': '侧向移动偏慢，建议加强滑步训练', 'tag': '提示'},
  ];

  static final sessionDetail = {
    'totalShots': 248,
    'avgSpeed': 115,
    'winRate': 68,
    'maxSpeed': 178,
  };

  static final shotTypes = [
    {'type': 'forehand', 'name': '正手', 'initial': '正', 'count': 104, 'percent': 42},
    {'type': 'backhand', 'name': '反手', 'initial': '反', 'count': 72, 'percent': 29},
    {'type': 'serve', 'name': '发球', 'initial': '发', 'count': 48, 'percent': 19},
    {'type': 'volley', 'name': '截击', 'initial': '截', 'count': 16, 'percent': 6},
    {'type': 'smash', 'name': '高压', 'initial': '高', 'count': 8, 'percent': 4},
  ];

  static final speedStats = {
    'avgSpeed': 115,
    'maxSpeed': 178,
    'forehandAvg': 122,
    'backhandAvg': 108,
  };

  static final scoreStats = {
    'winCount': 168,
    'faultCount': 80,
    'aceCount': 12,
    'unforcedError': 35,
    'winRate': 68,
  };
}
