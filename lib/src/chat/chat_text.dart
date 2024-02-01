import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/src/chat/styles.dart';
import 'package:flutter_openim_widget/src/chat/text_view.dart';

import '../../flutter_openim_widget.dart';
import 'match_pattern.dart';


class ChatText extends StatelessWidget {
  const ChatText({
    Key? key,
    this.isISend = false,
    required this.text,
    this.allAtMap = const <String, String>{},
    this.prefixSpan,
    this.patterns = const <MatchPattern>[],
    this.textAlign = TextAlign.left,
    this.overflow = TextOverflow.clip,
    this.textStyle,
    this.maxLines,
    this.textScaleFactor = 1.0,
    this.model = ChatTextModel.match,
    this.onVisibleTrulyText,
  }) : super(key: key);
  final bool isISend;
  final String text;
  final TextStyle? textStyle;
  final InlineSpan? prefixSpan;
  final TextAlign textAlign;
  final TextOverflow overflow;
  final int? maxLines;
  final double textScaleFactor;
  final Map<String, String> allAtMap;
  final List<MatchPattern> patterns;
  final ChatTextModel model;
  final Function(String? text)? onVisibleTrulyText;

  @override
  Widget build(BuildContext context) => ChatAtText(
        text: text,
        textStyle: textStyle ??
            (isISend ? Styles.ts_FFFFFF_17sp : Styles.ts_0C1C33_17sp),
        // matchTextStyle: Styles.ts_0089FF_17sp,
        prefixSpan: prefixSpan,
        textAlign: textAlign,
        overflow: overflow,
        textScaleFactor: textScaleFactor,
        allAtMap: allAtMap,
        patterns: patterns,
        model: model,
        maxLines: maxLines,
        onVisibleTrulyText: onVisibleTrulyText,
      );
}
