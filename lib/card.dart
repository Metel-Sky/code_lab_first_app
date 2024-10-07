import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';

class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Text(
          pair.asUpperCase,
          style: style, //TextStyle(fontSize: 35, fontWeight: FontWeight.bold)
          semanticsLabel:
              "${pair.first} ${pair.second}", //використовується для програм считування тексту з дисплею
        ),
      ),
    );
  }
} //12
