import 'package:flutter/material.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';

class BioBox extends StatelessWidget {
  final String text;
  const BioBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    final secondary = Theme.of(context).colorScheme.secondary;
    final inversePrimary = Theme.of(context).colorScheme.inversePrimary;
    return Container(
      padding: EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: secondary,
      ),
      width: double.infinity,
      child: Label(
        label: text.isNotEmpty ? text : 'No bio yet...',
        color: inversePrimary,
      ),
    );
  }
}
