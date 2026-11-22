  import 'package:flutter/material.dart';
import 'app_bottom_nav.dart';

class PlaceholderScreen extends StatelessWidget {
  final String title;
  final int index;
  const PlaceholderScreen(
      {super.key, required this.title, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      bottomNavigationBar: AppBottomNav(index: index),
      body: Center(child: Text('$title : bientôt')),
    );
  }
}