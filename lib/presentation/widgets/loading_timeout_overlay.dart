// 🐦 Flutter imports:
import 'package:flutter/material.dart';

class LoadingTimeoutOverlay extends StatelessWidget {
  final void Function()? functionToExecute;
  const LoadingTimeoutOverlay({
    Key? key,
    required this.functionToExecute,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Taking longer than usual',
          ),
          TextButton(
            onPressed: functionToExecute,
            style: TextButton.styleFrom(
              primary: Colors.grey.withOpacity(0.2),
            ),
            child: const Text('Reload'),
          ),
        ],
      ),
    );
  }
}
