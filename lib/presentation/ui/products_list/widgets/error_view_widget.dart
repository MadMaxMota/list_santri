import 'package:flutter/material.dart';

class ErrorViewWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorViewWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Erro ao carregar produtos.'),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Tentar Novamente')),
        ],
      ),
    );
  }
}
