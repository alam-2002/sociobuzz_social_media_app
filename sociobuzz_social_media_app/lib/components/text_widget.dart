import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Label extends StatelessWidget {
  final String label;
  final Color? color;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final TextAlign? textAlign;
  final double? fontSize;
  final TextOverflow? overflow;
  final int? maxLines;
  final double? height;
  final double? letterSpacing;
  final TextDecoration? decoration;

  const Label({
    super.key,
    required this.label,
    this.color,
    this.fontWeight,
    this.fontStyle,
    this.textAlign,
    this.fontSize,
    this.overflow,
    this.height,
    this.maxLines,
    this.decoration,
    this.letterSpacing,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      maxLines: maxLines,
      textAlign: textAlign ?? TextAlign.start,
      style: GoogleFonts.notoSans(
        textStyle: TextStyle(
          height: height,
          overflow: overflow,
          fontSize: fontSize ?? 18,
          color: color,
          fontWeight: fontWeight ?? FontWeight.w400,
          fontStyle: fontStyle ?? FontStyle.normal,
          decoration: decoration,
          letterSpacing: letterSpacing,
        ),
      ),
    );
  }
}
