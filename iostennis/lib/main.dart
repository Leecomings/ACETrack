import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/api_service.dart';
import 'services/auth_provider.dart';
import 'services/scoring_provider.dart';
import 'services/recording_provider.dart';
import 'services/ai_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  runApp(ACETrackApp(prefs: prefs));
}

class ACETrackApp extends StatelessWidget {
  final SharedPreferences prefs;
  const ACETrackApp({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<ApiService>(create: (_) => ApiService()),
        Provider<AIService>(create: (_) => AIService()),
        ChangeNotifierProvider<AuthProvider>(
          create: (_) => AuthProvider(prefs),
        ),
        ChangeNotifierProvider<ScoringProvider>(
          create: (_) => ScoringProvider(),
        ),
        ChangeNotifierProvider<RecordingProvider>(
          create: (_) => RecordingProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'ACETrack',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF1A73E8),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF1A73E8),
            primary: const Color(0xFF1A73E8),
            secondary: const Color(0xFFE94B3C),
          ),
          fontFamily: 'PingFang SC',
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1A73E8),
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          cardTheme: const CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1A73E8),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        home: const SplashScreen(),
        routes: {
          '/scan': (context) => const _ScanPlaceholderScreen(),
        },
      ),
    );
  }
}

/// 扫码占位页面 - 等待接入 mobile_scanner
class _ScanPlaceholderScreen extends StatelessWidget {
  const _ScanPlaceholderScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫码绑定球场')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.qr_code_scanner,
              size: 64,
              color: Color(0xFF1A73E8),
            ),
            const SizedBox(height: 16),
            const Text(
              '请扫描球场设备二维码',
              style: TextStyle(fontSize: 16, color: Color(0xFF666666)),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('返回'),
            ),
          ],
        ),
      ),
    );
  }
}
