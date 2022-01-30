import 'package:flutter/material.dart';

class CalTep extends StatefulWidget {
  const CalTep({Key? key}) : super(key: key);

  @override
  _CalTepState createState() => _CalTepState();
}

class _CalTepState extends State<CalTep> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Text('data'),
        ],
      ),
    );
  }
}
