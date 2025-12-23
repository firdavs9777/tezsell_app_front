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
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.search_off,
                size: 64,
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
              ),
              SizedBox(height: 16),
              Text(
                AppLocalizations.of(context)?.emptyList ??
                    'Hech narsa topilmadi',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      itemCount: cityList.length,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      itemBuilder: (context, index) {
        return Card(
          elevation: 2,
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.orange.withOpacity(0.2),
              child: Icon(
                Icons.location_city,
                color: Colors.orange,
                size: 20,
              ),
            ),
            title: Text(
              cityList[index],
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
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
                              color: Colors.grey,
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
