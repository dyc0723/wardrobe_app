import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/enums.dart';
import '../../models/clothing.dart';
import '../../providers/app_providers.dart';

class WardrobeScreen extends ConsumerStatefulWidget {
  const WardrobeScreen({super.key});
  @override
  ConsumerState<WardrobeScreen> createState() => _WardrobeScreenState();
}

class _WardrobeScreenState extends ConsumerState<WardrobeScreen> {
  Category? _selectedCat;

  @override
  Widget build(BuildContext context) {
    final items = ref.watch(wardrobeProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('我的衣橱'), actions: [
        IconButton(icon: const Icon(Icons.search), onPressed: () {}),
      ]),
      body: Column(children: [
        _catFilter(),
        if (items.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(children: [
              Text('共 ${items.length} 件', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
            ]),
          ),
        Expanded(child: _grid(items)),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add),
        label: const Text('添加衣服'),
      ),
    );
  }

  Widget _catFilter() => Container(
    height: 56,
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: ListView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _chip('全部', null, Icons.all_inclusive),
        ...Category.values.map((c) => _chip(c.label, c, _icon(c))),
      ],
    ),
  );

  Widget _chip(String label, Category? cat, IconData icon) {
    final sel = _selectedCat == cat;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        selected: sel,
        onSelected: (_) => setState(() => _selectedCat = cat),
        avatar: Icon(icon, size: 18),
        label: Text(label),
      ),
    );
  }

  Widget _grid(List<ClothingItem> items) {
    final filtered = _selectedCat != null ? items.where((e) => e.category == _selectedCat).toList() : items;
    if (filtered.isEmpty) {
      return Center(child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(filtered.isEmpty && _selectedCat != null ? '该分类还没有衣服' : '衣橱空空如也', style: TextStyle(color: Colors.grey[500])),
        ],
      ));
    }
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 0.75,
      ),
      itemCount: filtered.length,
      itemBuilder: (_, i) => _Card(item: filtered[i]),
    );
  }

  IconData _icon(Category c) {
    switch (c) {
      case Category.top: return Icons.checkroom;
      case Category.bottom: return Icons.accessibility_new;
      case Category.dress: return Icons.woman;
      case Category.jacket: return Icons.coat;
      case Category.shoes: return Icons.footprint;
      case Category.bag: return Icons.shopping_bag;
      case Category.accessory: return Icons.watch;
    }
  }
}

class _Card extends StatelessWidget {
  final ClothingItem item;
  const _Card({required this.item});
  @override
  Widget build(BuildContext context) => Card(
    child: InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {},
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: _hexColor(item.color.hex),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[200]!),
            ),
          ),
          const SizedBox(height: 8),
          Text(item.name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
          Text(item.color.label, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
          if (item.isFavorite) const Icon(Icons.favorite, size: 14, color: Colors.red),
        ],
      ),
    ),
  );

  Color _hexColor(String hex) {
    if (hex == 'multi' || hex == 'stripe' || hex == 'plaid') return Colors.grey[200]!;
    hex = hex.replaceAll('#', '');
    if (hex.length == 6) return Color(int.parse('FF$hex', radix: 16));
    return Colors.grey[200]!;
  }
}
