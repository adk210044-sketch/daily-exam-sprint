import 'package:flutter/material.dart';

import '../../core/theme/zen_tokens.dart';

/// Onboarding 5ステップの進捗インジケータ (current は 0-indexed)
class OnbSteps extends StatelessWidget {
  final int current;

  const OnbSteps({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(5, (i) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3),
            width: i == current ? 24 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i <= current ? ZenColors.accent : ZenColors.line,
              borderRadius: BorderRadius.circular(3),
            ),
          );
        }),
      ),
    );
  }
}
