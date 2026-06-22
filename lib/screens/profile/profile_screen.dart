import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('我的'), actions: [
        IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
      ]),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(children: [
                CircleAvatar(
                  radius: 36,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Icon(Icons.person, size: 36, color: theme.colorScheme.primary),
                ),
                const SizedBox(width: 16),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(user?.nickname ?? '未设置昵称', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(user?.email ?? '', style: TextStyle(color: Colors.grey[500], fontSize: 13)),
                  ],
                )),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ]),
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                _stat('0', '衣物'),
                _stat('0', '穿搭方案'),
                _stat('0', '今日打卡'),
              ]),
            ),
          ),
          const SizedBox(height: 16),
          _item(theme, Icons.style, '风格偏好', () {}),
          _item(theme, Icons.straighten, '身体信息', () {}),
          _item(theme, Icons.bar_chart, '衣橱统计', () {}),
          _item(theme, Icons.cloud, '天气设置', () {}),
          Divider(color: Colors.grey[200]),
          _item(theme, Icons.logout, '退出登录', () async {
            await ref.read(authProvider.notifier).signOut();
          }, red: true),
        ],
      ),
    );
  }

  Widget _stat(String v, String l) => Column(children: [
    Text(v, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
    Text(l, style: TextStyle(fontSize: 13, color: Colors.grey[500])),
  ]);

  Widget _item(ThemeData theme, IconData icon, String title, VoidCallback onTap, {bool red = false}) => ListTile(
    leading: Icon(icon, color: red ? Colors.red : theme.colorScheme.primary),
    title: Text(title, style: TextStyle(color: red ? Colors.red : null)),
    trailing: const Icon(Icons.chevron_right, size: 20),
    onTap: onTap,
  );
}
