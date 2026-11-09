import 'package:flutter/material.dart';

class AddingOverlayWidget extends StatelessWidget {
  const AddingOverlayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.3),
      child: const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [CircularProgressIndicator(), SizedBox(height: 16), Text('Salvando produto...')],
            ),
          ),
        ),
      ),
    );
  }
}
