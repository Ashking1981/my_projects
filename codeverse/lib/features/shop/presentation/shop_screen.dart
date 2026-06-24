import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/models/shop_item.dart';
import '../../../data/providers.dart';
import '../../../ui/ui.dart';

/// Spend coins on avatar/companion cosmetics. Purely cosmetic — no
/// gameplay effect, and nothing here is purchasable with real money
/// (that's the separate PRO unlock in the paywall feature).
class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final items = ref.watch(shopItemsProvider);
    final avatars =
        items.where((i) => i.category == ShopItemCategory.avatar).toList();
    final companions = items
        .where((i) => i.category == ShopItemCategory.companion)
        .toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              child: Center(child: CoinBadge(amount: profile.coins)),
            ),
          ],
          bottom: const TabBar(
            tabs: [Tab(text: 'Avatars'), Tab(text: 'Companions')],
          ),
        ),
        body: TabBarView(
          children: [
            _ItemGrid(items: avatars, category: ShopItemCategory.avatar),
            _ItemGrid(
                items: companions, category: ShopItemCategory.companion),
          ],
        ),
      ),
    );
  }
}

class _ItemGrid extends ConsumerWidget {
  const _ItemGrid({required this.items, required this.category});

  final List<ShopItem> items;
  final ShopItemCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(playerProfileProvider);
    final equippedId = category == ShopItemCategory.avatar
        ? profile.avatarId
        : profile.companionSkinId;

    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: AppSpacing.md,
        crossAxisSpacing: AppSpacing.md,
        childAspectRatio: 0.85,
      ),
      itemCount: items.length + 1,
      itemBuilder: (context, index) {
        if (index == 0) {
          return _DefaultCard(category: category, equipped: equippedId == 'default');
        }
        final item = items[index - 1];
        return _ItemCard(
          item: item,
          owned: profile.ownedItemIds.contains(item.id),
          equipped: equippedId == item.id,
          affordable: profile.coins >= item.cost,
        );
      },
    );
  }
}

class _DefaultCard extends ConsumerWidget {
  const _DefaultCard({required this.category, required this.equipped});

  final ShopItemCategory category;
  final bool equipped;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _Card(
      color: Colors.grey,
      icon: category == ShopItemCategory.avatar
          ? Icons.person_rounded
          : Icons.favorite_rounded,
      name: 'Default',
      equipped: equipped,
      footer: equipped
          ? const Text('Equipped')
          : PrimaryButton(
              label: 'Equip',
              onPressed: () =>
                  ref.read(playerProfileProvider.notifier).equipDefault(category),
            ),
    );
  }
}

class _ItemCard extends ConsumerWidget {
  const _ItemCard({
    required this.item,
    required this.owned,
    required this.equipped,
    required this.affordable,
  });

  final ShopItem item;
  final bool owned;
  final bool equipped;
  final bool affordable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(playerProfileProvider.notifier);
    return _Card(
      color: item.color,
      icon: item.icon,
      name: item.name,
      equipped: equipped,
      footer: equipped
          ? const Text('Equipped')
          : owned
              ? PrimaryButton(
                  label: 'Equip',
                  onPressed: () => notifier.equipItem(item),
                )
              : PrimaryButton(
                  label: '${item.cost} coins',
                  icon: Icons.circle,
                  onPressed: affordable
                      ? () => notifier.purchaseItem(item)
                      : null,
                ),
    );
  }
}

class _Card extends StatelessWidget {
  const _Card({
    required this.color,
    required this.icon,
    required this.name,
    required this.equipped,
    required this.footer,
  });

  final Color color;
  final IconData icon;
  final String name;
  final bool equipped;
  final Widget footer;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: AppElevation.card,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadii.md),
        side: equipped
            ? const BorderSide(color: AppColors.brandPrimary, width: 2)
            : BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.sm),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: color.withOpacity(0.2),
              radius: 32,
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(name, style: Theme.of(context).textTheme.titleSmall),
            const SizedBox(height: AppSpacing.xs),
            footer,
          ],
        ),
      ),
    );
  }
}
