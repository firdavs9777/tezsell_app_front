import 'dart:async';

import 'package:app/l10n/app_localizations.dart';
import 'package:app/pages/real_estate/widgets/real_estate_property_card.dart';
import 'package:app/providers/provider_models/real_estate.dart';
import 'package:app/providers/provider_root/real_estate_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Plan B Task 6 — functional real-estate search. Replaces the previous
/// dummy stub (hardcoded 5-item list, no-op `onChanged`) with a debounced
/// search (400ms, mirroring `ChatSearchBar`'s pattern) against the backend's
/// `PropertyFilter.search` param, property/listing-type filter chips,
/// recent-searches persisted in SharedPreferences, and infinite scroll —
/// reusing the same [RealEstatePropertyCard] the main browse list uses.
class RealEstateSearch extends ConsumerStatefulWidget {
  const RealEstateSearch({super.key});

  @override
  ConsumerState<RealEstateSearch> createState() => _RealEstateSearchState();
}

class _PropertyTypeOption {
  const _PropertyTypeOption(this.key, this.labels, this.icon);
  final String key;
  final Map<String, String> labels;
  final IconData icon;
}

class _RealEstateSearchState extends ConsumerState<RealEstateSearch> {
  static const _recentSearchesPrefsKey = 're_recent_searches';
  static const _maxRecentSearches = 8;
  static const _pageSize = 12;

  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();
  Timer? _debounce;

  /// Monotonically increasing token guarding against out-of-order responses
  /// — a slow earlier request landing after a faster later one (or after
  /// the field is cleared) must not clobber the current results. Mirrors
  /// `ChatSearchBar._searchGeneration`.
  int _searchGeneration = 0;

  List<RealEstate> _results = [];
  int _currentPage = 1;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMoreData = true;
  bool _hasSearched = false;

  List<String> _recentSearches = [];

  String _selectedPropertyType = '';
  String _selectedListingType = '';

  final List<_PropertyTypeOption> _propertyTypes = const [
    _PropertyTypeOption('', {'uz': 'Barchasi', 'ru': 'Все', 'en': 'All'}, Icons.home),
    _PropertyTypeOption('apartment', {'uz': 'Kvartira', 'ru': 'Квартира', 'en': 'Apartment'}, Icons.apartment),
    _PropertyTypeOption('house', {'uz': 'Uy', 'ru': 'Дом', 'en': 'House'}, Icons.house),
    _PropertyTypeOption('office', {'uz': 'Ofis', 'ru': 'Офис', 'en': 'Office'}, Icons.business),
    _PropertyTypeOption('land', {'uz': 'Yer', 'ru': 'Земля', 'en': 'Land'}, Icons.landscape),
    _PropertyTypeOption('commercial', {'uz': 'Boshqa', 'ru': 'Другое', 'en': 'Other'}, Icons.store),
  ];

  final List<_PropertyTypeOption> _listingTypes = const [
    _PropertyTypeOption('', {'uz': 'Barchasi', 'ru': 'Все', 'en': 'All'}, Icons.all_inclusive),
    _PropertyTypeOption('sale', {'uz': 'Sotuv', 'ru': 'Продажа', 'en': 'Sale'}, Icons.sell),
    _PropertyTypeOption('rent', {'uz': 'Ijara', 'ru': 'Аренда', 'en': 'Rent'}, Icons.home_work),
  ];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  String _label(BuildContext context, _PropertyTypeOption option) {
    final languageCode = AppLocalizations.of(context)?.localeName ?? 'uz';
    String langKey = 'uz';
    if (languageCode.startsWith('ru')) {
      langKey = 'ru';
    } else if (languageCode.startsWith('en')) {
      langKey = 'en';
    }
    return option.labels[langKey] ?? option.labels['uz']!;
  }

  // ============= RECENT SEARCHES (SharedPreferences) =============

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(_recentSearchesPrefsKey) ?? const [];
    if (mounted) setState(() => _recentSearches = saved);
  }

  Future<void> _recordRecentSearch(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final current = List<String>.from(
        prefs.getStringList(_recentSearchesPrefsKey) ?? const []);
    current.removeWhere((e) => e.toLowerCase() == trimmed.toLowerCase());
    current.insert(0, trimmed);
    final capped = current.take(_maxRecentSearches).toList();
    await prefs.setStringList(_recentSearchesPrefsKey, capped);
    if (mounted) setState(() => _recentSearches = capped);
  }

  Future<void> _clearRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_recentSearchesPrefsKey);
    if (mounted) setState(() => _recentSearches = []);
  }

  // ============= SEARCH =============

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!_isLoadingMore && _hasMoreData && _hasSearched) {
        _loadMore();
      }
    }
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    setState(() {}); // toggle the clear button / recent-searches visibility
    final query = value.trim();

    if (query.length < 2) {
      // Not yet enough to search — don't fire a request, don't show stale
      // results either. Covers both the fully-empty (recent searches) case
      // and a 1-char in-progress query.
      _searchGeneration++;
      setState(() {
        _hasSearched = false;
        _results = [];
        _isLoading = false;
      });
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 400), () {
      _performSearch(query);
    });
  }

  void _onSubmitted(String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.isEmpty) return;
    unawaited(_recordRecentSearch(query));
    _performSearch(query);
  }

  void _onFilterChanged() {
    _debounce?.cancel();
    final query = _controller.text.trim();
    if (query.length >= 2) {
      _performSearch(query);
    }
  }

  Future<void> _performSearch(String query) async {
    final gen = ++_searchGeneration;
    // "recorded ... after results render for a >=2-char query (debounce
    // settle)" — this is the debounce settle point.
    unawaited(_recordRecentSearch(query));

    setState(() {
      _isLoading = true;
      _currentPage = 1;
      _hasMoreData = true;
    });

    try {
      final results =
          await ref.read(realEstateServiceProvider).getFilteredProperties(
                currentPage: 1,
                pageSize: _pageSize,
                propertyType: _selectedPropertyType,
                listingType: _selectedListingType,
                search: query,
              );
      if (!mounted || gen != _searchGeneration) return;

      setState(() {
        _results = results;
        _currentPage = 1;
        _hasMoreData = results.length >= _pageSize;
        _isLoading = false;
        _hasSearched = true;
      });
    } catch (e) {
      if (!mounted || gen != _searchGeneration) return;
      setState(() {
        _isLoading = false;
        _hasSearched = true;
        _results = [];
        _hasMoreData = false;
      });
      _showErrorSnackBar();
    }
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore || !_hasMoreData || !_hasSearched) return;
    final gen = _searchGeneration;
    final query = _controller.text.trim();
    if (query.length < 2) return;

    setState(() => _isLoadingMore = true);

    try {
      final nextPage = _currentPage + 1;
      final newResults =
          await ref.read(realEstateServiceProvider).getFilteredProperties(
                currentPage: nextPage,
                pageSize: _pageSize,
                propertyType: _selectedPropertyType,
                listingType: _selectedListingType,
                search: query,
              );
      if (!mounted || gen != _searchGeneration) return;

      setState(() {
        if (newResults.isNotEmpty) {
          _results.addAll(newResults);
          _currentPage = nextPage;
          _hasMoreData = newResults.length >= _pageSize;
        } else {
          _hasMoreData = false;
        }
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted || gen != _searchGeneration) return;
      setState(() {
        _isLoadingMore = false;
        _hasMoreData = false;
      });
    }
  }

  void _showErrorSnackBar() {
    final colorScheme = Theme.of(context).colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            AppLocalizations.of(context)?.searchPropertiesError ??
                'Failed to search properties. Please try again.'),
        backgroundColor: colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  void _onRecentSearchTap(String query) {
    _controller.value = TextEditingValue(
      text: query,
      selection: TextSelection.collapsed(offset: query.length),
    );
    _performSearch(query);
  }

  void _clearField() {
    _debounce?.cancel();
    _searchGeneration++;
    _controller.clear();
    setState(() {
      _hasSearched = false;
      _results = [];
      _isLoading = false;
    });
  }

  // ============= UI =============

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.surface,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: _buildSearchField(colorScheme, l),
        titleSpacing: 0,
      ),
      body: Column(
        children: [
          Divider(height: 1, color: colorScheme.outlineVariant),
          _buildFilterChips(context),
          Expanded(child: _buildBody(context, l)),
        ],
      ),
    );
  }

  Widget _buildSearchField(ColorScheme colorScheme, AppLocalizations? l) {
    return Container(
      height: 40,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autofocus: true,
        decoration: InputDecoration(
          hintText: l?.realEstateSearchHint ?? 'Search properties by title, location...',
          hintStyle: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 15),
          prefixIcon: Icon(Icons.search, color: colorScheme.onSurfaceVariant, size: 22),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: colorScheme.onSurfaceVariant, size: 20),
                  onPressed: _clearField,
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        textInputAction: TextInputAction.search,
        style: TextStyle(fontSize: 15, color: colorScheme.onSurface),
        onChanged: _onChanged,
        onSubmitted: _onSubmitted,
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(bottom: BorderSide(color: theme.colorScheme.outlineVariant)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            for (final option in _propertyTypes)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildChip(
                  label: _label(context, option),
                  icon: option.icon,
                  selected: _selectedPropertyType == option.key,
                  onSelected: () {
                    setState(() => _selectedPropertyType = option.key);
                    _onFilterChanged();
                  },
                ),
              ),
            Container(
              width: 1,
              height: 24,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              color: theme.colorScheme.outlineVariant,
            ),
            for (final option in _listingTypes)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildChip(
                  label: _label(context, option),
                  icon: option.icon,
                  selected: _selectedListingType == option.key,
                  onSelected: () {
                    setState(() => _selectedListingType = option.key);
                    _onFilterChanged();
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onSelected,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    return ChoiceChip(
      label: Text(label),
      avatar: Icon(icon, size: 16),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: colorScheme.primary,
      labelStyle: theme.textTheme.labelMedium?.copyWith(
        color: selected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
        fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
      ),
      backgroundColor: colorScheme.surfaceContainerHighest.withOpacity(0.5),
      side: BorderSide.none,
      visualDensity: VisualDensity.compact,
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations? l) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_controller.text.trim().isEmpty) {
      return _buildInitialOrRecent(context, l);
    }

    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: colorScheme.primary),
            const SizedBox(height: 16),
            Text(
              l?.properties_loading ?? 'Loading properties...',
              style: theme.textTheme.bodyMedium
                  ?.copyWith(color: colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    if (!_hasSearched) {
      // Query is non-empty but shorter than the 2-char search threshold.
      return _buildInitialOrRecent(context, l, showRecent: false);
    }

    if (_results.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: colorScheme.outlineVariant),
            const SizedBox(height: 16),
            Text(
              l?.noResultsFound ?? 'No results found.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      itemCount: _results.length + (_hasMoreData ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < _results.length) {
          return RealEstatePropertyCard(property: _results[index]);
        }
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: _isLoadingMore
                ? CircularProgressIndicator(color: colorScheme.primary)
                : const SizedBox.shrink(),
          ),
        );
      },
    );
  }

  Widget _buildInitialOrRecent(BuildContext context, AppLocalizations? l,
      {bool showRecent = true}) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          if (showRecent && _recentSearches.isNotEmpty) ...[
            Row(
              children: [
                Text(
                  l?.recentSearches ?? 'Recent searches',
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _clearRecentSearches,
                  child: Text(l?.clearRecentSearches ?? 'Clear all'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final query in _recentSearches)
                    InputChip(
                      label: Text(query),
                      avatar: const Icon(Icons.history, size: 16),
                      onPressed: () => _onRecentSearchTap(query),
                      backgroundColor:
                          colorScheme.surfaceContainerHighest.withOpacity(0.5),
                      side: BorderSide.none,
                    ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
          Icon(Icons.search, size: 80, color: colorScheme.outlineVariant),
          const SizedBox(height: 16),
          Text(
            l?.realEstateSearchPrompt ?? 'Search for properties',
            style: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
