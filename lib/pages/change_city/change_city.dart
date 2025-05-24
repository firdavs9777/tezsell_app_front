import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyHomeTown extends ConsumerStatefulWidget {
  const MyHomeTown({super.key});

  @override
  ConsumerState<MyHomeTown> createState() => _MyHomeTownState();
}

class _MyHomeTownState extends ConsumerState<MyHomeTown> {
  String? selectedRegion;
  String? selectedDistrict;

  final Map<String, List<String>> regions = {
    'Tashkent': ['Chilonzor', 'Yunusobod', 'Mirzo Ulugbek'],
    'Andijan': ['Asaka', 'Marhamat', 'Jalaquduq'],
    'Samarkand': ['Urgut', 'Bulungur', 'Narpay'],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change the Location')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Text(
                'Location Change',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // Region Dropdown
            const Text('Region',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedRegion,
              hint: const Text('Select Region'),
              items: regions.keys.map((region) {
                return DropdownMenuItem(
                  value: region,
                  child: Text(region),
                );
              }).toList(),
              onChanged: (region) {
                setState(() {
                  selectedRegion = region;
                  selectedDistrict = null; // Reset district when region changes
                });
              },
            ),

            const SizedBox(height: 15),

            // District Dropdown
            const Text('District',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            DropdownButton<String>(
              isExpanded: true,
              value: selectedDistrict,
              hint: const Text('Select District'),
              items: selectedRegion != null
                  ? regions[selectedRegion]!.map((district) {
                      return DropdownMenuItem(
                        value: district,
                        child: Text(district),
                      );
                    }).toList()
                  : [],
              onChanged: selectedRegion == null
                  ? null
                  : (district) {
                      setState(() {
                        selectedDistrict = district;
                      });
                    },
            ),

            const SizedBox(height: 20),

            // Selected Region & District

            const Text('Selected District:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            Text(
              '${selectedRegion ?? ''} ${selectedDistrict ?? ''}'.trim().isEmpty
                  ? 'None'
                  : '${selectedRegion ?? ''} ${selectedDistrict ?? ''}',
              style: const TextStyle(fontSize: 16),
            ),

            const Spacer(),

            // Submit Button
            Center(
              child: ElevatedButton(
                onPressed: (selectedRegion != null && selectedDistrict != null)
                    ? () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Location set to $selectedDistrict, $selectedRegion')),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  textStyle: const TextStyle(fontSize: 18),
                ),
                child: const Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
