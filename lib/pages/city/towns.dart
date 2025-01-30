import 'dart:convert';
import 'dart:ui';
import 'package:app/pages/authentication/mobile_authentication.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TownsList extends StatefulWidget {
  const TownsList({super.key, required this.city_id, required this.city_name});
  final String city_id;
  final String city_name;

  @override
  State<TownsList> createState() => _TownsListState();
}

class _TownsListState extends State<TownsList> {
  final String URL = 'http://127.0.0.1:8000/accounts/districts';
  List<String> towns = [];
  List<String> filteredTowns = [];
  final TextEditingController searchController = TextEditingController();

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
    try {
      final response = await http.get(Uri.parse('$URL/${widget.city_id}'));
      if (response.statusCode == 200) {
        Map<String, dynamic> responseData = json.decode(response.body);
        List<dynamic> townData = responseData['districts'];

        setState(() {
          towns = townData
              .map<String>((town) => town['district'].toString())
              .toList();
          filteredTowns = List.from(towns);
        });
      } else {
        _showErrorDialog('Error: ${response.statusCode}');
      }
    } catch (error) {
      _showErrorDialog('Failed to load data. Error: $error');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _filterTowns(String searchText) {
    setState(() {
      filteredTowns = towns
          .where(
              (town) => town.toLowerCase().contains(searchText.toLowerCase()))
          .toList()
        ..sort();
    });
  }

  Future<void> _showConfirmationDialog(String town) async {
    bool? confirm = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: AlertDialog(
            title: const Text('Tasdiqlash'),
            content:
                Text('${widget.city_name} viloyati -  $town tanlamoqchimisiz?'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false); // User pressed "No"
                },
                child: const Text('Yo\'q'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // User pressed "Yes"
                },
                child: const Text('Ha'),
              ),
            ],
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
            districtName: town,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = Theme.of(context).colorScheme.onPrimary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(
          widget.city_name,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Center(
              child: Text(
                'Iltimos, tuman yoki shaharingizni tanlang',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.secondary,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            child: TextField(
              controller: searchController,
              onChanged: _filterTowns,
              decoration: InputDecoration(
                labelText: 'Izlash',
                hintText: 'Tuman yoki shaharni qidirish',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Expanded(
            child: filteredTowns.isNotEmpty
                ? ListView.builder(
                    itemCount: filteredTowns.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: backgroundColor,
                        child: ListTile(
                          onTap: () =>
                              _showConfirmationDialog(filteredTowns[index]),
                          title: Text(
                            filteredTowns[index],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'Hech qanday natija topilmadi.',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
