import 'package:flutter/material.dart';

class EmptyViewWidget extends StatelessWidget {
  const EmptyViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Nenhum produto cadastrado.'));
  }
}
