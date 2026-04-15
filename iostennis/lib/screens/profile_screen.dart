import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_provider.dart';
import '../utils/constants.dart';
import '../utils/mock_data.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
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
                child: Text('我的', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
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
                      // 用户信息卡
                      _buildUserCard(auth),
                      const SizedBox(height: 16),

                      // 训练总览
                      _buildOverviewCard(),
                      const SizedBox(height: 16),

                      // 训练记录
                      _buildTrainingRecords(),
                      const SizedBox(height: 16),

                      // 菜单
                      _buildMenuItems(context, auth),
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

  Widget _buildUserCard(AuthProvider auth) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [AppColors.primary, Color(0xFF7B68EE)]),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
            child: const Center(child: Icon(Icons.person, size: 30, color: Colors.white)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(auth.nickname ?? '网球爱好者', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                      child: Text('Lv.${auth.level ?? 1}', style: const TextStyle(fontSize: 11, color: Colors.white)),
                    ),
                    const SizedBox(width: 8),
                    if (auth.myCode != null)
                      Text('邀请码: ${auth.myCode}', style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.7))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('训练总览', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              Text('4月1日 ~ 4月11日', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _overviewItem('12', '训练场次', AppColors.primary),
              _overviewItem('2,847', '总击球数', AppColors.backhand),
              _overviewItem('18.5h', '训练时长', AppColors.success),
              _overviewItem('118', '平均球速', AppColors.warning),
            ],
          ),
        ],
      ),
    );
  }

  Widget _overviewItem(String value, String label, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildTrainingRecords() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('训练记录', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
              Text('查看全部 ›', style: TextStyle(fontSize: 13, color: AppColors.primary)),
            ],
          ),
          const SizedBox(height: 12),
          ...MockData.trainingRecords.map((r) => _buildRecordItem(r)),
        ],
      ),
    );
  }

  Widget _buildRecordItem(Map<String, dynamic> r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.bgGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          // 日期
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: AppColors.primaryBg, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(r['month'] as String, style: const TextStyle(fontSize: 10, color: AppColors.primary)),
                Text('${r['day']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(r['timeRange'] as String, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('${r['duration']}分钟', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                    const SizedBox(width: 12),
                    Text('${r['hits']}次击球', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${r['avgSpeed']} km/h', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.primary)),
              Text('${r['scoreRate']}% 得分', style: TextStyle(fontSize: 11, color: AppColors.success)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context, AuthProvider auth) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          _menuItem(Icons.qr_code_scanner, '扫码绑定球场', () => Navigator.pushNamed(context, '/scan')),
          _menuItem(Icons.people, '球友', () {}),
          _menuItem(Icons.settings, '设置', () {}),
          _menuItem(Icons.help_outline, '帮助与反馈', () {}),
          _menuItem(Icons.info_outline, '关于', () {}),
          const Divider(height: 1),
          _menuItem(Icons.logout, '退出登录', () {
            auth.logout();
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => const LoginScreen()));
          }, color: AppColors.error),
        ],
      ),
    );
  }

  Widget _menuItem(IconData icon, String title, VoidCallback onTap, {Color? color}) {
    return ListTile(
      leading: Icon(icon, size: 22, color: color ?? AppColors.textSecondary),
      title: Text(title, style: TextStyle(fontSize: 15, color: color ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, size: 18, color: AppColors.textPlaceholder),
      onTap: onTap,
    );
  }
}
