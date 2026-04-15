# iostennis - TennisEye iOS端

## 项目简介
TennisEye 网球鹰眼系统 iOS 客户端，基于 Flutter 框架开发，复刻 Android 端功能。

## 功能列表
1. **登录注册** - 手机号+密码登录注册系统
2. **首页（鹰眼实时）** - 实时落点分布图、球速记录表、比分板
3. **录制** - 摄像头录制训练视频，实时显示球速和击球数
4. **数据分析** - 核心指标、击球类型分布、落点热力图、训练趋势、技能评估
5. **视频回放** - 视频切片浏览、击球类型筛选、AI智能建议
6. **个人中心** - 用户信息、训练总览、训练记录、扫码绑定球场

## 技术栈
- Flutter 3.x (Dart 3.x)
- Provider 状态管理
- HTTP 网络请求
- SharedPreferences 本地存储
- Camera 相机录制
- fl_chart 图表
- CustomPaint 球场绘制

## 云编译方法
1. 将本文件夹上传到 Flutter 云编译平台（如 Codemagic、Bitrise、App Center）
2. 配置 iOS 签名证书和 Provisioning Profile
3. 运行 `flutter pub get` 获取依赖
4. 运行 `flutter build ios` 构建
5. 或在本地 Mac 上执行：
   ```bash
   cd iostennis
   flutter pub get
   cd ios
   pod install
   cd ..
   flutter run
   ```

## 项目结构
```
iostennis/
├── lib/
│   ├── main.dart           # 应用入口
│   ├── models/             # 数据模型
│   │   └── tennis_data.dart
│   ├── screens/            # 页面
│   │   ├── splash_screen.dart   # 启动页
│   │   ├── login_screen.dart    # 登录注册
│   │   ├── main_screen.dart     # 主导航
│   │   ├── home_screen.dart     # 首页
│   │   ├── analysis_screen.dart # 数据分析
│   │   ├── video_screen.dart    # 视频回放
│   │   ├── recording_screen.dart # 录制
│   │   └── profile_screen.dart  # 个人中心
│   ├── services/           # 服务层
│   │   ├── api_service.dart     # API服务
│   │   └── auth_provider.dart   # 认证状态
│   ├── utils/              # 工具类
│   │   ├── constants.dart       # 常量定义
│   │   └── mock_data.dart       # 模拟数据
│   └── widgets/            # 组件
│       ├── court_map.dart       # 球场落点图
│       ├── score_board.dart     # 比分板
│       └── speed_table.dart     # 球速记录表
├── ios/                    # iOS配置
├── assets/                 # 静态资源
├── test/                   # 测试
└── pubspec.yaml            # 依赖配置
```

## API 接口
后端服务地址: `http://47.99.192.50:3000/api`
- POST `/auth/login` - 登录
- POST `/auth/register` - 注册
- GET `/user/info` - 获取用户信息
- POST `/friend/find-by-code` - 查找球友
- GET `/friend/list` - 球友列表
