import 'package:app/pages/real_estate/real_estate_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SavedProperties extends ConsumerWidget {
  const SavedProperties({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final tokenAsync = ref.watch(tokenProvider);

    return Scaffold(
      body: tokenAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading authentication'),
        ),
        data: (token) {
          print(
              '📱 Token from provider: ${token?.substring(0, 20)}...'); // Add this - show more chars

          if (token == null) {
            return _buildLoginRequired(context, theme, l10n);
          }
          print(token);

          return _SavedPropertiesList(token: token);
        },
      ),
    );
  }

  Widget _buildLoginRequired(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24),
            Text(
              l10n.authLoginRequired,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              l10n.authLoginToViewSaved,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.authLogin,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavedPropertiesList extends ConsumerStatefulWidget {
  const _SavedPropertiesList({required this.token});

  final String token;

  @override
  ConsumerState<_SavedPropertiesList> createState() =>
      _SavedPropertiesListState();
}

class _SavedPropertiesListState extends ConsumerState<_SavedPropertiesList> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      print('Forcing provider refresh...');
      ref.invalidate(savedPropertiesNotifierProvider(widget.token));
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore) {
        _loadNextPage();
      }
    }
  }

  Future<void> _loadNextPage() async {
    if (_isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      await ref
          .read(savedPropertiesNotifierProvider(widget.token).notifier)
          .loadNextPage();
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingMore = false;
        });
      }
    }
  }

  Future<void> _refreshProperties() async {
    await ref
        .read(savedPropertiesNotifierProvider(widget.token).notifier)
        .refreshSavedProperties();
  }

  Future<void> _unsaveProperty(String propertyId) async {
    try {
      await ref
          .read(savedPropertiesNotifierProvider(widget.token).notifier)
          .unsaveProperty(propertyId);

      if (mounted) {
        HapticFeedback.selectionClick();
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.successPropertyUnsaved),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (error) {
      if (mounted) {
        final l10n = AppLocalizations.of(context)!;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.alertsUnsavePropertyFailed),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _navigateToPropertyDetail(String propertyId) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PropertyDetail(
                  propertyId: propertyId,
                )));
  }

  String _formatPrice(String price, String currency) {
    final numPrice = double.tryParse(price) ?? 0;
    final formatted = numPrice.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
    return '$currency $formatted';
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    final savedPropertiesAsync =
        ref.watch(savedPropertiesNotifierProvider(widget.token));

    print(savedPropertiesAsync);
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverAppBar(
          expandedHeight: 120,
          pinned: true,
          backgroundColor: theme.primaryColor,
          flexibleSpace: FlexibleSpaceBar(
            title: Text(
              l10n.savedPropertiesTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: false,
            titlePadding: EdgeInsets.only(left: 16, bottom: 16),
          ),
        ),
        savedPropertiesAsync.when(
          loading: () => SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    l10n.loadingSavedProperties,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          error: (error, stack) => SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(
                    l10n.errorsFailedToLoadSaved,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    error.toString(),
                    style: TextStyle(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: _refreshProperties,
                    icon: Icon(Icons.refresh),
                    label: Text(l10n.actionsRetry),
                  ),
                ],
              ),
            ),
          ),
          data: (response) {
            print(response.results);
            print('✅ State: DATA');
            print('   Count: ${response.count}');
            print('   Results length: ${response.results.length}');
            if (response.results.isEmpty) {
              return SliverFillRemaining(
                child: _buildEmptyState(context, theme, l10n),
              );
            }

            return SliverToBoxAdapter(
              child: Column(
                children: [
                  _buildResultsHeader(response.count, l10n),
                  _buildPropertiesList(response, l10n),
                  if (_isLoadingMore) _buildLoadingMoreIndicator(),
                  if (response.next == null && response.results.isNotEmpty)
                    _buildNoMorePropertiesIndicator(l10n),
                  SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
  ) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.favorite_border,
              size: 80,
              color: Colors.grey[400],
            ),
            SizedBox(height: 24),
            Text(
              l10n.savedPropertiesNoSaved,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12),
            Text(
              l10n.savedPropertiesStartSaving,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/properties');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.primaryColor,
                padding: EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                l10n.savedPropertiesBrowse,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsHeader(int count, AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count ${l10n.resultsSavedProperties}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          IconButton(
            onPressed: _refreshProperties,
            icon: Icon(Icons.refresh),
            tooltip: l10n.actionsRefresh,
          ),
        ],
      ),
    );
  }

  Widget _buildPropertiesList(
    SavedPropertiesResponse response,
    AppLocalizations l10n,
  ) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 16),
      itemCount: response.results.length,
      itemBuilder: (context, index) {
        final savedProperty = response.results[index];
        final property = savedProperty.property;

        return _PropertyCard(
          property: property,
          savedAt: savedProperty.savedAt,
          onTap: () => _navigateToPropertyDetail(property.id.toString()),
          onUnsave: () => _unsaveProperty(property.id.toString()),
          formatPrice: _formatPrice,
          formatDate: _formatDate,
        );
      },
    );
  }

  Widget _buildLoadingMoreIndicator() {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildNoMorePropertiesIndicator(AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          l10n.resultsNoMoreProperties,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}

class _PropertyCard extends ConsumerWidget {
  const _PropertyCard({
    required this.property,
    required this.savedAt,
    required this.onTap,
    required this.onUnsave,
    required this.formatPrice,
    required this.formatDate,
  });

  final dynamic property;
  final DateTime savedAt;
  final VoidCallback onTap;
  final VoidCallback onUnsave;
  final String Function(String, String) formatPrice;
  final String Function(DateTime) formatDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(theme, l10n),
            _buildContent(l10n),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(ThemeData theme, AppLocalizations l10n) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            property.mainImage,
            height: 200,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stack) => Container(
              height: 200,
              color: Colors.grey[300],
              child: Icon(
                Icons.apartment,
                size: 60,
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
        if (property.isFeatured)
          Positioned(
            top: 12,
            left: 12,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                l10n.propertyCardFeatured,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        Positioned(
          bottom: 12,
          left: 12,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: theme.primaryColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              property.listingTypeDisplay,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: IconButton(
              onPressed: onUnsave,
              icon: Icon(Icons.favorite, color: Colors.red),
              iconSize: 24,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(AppLocalizations l10n) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            property.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[900],
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              SizedBox(width: 4),
              Expanded(
                child: Text(
                  '${property.district}, ${property.city}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            formatPrice(property.price, property.currency),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.green[600],
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              _buildStatChip(
                  Icons.bed, '${property.bedrooms}', l10n.propertyCardBed),
              SizedBox(width: 12),
              _buildStatChip(Icons.bathroom, '${property.bathrooms}',
                  l10n.propertyCardBath),
              SizedBox(width: 12),
              _buildStatChip(
                  Icons.square_foot, '${property.squareMeters}m²', ''),
            ],
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.calendar_today, size: 14, color: Colors.grey[500]),
              SizedBox(width: 4),
              Text(
                '${l10n.savedPropertiesSavedOn} ${formatDate(savedAt)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildActionButtons(l10n),
        ],
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              l10n.propertyCardViewDetails,
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        SizedBox(width: 12),
        OutlinedButton(
          onPressed: onUnsave,
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.red),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
          child: Icon(Icons.delete, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildStatChip(IconData icon, String value, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        SizedBox(width: 4),
        Text(
          '$value${label.isNotEmpty ? " $label" : ""}',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}
