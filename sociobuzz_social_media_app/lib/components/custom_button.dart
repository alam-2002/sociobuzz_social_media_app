import 'package:flutter/material.dart';
import 'package:sociobuzz_social_media_app/components/text_widget.dart';

class CustomButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final tertiary = Theme.of(context).colorScheme.tertiary;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: tertiary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Label(
            label: text,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
