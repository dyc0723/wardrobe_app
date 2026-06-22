import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../models/clothing.dart';
import '../../providers/app_providers.dart';
import '../wardrobe/wardrobe_screen.dart';
import '../outfit/outfit_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});
  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _tab = 0;
  bool _initialized = false;

  static const _pages = [
    _TodayPage(),
    WardrobeScreen(),
    OutfitScreen(),
    ProfileScreen(),
  ];

  void _loadInitialData() {
    if (_initialized) return;
    _initialized = true;
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      ref.read(wardrobeProvider.notifier).loadItems(user.id);
      ref.read(currentUserProvider.notifier).loadProfile(user.id);
      ref.read(outfitsProvider.notifier).loadOutfits(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadInitialData());
    return Scaffold(
      body: IndexedStack(index: _tab, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today_outlined), activeIcon: Icon(Icons.today), label: '今日推荐'),
          BottomNavigationBarItem(icon: Icon(Icons.checkroom_outlined), activeIcon: Icon(Icons.checkroom), label: '衣橱'),
          BottomNavigationBarItem(icon: Icon(Icons.auto_awesome_outlined), activeIcon: Icon(Icons.auto_awesome), label: '穿搭'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outlined), activeIcon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}

class _TodayPage extends ConsumerWidget {
  const _TodayPage();
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rec = ref.watch(todaysRecommendationProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('今日推荐'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '重新推荐',
            onPressed: () => ref.invalidate(todaysRecommendationProvider),
          ),
        ],
      ),
      body: rec.when(
        data: (o) => o.isEmpty ? _empty(context) : _list(context, o),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('出错: $e', style: const TextStyle(color: Colors.red))),
      ),
    );
  }

  Widget _empty(BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
        const SizedBox(height: 16),
        Text('衣橱还是空的', style: TextStyle(color: Colors.grey[500])),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.add),
          label: const Text('添加衣服'),
        ),
      ],
    ),
  );

  Widget _list(BuildContext context, List<List<ClothingItem>> outfits) => ListView.builder(
    padding: const EdgeInsets.all(16),
    itemCount: outfits.length,
    itemBuilder: (_, i) => _OutfitCard(outfit: outfits[i], index: i),
  );
}

class _OutfitCard extends StatelessWidget {
  final List<ClothingItem> outfit;
  final int index;
  const _OutfitCard({required this.outfit, required this.index});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('推荐 #', style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w600, fontSize: 12)),
              ),
              const Spacer(),
              IconButton(icon: const Icon(Icons.favorite_border, size: 20), onPressed: () {}),
            ]),
            const SizedBox(height: 12),
            SizedBox(
              height: 100,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: outfit.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) => _ItemTile(item: outfit[i]),
              ),
            ),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: OutlinedButton.icon(onPressed: () {}, icon: const Icon(Icons.swap_horiz, size: 18), label: const Text('换一件'))),
              const SizedBox(width: 8),
              Expanded(child: FilledButton.icon(onPressed: () {}, icon: const Icon(Icons.check, size: 18), label: const Text('穿这套'))),
            ]),
          ],
        ),
      ),
    );
  }
}

class _ItemTile extends StatelessWidget {
  final ClothingItem item;
  const _ItemTile({required this.item});
  @override
  Widget build(BuildContext context) => Container(
    width: 80,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            color: _parseColor(item.color.hex),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
        ),
        const SizedBox(height: 4),
        Text(item.category.label, style: const TextStyle(fontSize: 11)),
        Text(item.color.label, style: TextStyle(fontSize: 10, color: Colors.grey[500])),
      ],
    ),
  );

  Color _parseColor(String hex) {
    if (hex == 'multi' || hex == 'stripe' || hex == 'plaid') return Colors.grey[200]!;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) return Color(int.parse('FF', radix: 16));
    return Colors.grey[200]!;
  }
}



