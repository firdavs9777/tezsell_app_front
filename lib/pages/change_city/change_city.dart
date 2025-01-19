import 'package:flutter/material.dart';

class MyHomeTown extends StatefulWidget {
  const MyHomeTown({super.key});

  @override
  State<MyHomeTown> createState() => _MyHomeTownState();
}

class _MyHomeTownState extends State<MyHomeTown> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Change City Layout'),
      ),
    );
  }
}
