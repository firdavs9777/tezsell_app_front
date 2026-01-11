import 'dart:ui';
import 'package:app/pages/city/towns.dart';
import 'package:flutter/material.dart';
import 'package:app/l10n/app_localizations.dart';

class CityList extends StatelessWidget {
  const CityList({super.key, required this.cityList, required this.cityId});

  final List<String> cityList;
  final List<String> cityId;

  @override
  Widget build(BuildContext context) {
    if (cityList.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Text(
            AppLocalizations.of(context)?.noResultsFound ??
                'No results found.',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall?.color,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: cityList.length,
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      itemBuilder: (context, index) {
        return Card(
          color: Theme.of(context).colorScheme.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 8.0),
          child: ListTile(
            title: Text(
              cityList[index],
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            trailing: Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            onTap: () async {
              bool? confirm = await showDialog<bool>(
                context: context,
                barrierDismissible: true,
                builder: (BuildContext context) {
                  return BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      title: Row(
                        children: [
                          Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 8),
                          Text(
                            AppLocalizations.of(context)?.confirm ??
                                'Tasdiqlash',
                            style: TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                      content: Text(
                        AppLocalizations.of(context)
                                ?.confirmRegionSelection(cityList[index]) ??
                            '${cityList[index]} viloyatini tanlamoqchimisiz?',
                        style: TextStyle(fontSize: 16),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text(
                            AppLocalizations.of(context)?.no ?? 'Yo\'q',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            AppLocalizations.of(context)?.yes ?? 'Ha',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );

              if (confirm == true && context.mounted) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TownsList(
                      city_id: cityId[index],
                      city_name: cityList[index],
                    ),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
