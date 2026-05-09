import 'dart:async';

import 'package:app/providers/provider_models/place.dart';
import 'package:app/providers/provider_root/maps_provider_provider.dart';
import 'package:app/services/maps/maps_exceptions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

class PlaceSearchField extends ConsumerStatefulWidget {
  final ValueChanged<Place> onSelected;
  final LatLng? near;
  final String hintText;

  const PlaceSearchField({
    super.key,
    required this.onSelected,
    this.near,
    this.hintText = 'Search for an address or place',
  });

  @override
  ConsumerState<PlaceSearchField> createState() => _PlaceSearchFieldState();
}

class _PlaceSearchFieldState extends ConsumerState<PlaceSearchField> {
  final _controller = TextEditingController();
  Timer? _debounce;
  List<Place> _results = const [];
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().length < 3) {
      setState(() {
        _results = const [];
        _error = null;
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 350), () => _search(value));
  }

  Future<void> _search(String q) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final provider = ref.read(mapsProviderProvider);
      final results =
          await provider.searchPlaces(q, near: widget.near, sessionToken: null);
      if (!mounted) return;
      setState(() {
        _results = results;
        _loading = false;
      });
    } on MapsException catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
        _results = const [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _controller,
          onChanged: _onChanged,
          decoration: InputDecoration(
            hintText: widget.hintText,
            prefixIcon: const Icon(Icons.search),
            suffixIcon: _loading
                ? const Padding(
                    padding: EdgeInsets.all(12),
                    child: SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            border: const OutlineInputBorder(),
          ),
        ),
        if (_error != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(
              'Search unavailable — drop a pin instead',
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        if (_results.isNotEmpty)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).dividerColor),
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _results.length,
              itemBuilder: (context, i) {
                final p = _results[i];
                return ListTile(
                  leading: const Icon(Icons.place_outlined),
                  title: Text(p.formattedAddress ?? p.neighborhood ?? '—'),
                  subtitle: Text('${p.city ?? ''}, ${p.countryCode ?? ''}'),
                  onTap: () {
                    widget.onSelected(p);
                    setState(() {
                      _results = const [];
                      _controller.text = p.formattedAddress ?? '';
                    });
                  },
                );
              },
            ),
          ),
      ],
    );
  }
}
