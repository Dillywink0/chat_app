import 'package:flutter/material.dart';

class DevicesScreen extends StatelessWidget {
  const DevicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Logged-in Devices'),
      ),
      body: const Center(
        child: Text('List of logged-in devices goes here.'),
      ),
    );
  }
}