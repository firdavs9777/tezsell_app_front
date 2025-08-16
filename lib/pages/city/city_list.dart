import 'dart:ui';
import 'package:app/pages/city/towns.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CityList extends StatefulWidget {
  CityList({super.key, required this.cityList, required this.cityId});

  List<String> cityList;
  List<String> cityId;

  @override
  State<CityList> createState() => _CityListState();
}

class _CityListState extends State<CityList> {
  @override
  Widget build(BuildContext context) {
    Color _backgroundColor =
        ThemeData().colorScheme.onPrimary; // Initial background color
    return widget.cityList.isNotEmpty
        ? Expanded(
            child: ListView.builder(
              itemCount: widget.cityList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    color: _backgroundColor,
                    child: ListTile(
                      onTap: () async {
                        bool? confirm = await showDialog<bool>(
                          context: context,
                          builder: (BuildContext context) {
                            return BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: AlertDialog(
                                title: Text(
                                    AppLocalizations.of(context)?.confirm ??
                                        'Tasdiqlash'),
                                content: Text(AppLocalizations.of(context)
                                        ?.confirmRegionSelection(
                                            widget.cityList[index]) ??
                                    ' ${widget.cityList[index]} viloyatini tanlamoqchimisiz?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // User pressed "No"
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)?.no ??
                                            'Yo\'q'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // User pressed "Yes"
                                    },
                                    child: Text(
                                        AppLocalizations.of(context)?.yes ??
                                            'Ha'),
                                  ),
                                ],
                              ),
                            );
                          },
                        );

                        if (confirm == true) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TownsList(
                                city_id: widget.cityId[index],
                                city_name: widget.cityList[index],
                              ),
                            ),
                          );
                        }
                      },
                      title: widget.cityList.length > 0
                          ? Text(
                              widget.cityList[index],
                              style: TextStyle(
                                  color: ThemeData().colorScheme.primary),
                            )
                          : Text(
                              AppLocalizations.of(context)?.emptyList ??
                                  'Empty List',
                              style: TextStyle(color: Colors.black12),
                            ),
                    ),
                  ),
                );
              },
            ),
          )
        : Text(AppLocalizations.of(context)?.dataLoadingError ??
            'There is an error while loading a data lol');
  }
}
