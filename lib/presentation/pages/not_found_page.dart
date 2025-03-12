import 'package:flutter/material.dart';

class NotFoundPage extends StatelessWidget {
  final String message;

  const NotFoundPage({required this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Not Found')),
      body: Center(child: Text(message)),
    );
  }
}
