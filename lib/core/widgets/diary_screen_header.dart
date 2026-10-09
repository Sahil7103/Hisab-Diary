import 'package:flutter/material.dart';

class DiaryScreenHeader extends StatelessWidget {
  const DiaryScreenHeader({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) => Semantics(header: true,
    child: Text(title, style: Theme.of(context).textTheme.headlineLarge));
}
