import 'package:flutter/material.dart';

// This is a placeholder for your complex voice flow.
// This widget would be a ConsumerStatefulWidget to manage its own state
// (listening, processing, confirming).
class VoiceInteractionSheet extends StatelessWidget {
  const VoiceInteractionSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // This sheet would dynamically change its content based on
    // the voice state (Listening, Processing, Confirming)
    return Container(
      padding: const EdgeInsets.all(24),
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Listening...", // This text would be dynamic
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Icon(Icons.mic, size: 60, color: Theme.of(context).colorScheme.primary),
          const SizedBox(height: 20),
          const Text(
            "Speak your command, e.g.,\n'I sold 2 chairs for 1000 each'",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}