import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:app/providers/provider_models/offer_model.dart';
import 'package:app/providers/provider_root/offers_provider.dart';
import 'package:app/widgets/offer_widgets.dart';
import 'package:app/widgets/skeleton_loader.dart';

class OffersScreen extends ConsumerStatefulWidget {
  const OffersScreen({super.key});

  @override
  ConsumerState<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends ConsumerState<OffersScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadOffers();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadOffers() async {
    await ref.read(offersProvider.notifier).loadOffers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offers'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
              icon: Icon(Icons.inbox_rounded),
              text: 'Received',
            ),
            Tab(
              icon: Icon(Icons.send_rounded),
              text: 'Sent',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ReceivedOffersTab(),
          _SentOffersTab(),
        ],
      ),
    );
  }
}

class _ReceivedOffersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(offersProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (offersState.isLoading) {
      return const ProductListSkeleton(itemCount: 5);
    }

    if (offersState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              offersState.error!,
              style: TextStyle(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => ref.read(offersProvider.notifier).loadOffers(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final receivedOffers = offersState.sellerOffers;
    final pendingOffers = receivedOffers
        .where((o) => o.status == OfferStatus.pending)
        .toList();
    final otherOffers = receivedOffers
        .where((o) => o.status != OfferStatus.pending)
        .toList();

    if (receivedOffers.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.inbox_outlined,
        title: 'No offers received',
        subtitle: 'When buyers make offers on your listings, they will appear here',
      );
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(offersProvider.notifier).loadOffers(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (pendingOffers.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              title: 'Pending (${pendingOffers.length})',
              icon: Icons.pending_actions,
              color: Colors.orange,
            ),
            const SizedBox(height: 8),
            ...pendingOffers.map((offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OfferCard(
                offer: offer,
                isOwner: true,
                onAccept: () => _handleAccept(context, ref, offer),
                onDecline: () => _handleDecline(context, ref, offer),
                onCounter: (amount, message) => _handleCounter(context, ref, offer, amount, message),
                onTap: () => _navigateToListing(context, offer),
              ),
            )),
            const SizedBox(height: 16),
          ],
          if (otherOffers.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              title: 'History (${otherOffers.length})',
              icon: Icons.history,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            ...otherOffers.map((offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OfferCard(
                offer: offer,
                isOwner: true,
                onTap: () => _navigateToListing(context, offer),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Future<void> _handleAccept(BuildContext context, WidgetRef ref, Offer offer) async {
    try {
      await ref.read(offersProvider.notifier).acceptOffer(offer.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer accepted!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleDecline(BuildContext context, WidgetRef ref, Offer offer) async {
    try {
      await ref.read(offersProvider.notifier).declineOffer(offer.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Offer declined'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to decline offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _handleCounter(
    BuildContext context,
    WidgetRef ref,
    Offer offer,
    double amount,
    String? message,
  ) async {
    try {
      await ref.read(offersProvider.notifier).counterOffer(
        offer.id,
        counterAmount: amount,
        message: message,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Counter offer sent!'),
            backgroundColor: Colors.blue,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to send counter offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToListing(BuildContext context, Offer offer) {
    if (offer.itemType == 'product') {
      context.push('/product/${offer.itemId}');
    } else {
      context.push('/service/${offer.itemId}');
    }
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _SentOffersTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offersState = ref.watch(offersProvider);
    final colorScheme = Theme.of(context).colorScheme;

    if (offersState.isLoading) {
      return const ProductListSkeleton(itemCount: 5);
    }

    if (offersState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: colorScheme.error),
            const SizedBox(height: 16),
            Text(
              offersState.error!,
              style: TextStyle(color: colorScheme.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => ref.read(offersProvider.notifier).loadOffers(),
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    final sentOffers = offersState.buyerOffers;

    if (sentOffers.isEmpty) {
      return _buildEmptyState(
        context,
        icon: Icons.send_outlined,
        title: 'No offers sent',
        subtitle: 'When you make offers on listings, they will appear here',
      );
    }

    final activeOffers = sentOffers
        .where((o) => o.status == OfferStatus.pending || o.status == OfferStatus.countered)
        .toList();
    final completedOffers = sentOffers
        .where((o) => o.status != OfferStatus.pending && o.status != OfferStatus.countered)
        .toList();

    return RefreshIndicator(
      onRefresh: () => ref.read(offersProvider.notifier).loadOffers(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (activeOffers.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              title: 'Active (${activeOffers.length})',
              icon: Icons.hourglass_top,
              color: Colors.blue,
            ),
            const SizedBox(height: 8),
            ...activeOffers.map((offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OfferCard(
                offer: offer,
                isOwner: false,
                onCancel: offer.status == OfferStatus.pending
                    ? () => _handleCancel(context, ref, offer)
                    : null,
                onAcceptCounter: offer.status == OfferStatus.countered
                    ? () => _handleAcceptCounter(context, ref, offer)
                    : null,
                onTap: () => _navigateToListing(context, offer),
              ),
            )),
            const SizedBox(height: 16),
          ],
          if (completedOffers.isNotEmpty) ...[
            _buildSectionHeader(
              context,
              title: 'History (${completedOffers.length})',
              icon: Icons.history,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            ...completedOffers.map((offer) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: OfferCard(
                offer: offer,
                isOwner: false,
                onTap: () => _navigateToListing(context, offer),
              ),
            )),
          ],
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Future<void> _handleCancel(BuildContext context, WidgetRef ref, Offer offer) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Cancel Offer'),
        content: const Text('Are you sure you want to cancel this offer?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('No'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        await ref.read(offersProvider.notifier).cancelOffer(offer.id);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offer cancelled'),
              backgroundColor: Colors.orange,
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to cancel offer: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _handleAcceptCounter(BuildContext context, WidgetRef ref, Offer offer) async {
    try {
      await ref.read(offersProvider.notifier).acceptCounterOffer(offer.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Counter offer accepted!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to accept counter offer: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateToListing(BuildContext context, Offer offer) {
    if (offer.itemType == 'product') {
      context.push('/product/${offer.itemId}');
    } else {
      context.push('/service/${offer.itemId}');
    }
  }

  Widget _buildEmptyState(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 64, color: colorScheme.onSurfaceVariant),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
