import 'package:app/widgets/maps/map_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';

Widget _wrap(Widget child) => ProviderScope(
      child: MaterialApp(home: Scaffold(body: child)),
    );

void main() {
  testWidgets('renders attribution text', (tester) async {
    await tester.pumpWidget(_wrap(const MapView(
      center: LatLng(41.3, 69.24),
      zoom: 15,
      mode: MapViewMode.exact,
    )));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.textContaining('OpenStreetMap'), findsWidgets);
  });

  testWidgets('exact mode: shows MarkerLayer, no CircleLayer', (tester) async {
    await tester.pumpWidget(_wrap(const MapView(
      center: LatLng(41.3, 69.24),
      zoom: 15,
      mode: MapViewMode.exact,
    )));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(MarkerLayer), findsOneWidget);
    expect(find.byType(CircleLayer), findsNothing);
  });

  testWidgets('approximate mode: shows CircleLayer, no MarkerLayer',
      (tester) async {
    await tester.pumpWidget(_wrap(const MapView(
      center: LatLng(41.3, 69.24),
      zoom: 15,
      mode: MapViewMode.approximate,
    )));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(CircleLayer), findsOneWidget);
    expect(find.byType(MarkerLayer), findsNothing);
  });
}
