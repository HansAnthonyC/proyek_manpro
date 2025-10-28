import 'package:flutter/material.dart';

// Diterjemahkan dari ChatBubble.tsx
class ChatBubble extends StatelessWidget {
  final String message;
  const ChatBubble({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Bubble
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: theme.cardColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(color: theme.primaryColor.withOpacity(0.2)),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: theme.textTheme.bodyMedium?.color,
              height: 1.5,
            ),
          ),
        ),
        // Tail
        Positioned(
          bottom: -10,
          left: 24,
          child: Transform.rotate(
            angle: 3.14159 / 4, // 45 derajat
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: theme.cardColor.withOpacity(0.9),
                border: Border(
                  bottom: BorderSide(
                    color: theme.primaryColor.withOpacity(0.2),
                  ),
                  right: BorderSide(color: theme.primaryColor.withOpacity(0.2)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
