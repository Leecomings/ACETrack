# ACETrack

AI 驱动的网球训练分析应用，功能对标 SwingVision。

## 核心功能

| 功能 | 说明 |
|------|------|
| 🎾 球落点监测 | 实时检测网球落点，标记在半场示意图上 |
| ⚡ 球速检测 | 实时显示击球球速（km/h） |
| 🧍 姿态分析 | 骨骼关键点检测，分析挥拍轨迹、身体平衡、击球点高度 |
| 📊 全局计分 | 支持标准网球计分规则（0/15/30/40/Deuce/Ad/Game/Set/Match） |
| 🎬 实时录制 | 摄像头实时录制 + AI 分析覆盖层 |
| 📹 视频切片 | 对局自动切割为短视频，按击球类型标签分类 |
| 📈 数据复盘 | 历史数据统计、姿态分析报告 |

## 技术栈

- **框架**: Flutter (Dart)
- **状态管理**: Provider
- **摄像头**: camera
- **视频**: video_player
- **网络**: dio
- **构建**: GitHub Actions 云编译

## 项目结构

```
lib/
├── main.dart                    # 应用入口
├── models/
│   └── tennis_data.dart         # 数据模型
├── screens/
│   ├── splash_screen.dart       # 启动页
│   ├── login_screen.dart        # 登录页
│   ├── main_screen.dart         # 主框架（5 Tab）
│   ├── home_screen.dart         # 首页（实时监测）
│   ├── recording_screen.dart    # 录制页
│   ├── scoring_screen.dart      # 计分页
│   ├── video_screen.dart        # 回放页
│   ├── analysis_screen.dart     # 分析页
│   └── profile_screen.dart      # 个人中心
├── services/
│   ├── ai_service.dart          # AI 大模型接口服务（预留）
│   ├── scoring_provider.dart    # 计分状态管理
│   └── recording_provider.dart  # 录制状态管理
├── widgets/
│   ├── pose_overlay.dart        # 姿态骨骼覆盖层
│   └── video_clip_card.dart     # 视频切片卡片
└── utils/
    ├── constants.dart           # 常量配置
    └── mock_data.dart           # 模拟数据
```

## 运行

```bash
cd iostennis
flutter pub get
flutter run
```

## GitHub 云编译 (iOS IPA)

1. 在 GitHub 仓库中创建 `.github/workflows/build.yml`
2. 配置 iOS 签名证书和 Provisioning Profile 为 GitHub Secrets
3. 推送代码即可触发自动构建

```yaml
# .github/workflows/build.yml 示例
name: Build iOS
on:
  push:
    branches: [main]
jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.24.0'
      - run: cd iostennis && flutter pub get
      - run: cd iostennis && flutter build ios --release --no-codesign
      # 如需签名，需配置证书和 profile
```

---

## 🔌 大模型接入方法

ACETrack 已在 `lib/services/ai_service.dart` 中预留了大模型 API 接口。当前所有分析返回**模拟数据**，你只需替换以下方法中的实现即可接入你的大模型。

### 需要替换的 API 方法

| 方法 | 功能 | 输入 | 输出 |
|------|------|------|------|
| `detectBallLanding()` | 球落点检测 | 视频帧 (Image) | `BallLandPoint` 列表 |
| `estimateBallSpeed()` | 球速估算 | 视频帧序列 | 球速 (km/h) |
| `analyzePose()` | 姿态分析 | 视频帧 | `PoseAnalysis` |
| `clipVideoSegments()` | 视频切片 | 完整视频 | `VideoClip` 列表 |
| `generateAdvice()` | AI 建议 | 分析数据 | 建议文本 |

### 接入步骤

#### 1. 配置 API 地址和密钥

在 `lib/services/ai_service.dart` 中修改：

```dart
class AIService {
  // ✏️ 替换为你的大模型 API 地址
  static const String baseUrl = 'https://your-llm-api.example.com';
  
  // ✏️ 替换为你的 API Key
  static const String apiKey = 'YOUR_API_KEY';
  
  final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    headers: {'Authorization': 'Bearer $apiKey'},
  ));
```

#### 2. 替换各方法实现

以**球落点检测**为例：

```dart
Future<List<BallLandPoint>> detectBallLanding(String frameBase64) async {
  try {
    final response = await _dio.post('/detect/ball-landing', data: {
      'frame': frameBase64,
    });
    
    // ✏️ 根据你的大模型返回格式解析
    return (response.data['points'] as List)
        .map((p) => BallLandPoint(
              x: p['x'].toDouble(),
              y: p['y'].toDouble(),
              isInBound: p['in_bound'] ?? true,
              timestamp: DateTime.now(),
            ))
        .toList();
  } catch (e) {
    // 降级到模拟数据
    return _mockBallLanding();
  }
}
```

以**姿态分析**为例：

```dart
Future<PoseAnalysis> analyzePose(String frameBase64) async {
  try {
    final response = await _dio.post('/analyze/pose', data: {
      'frame': frameBase64,
    });
    
    // ✏️ 根据你的大模型返回格式解析
    return PoseAnalysis(
      swingSpeed: response.data['swing_speed'].toDouble(),
      bodyBalance: response.data['body_balance'].toDouble(),
      contactHeight: response.data['contact_height'].toDouble(),
      followThrough: response.data['follow_through'].toDouble(),
      keypoints: (response.data['keypoints'] as List)
          .map((k) => Keypoint(
                x: k['x'].toDouble(),
                y: k['y'].toDouble(),
                confidence: k['confidence'].toDouble(),
                label: k['label'],
              ))
          .toList(),
    );
  } catch (e) {
    return _mockPoseAnalysis();
  }
}
```

#### 3. 视频流实时接入（高级）

如需实时分析摄像头帧：

```dart
// 在 recording_screen.dart 中，每 N 帧调用一次 AI 服务
// 建议间隔：200-500ms（根据模型推理速度调整）

Timer.periodic(Duration(milliseconds: 300), (timer) async {
  if (!isRecording) { timer.cancel(); return; }
  
  // 1. 从 camera 获取当前帧
  final image = await controller.captureFrame();
  final base64 = base64Encode(image);
  
  // 2. 并行请求多个 AI 接口
  final results = await Future.wait([
    aiService.detectBallLanding(base64),
    aiService.estimateBallSpeed(base64),
    aiService.analyzePose(base64),
  ]);
  
  // 3. 更新 UI 覆盖层
  setState(() {
    landPoints = results[0];
    ballSpeed = results[1];
    poseAnalysis = results[2];
  });
});
```

#### 4. 视频切片接入

录制结束后，将完整视频发送给大模型进行切片：

```dart
Future<List<VideoClip>> clipVideoSegments(String videoPath) async {
  try {
    final formData = FormData.fromMap({
      'video': await MultipartFile.fromFile(videoPath),
    });
    
    final response = await _dio.post('/clip/video', data: formData);
    
    return (response.data['clips'] as List)
        .map((c) => VideoClip(
              id: c['id'],
              title: c['title'],
              startTime: Duration(milliseconds: c['start_ms']),
              duration: c['duration_s'].toDouble(),
              shotType: c['shot_type'],
              ballSpeed: c['ball_speed'].toDouble(),
              spinType: c['spin_type'],
              landingZone: c['landing_zone'],
              timestamp: DateTime.parse(c['timestamp']),
            ))
        .toList();
  } catch (e) {
    return _mockVideoClips();
  }
}
```

### 数据模型参考

你的大模型 API 返回格式应尽量匹配以下模型（见 `lib/models/tennis_data.dart`）：

- `BallLandPoint` — 球落点 (x, y, 是否界内, 时间戳)
- `PoseAnalysis` — 姿态分析 (挥拍速度, 身体平衡, 击球高度, 随挥, 关键点)
- `VideoClip` — 视频切片 (起止时间, 击球类型, 球速, 旋转, 落区)
- `TennisScore` — 比分 (分/局/盘, Deuce/Adv 状态)

如果不匹配，只需修改 `ai_service.dart` 中对应的解析逻辑即可。

## 许可

MIT License
