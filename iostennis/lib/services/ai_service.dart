import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// AI大模型接口服务 - 预留接口
/// 
/// 接入方式：
/// 1. 在 [baseUrl] 中设置你的大模型API地址
/// 2. 在 [apiKey] 中设置你的API密钥
/// 3. 各方法会调用对应的大模型能力接口
/// 4. 大模型应返回JSON格式的分析结果
/// 
/// 支持的分析能力：
/// - 落点检测：从视频帧中检测网球落点位置
/// - 球速估算：根据视频帧间距离计算球速
/// - 姿态分析：分析用户挥拍、移动等姿态
/// - 视频切片：智能识别比赛关键时刻并切割
/// - AI建议：基于训练数据生成改进建议
class AIService {
  // ============ 配置区域 - 修改此处接入你的大模型 ============
  
  /// 大模型API基础地址
  /// 示例：'https://your-model-api.com/v1'
  static String baseUrl = 'https://your-model-api.com/v1';
  
  /// API密钥
  static String apiKey = '';
  
  /// 模型名称（如使用OpenAI兼容接口）
  static String modelName = 'acetrack-v1';
  
  // ============ 配置区域结束 ============

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      };

  /// 落点检测 - 从视频帧检测网球落点
  /// 
  /// 输入：视频帧（Base64编码的图片列表）
  /// 输出：落点坐标列表 [{top, left, intensity, zone}]
  Future<List<Map<String, dynamic>>> detectLandingPoints(List<String> frames) async {
    try {
      final url = Uri.parse('$baseUrl/detect/landing');
      final res = await http.post(url, headers: _headers, body: jsonEncode({
        'frames': frames,
        'model': modelName,
      }));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['code'] == 0) {
        return List<Map<String, dynamic>>.from(data['data']['points']);
      }
      return _mockLandingPoints();
    } catch (_) {
      // 大模型未接入时返回模拟数据
      return _mockLandingPoints();
    }
  }

  /// 球速估算 - 根据视频帧计算球速
  /// 
  /// 输入：连续视频帧
  /// 输出：球速数据 {speed, timestamp, confidence}
  Future<Map<String, dynamic>> estimateBallSpeed(List<String> frames) async {
    try {
      final url = Uri.parse('$baseUrl/detect/speed');
      final res = await http.post(url, headers: _headers, body: jsonEncode({
        'frames': frames,
        'model': modelName,
      }));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['code'] == 0) return data['data'];
      return _mockSpeedData();
    } catch (_) {
      return _mockSpeedData();
    }
  }

  /// 姿态分析 - 分析用户击球姿态
  /// 
  /// 输入：视频帧序列
  /// 输出：姿态分析结果 {keypoints, swingScore, balanceScore, suggestions}
  Future<Map<String, dynamic>> analyzePose(List<String> frames) async {
    try {
      final url = Uri.parse('$baseUrl/analyze/pose');
      final res = await http.post(url, headers: _headers, body: jsonEncode({
        'frames': frames,
        'model': modelName,
      }));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['code'] == 0) return data['data'];
      return _mockPoseData();
    } catch (_) {
      return _mockPoseData();
    }
  }

  /// 视频智能切片 - 识别关键时刻并切割
  /// 
  /// 输入：完整视频文件路径
  /// 输出：切片列表 [{startTime, endTime, title, type, highlight}]
  Future<List<Map<String, dynamic>>> sliceVideo(String videoPath) async {
    try {
      final url = Uri.parse('$baseUrl/video/slice');
      final res = await http.post(url, headers: _headers, body: jsonEncode({
        'video_path': videoPath,
        'model': modelName,
      }));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['code'] == 0) {
        return List<Map<String, dynamic>>.from(data['data']['clips']);
      }
      return _mockVideoClips();
    } catch (_) {
      return _mockVideoClips();
    }
  }

  /// AI建议生成 - 基于训练数据生成改进建议
  /// 
  /// 输入：训练统计数据
  /// 输出：建议列表 [{title, desc, tag, priority}]
  Future<List<Map<String, dynamic>>> generateSuggestions(Map<String, dynamic> trainingData) async {
    try {
      final url = Uri.parse('$baseUrl/ai/suggestions');
      final res = await http.post(url, headers: _headers, body: jsonEncode({
        'training_data': trainingData,
        'model': modelName,
      }));
      final data = jsonDecode(res.body) as Map<String, dynamic>;
      if (data['code'] == 0) {
        return List<Map<String, dynamic>>.from(data['data']['suggestions']);
      }
      return _mockSuggestions();
    } catch (_) {
      return _mockSuggestions();
    }
  }

  // ============ 模拟数据（大模型未接入时使用） ============

  List<Map<String, dynamic>> _mockLandingPoints() {
    return List.generate(15, (i) => {
      'top': 10 + (i * 5.0) % 80,
      'left': 15 + (i * 7.0) % 70,
      'intensity': i % 3 == 0 ? 'high' : (i % 3 == 1 ? 'medium' : 'low'),
      'zone': i % 4 == 0 ? 'deep' : (i % 4 == 1 ? 'baseline' : 'service'),
    });
  }

  Map<String, dynamic> _mockSpeedData() {
    return {
      'speed': 85 + DateTime.now().millisecond % 80,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'confidence': 0.92,
    };
  }

  Map<String, dynamic> _mockPoseData() {
    return {
      'keypoints': <String, dynamic>{},
      'swingScore': 8.2,
      'balanceScore': 7.5,
      'hitPointScore': 6.8,
      'followThroughScore': 5.5,
      'suggestions': ['提升随挥完整性', '注意击球点高度'],
    };
  }

  List<Map<String, dynamic>> _mockVideoClips() {
    return [
      {'startTime': '0:00', 'endTime': '2:15', 'title': '热身阶段', 'type': 'warmup', 'highlight': false},
      {'startTime': '2:15', 'endTime': '5:30', 'title': '对拉训练', 'type': 'rally', 'highlight': true},
      {'startTime': '5:30', 'endTime': '8:00', 'title': '发球练习', 'type': 'serve', 'highlight': false},
      {'startTime': '8:00', 'endTime': '12:00', 'title': '高能多拍回合', 'type': 'rally', 'highlight': true},
      {'startTime': '12:00', 'endTime': '15:00', 'title': '放松整理', 'type': 'cooldown', 'highlight': false},
    ];
  }

  List<Map<String, dynamic>> _mockSuggestions() {
    return [
      {'title': '提升正手稳定性', 'desc': '正手失误率较高，建议加强挥拍节奏练习', 'tag': '重要', 'priority': 1},
      {'title': '增加发球力量', 'desc': '平均球速偏低，可尝试提高至 130+', 'tag': '建议', 'priority': 2},
      {'title': '改善落点控制', 'desc': '底线落点偏差较大，多练习定点击球', 'tag': '建议', 'priority': 2},
      {'title': '优化步法移动', 'desc': '侧向移动偏慢，建议加强滑步训练', 'tag': '提示', 'priority': 3},
    ];
  }
}
