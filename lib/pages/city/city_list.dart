import 'dart:convert';
import 'dart:ui';
import 'package:app/pages/city/towns.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
                                title: const Text('Tasdiqlash'),
                                content: Text(
                                    ' ${widget.cityList[index]} viloyatini tanlamoqchimisiz?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(false); // User pressed "No"
                                    },
                                    child: const Text('Yo\'q'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(true); // User pressed "Yes"
                                    },
                                    child: const Text('Ha'),
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
                              'Empty List',
                              style: TextStyle(color: Colors.black12),
                            ),
                    ),
                  ),
                );
              },
            ),
          )
        : Text('There is an error while loading a data');
  }
}
