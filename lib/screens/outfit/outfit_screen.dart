import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';

class OutfitScreen extends ConsumerWidget {
  const OutfitScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfits = ref.watch(outfitsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('穿搭方案')),
      body: outfits.isEmpty
          ? Center(child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.auto_awesome_outlined, size: 80, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text('还没有保存的穿搭方案', style: TextStyle(color: Colors.grey[500])),
                const SizedBox(height: 8),
                Text('在「今日推荐」里点击"穿这套"就能保存', style: TextStyle(color: Colors.grey[400], fontSize: 13)),
              ],
            ))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: outfits.length,
              itemBuilder: (_, i) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(16),
                  title: Text(outfits[i].name, style: const TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                        child: Text(outfits[i].occasion.label, style: const TextStyle(fontSize: 11)),
                      ),
                      const SizedBox(width: 8),
                      Text('穿着 ${outfits[i].wearCount} 次'),
                    ]),
                  ),
                  trailing: outfits[i].isFavorite ? const Icon(Icons.favorite, color: Colors.red, size: 20) : const Icon(Icons.favorite_border, size: 20),
                  onTap: () {},
                ),
              ),
            ),
    );
  }
}
