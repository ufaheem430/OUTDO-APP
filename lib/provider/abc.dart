import 'package:flutter/material.dart';

class ABC extends StatelessWidget {
  String data;
  ABC(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Errors'),
      ),
      body: Center(
        child: Text(data),
      ),
    );
  }
}
