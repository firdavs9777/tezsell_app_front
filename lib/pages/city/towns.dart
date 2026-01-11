import 'dart:convert';
import 'dart:ui';
import 'package:app/constants/constants.dart';
import 'package:app/pages/authentication/mobile_authentication.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:app/l10n/app_localizations.dart';

// Create a model class for district data
class District {
  final int id;
  final String name;

  District({required this.id, required this.name});

  factory District.fromJson(Map<String, dynamic> json) {
    return District(id: json['id'], name: json['district']);
  }
}

class TownsList extends StatefulWidget {
  const TownsList({super.key, required this.city_id, required this.city_name});
  final String city_id;
  final String city_name;

  @override
  State<TownsList> createState() => _TownsListState();
}

class _TownsListState extends State<TownsList> {
  final String URL = '$baseUrl/accounts/districts';
  List<District> districts = [];
  List<District> filteredDistricts = [];
  final TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse('$URL/${widget.city_id}/'));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> districtData = responseData['districts'];

        setState(() {
          districts = districtData
              .map<District>((district) => District.fromJson(district))
              .toList();
          filteredDistricts = List.from(districts);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showErrorDialog(
          AppLocalizations.of(
                context,
              )?.errorWithCode(response.statusCode.toString()) ??
              'Error: ${response.statusCode}',
        );
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _showErrorDialog(
        AppLocalizations.of(context)?.failedToLoadData(error.toString()) ??
            'Failed to load data. Error: $error',
      );
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.error_outline_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppLocalizations.of(context)?.error ?? 'Error',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Theme.of(
                          context,
                        ).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        AppLocalizations.of(context)?.ok ?? 'OK',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _filterTowns(String searchText) {
    setState(() {
      filteredDistricts =
          districts
              .where(
                (district) => district.name.toLowerCase().contains(
                  searchText.toLowerCase(),
                ),
              )
              .toList()
            ..sort((a, b) => a.name.compareTo(b.name));
    });
  }

  Future<void> _showConfirmationDialog(District district) async {
    bool? confirm = await showDialog(
      context: context,
      barrierColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.white.withOpacity(0.1)
          : Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 4, sigmaY: 4),
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.location_on_rounded,
                      color: Theme.of(context).primaryColor,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    AppLocalizations.of(context)?.confirm ?? 'Confirm',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    AppLocalizations.of(context)?.confirmDistrictSelection(
                          widget.city_name,
                          district.name,
                        ) ??
                        '${widget.city_name} - ${district.name}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color,
                            side: BorderSide(
                              color: Theme.of(context).dividerColor,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.no ?? 'Cancel',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Theme.of(
                              context,
                            ).colorScheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.yes ?? 'Confirm',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (confirm ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MobileAuthentication(
            regionName: widget.city_name,
            districtName: district.name,
            districtId: district.id.toString(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, size: 20),
          color: Theme.of(context).colorScheme.onBackground,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.city_name,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontSize: 18, letterSpacing: -0.3),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: Theme.of(context).dividerColor),
        ),
      ),
      body: Column(
        children: <Widget>[
          // Header section
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)?.selectDistrictOrCity ??
                      'Select your district',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${districts.length} districts available',
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ),

          // Search bar
          Container(
            color: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: TextField(
              controller: searchController,
              onChanged: _filterTowns,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w400),
              decoration: InputDecoration(
                filled: true,
                fillColor: Theme.of(context).scaffoldBackgroundColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                    color: Theme.of(context).primaryColor,
                    width: 1.5,
                  ),
                ),
                prefixIcon: Icon(
                  Icons.search_rounded,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                  size: 22,
                ),
                suffixIcon: searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(
                          Icons.cancel_rounded,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                          size: 20,
                        ),
                        onPressed: () {
                          searchController.clear();
                          _filterTowns('');
                        },
                      )
                    : null,
                hintText:
                    AppLocalizations.of(context)?.searchHint ??
                    'Search districts',
                hintStyle: Theme.of(context).inputDecorationTheme.hintStyle,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 12,
                  horizontal: 16,
                ),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // List section
          Expanded(
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                      strokeWidth: 3,
                    ),
                  )
                : filteredDistricts.isNotEmpty
                ? ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 0),
                    itemCount: filteredDistricts.length,
                    separatorBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(left: 20),
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                    itemBuilder: (context, index) {
                      return Container(
                        color: Theme.of(context).colorScheme.surface,
                        child: ListTile(
                          onTap: () =>
                              _showConfirmationDialog(filteredDistricts[index]),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 4,
                          ),
                          title: Text(
                            filteredDistricts[index].name,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: -0.2,
                                ),
                          ),
                          trailing: Icon(
                            Icons.chevron_right_rounded,
                            color: Theme.of(
                              context,
                            ).textTheme.bodySmall?.color?.withOpacity(0.5),
                            size: 24,
                          ),
                        ),
                      );
                    },
                  )
                : Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off_rounded,
                              size: 64,
                              color: Theme.of(
                                context,
                              ).textTheme.bodySmall?.color?.withOpacity(0.3),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              AppLocalizations.of(context)?.noResultsFound ??
                                  'No results found',
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.color,
                                    fontWeight: FontWeight.w500,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Try searching with a different keyword',
                              style: TextStyle(
                                color: Theme.of(
                                  context,
                                ).textTheme.bodySmall?.color?.withOpacity(0.7),
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
