


import 'package:flutter/material.dart';

enum PatternType { at, atAll, email, mobile, tel, url, emoji, custom }

class MatchPattern {
  PatternType type;

  String? pattern;

  TextStyle? style;

  Function(String link, PatternType? type)? onTap;

  MatchPattern({required this.type, this.pattern, this.style, this.onTap});
}
