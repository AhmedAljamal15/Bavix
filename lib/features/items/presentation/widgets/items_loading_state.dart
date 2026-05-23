import 'package:flutter/material.dart';

class ItemsLoadingState extends StatelessWidget {
  const ItemsLoadingState();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
