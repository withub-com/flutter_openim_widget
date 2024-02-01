// import 'package:extended_text/extended_text.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
//
// import '../../flutter_openim_widget.dart';
//
// enum TextModel { match, normal }
//
// final String regexAt = r"(@\d+\s)";
//
// final String regexAtAll = r'@atAllTag ';
//
// final String regexEmail = r"\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b";
//
// final String regexUrl = r"[(http(s)?):\/\/(www\.)?a-zA-Z0-9@:._\+-~#=]{2,256}\.[a-z]{2,6}\b([-a-zA-Z0-9@:_\+.~#?&\/\/=]*)";
//
// final String regexMobile = '^(\\+?86)?((13[0-9])|(14[57])|(15[0-35-9])|(16[2567])|(17[01235-8])|(18[0-9])|(19[1589]))\\d{8}\$';
//
// final String regexTel = '^0\\d{2,3}[-]?\\d{7,8}';
//
// class MatchTextView extends StatelessWidget {
//   final String text;
//   final TextStyle? textStyle;
//   final TextStyle? matchTextStyle;
//   final InlineSpan? prefixSpan;
//
//   final TextAlign textAlign;
//   final TextOverflow overflow;
//   final int? maxLines;
//   final double textScaleFactor;
//
//   final Map<String, String> allAtMap;
//   final List<MatchPattern> patterns;
//   final TextModel model;
//   final Function(String? text)? onVisibleTrulyText;
//
//   const MatchTextView({
//     Key? key,
//     required this.text,
//     this.allAtMap = const <String, String>{},
//     this.prefixSpan,
//     this.patterns = const <MatchPattern>[],
//     this.textAlign = TextAlign.left,
//     this.overflow = TextOverflow.clip,
//     this.textStyle,
//     this.matchTextStyle,
//     this.maxLines,
//     this.textScaleFactor = 1.0,
//     this.model = TextModel.match,
//     this.onVisibleTrulyText,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final List<InlineSpan> children = <InlineSpan>[];
//
//     if (prefixSpan != null) children.add(prefixSpan!);
//
//     if (model == TextModel.normal) {
//       _normalModel(children);
//     } else {
//       _matchModel(children);
//     }
//
//     final textSpan = TextSpan(children: children);
//     onVisibleTrulyText?.call(textSpan.toPlainText());
//
//     return Container(
//       constraints: BoxConstraints(maxWidth: maxWidth),
//       child: RichText(
//         textAlign: textAlign,
//         overflow: overflow,
//         maxLines: maxLines,
//         textScaleFactor: textScaleFactor,
//         text: textSpan,
//       ),
//     );
//   }
//
//   _normalModel(List<InlineSpan> children) {
//     children.add(TextSpan(text: text, style: textStyle));
//   }
//
//   _matchModel(List<InlineSpan> children) {
//     final mappingMap = <String, MatchPattern>{};
//
//     for (var e in patterns) {
//
//       if (e.type == PatternType.at) {
//         mappingMap[regexAt] = e;
//         mappingMap[regexAtAll] = MatchPattern(type: PatternType.atAll);
//       } else if (e.type == PatternType.email) {
//         mappingMap[regexEmail] = e;
//       } else if (e.type == PatternType.mobile) {
//         mappingMap[regexMobile] = e;
//       } else if (e.type == PatternType.tel) {
//         mappingMap[regexTel] = e;
//       } else if (e.type == PatternType.url) {
//         mappingMap[regexUrl] = e;
//       } else {
//         mappingMap[e.pattern!] = e;
//       }
//     }
//
//     var regexEmoji = emojiFaces.keys.toList().join('|').replaceAll('[', '\\[').replaceAll(']', '\\]');
//
//     mappingMap[regexEmoji] = MatchPattern(type: PatternType.emoji);
//
//     String pattern;
//
//     if (mappingMap.length > 1) {
//       pattern = '(${mappingMap.keys.toList().join('|')})';
//     } else {
//       pattern = regexEmoji;
//     }
//     stripHtmlIfNeeded(text).splitMapJoin(
//       RegExp(pattern),
//       onMatch: (Match match) {
//         var matchText = match[0]!;
//         InlineSpan inlineSpan;
//         final mapping = mappingMap[matchText] ??
//             mappingMap[mappingMap.keys.firstWhere((element) {
//               final reg = RegExp(element);
//               return reg.hasMatch(matchText);
//             }, orElse: () {
//               return '';
//             })];
//         if (mapping != null) {
//           if (mapping.type == PatternType.at) {
//             String userID = matchText.replaceFirst("@", "").trim();
//             if (allAtMap.containsKey(userID)) {
//               matchText = '@${allAtMap[userID]} ';
//               inlineSpan = TextSpan(
//                 text: matchText,
//                 style: mapping.style ?? matchTextStyle ?? textStyle,
//                 recognizer: mapping.onTap == null
//                     ? null
//                     : (TapGestureRecognizer()
//                       ..onTap = () => mapping.onTap!(
//                           _getUrl(userID, mapping.type), mapping.type)),
//               );
//             } else {
//               inlineSpan = TextSpan(text: matchText, style: textStyle);
//             }
//           } else if (mapping.type == PatternType.atAll) {
//             matchText = '@所有人 ';
//             inlineSpan = TextSpan(
//               text: matchText,
//               style: mapping.style ?? matchTextStyle ?? textStyle,
//             );
//           } else if (mapping.type == PatternType.emoji) {
//             inlineSpan = ImageSpan(
//               ImageUtil.emojiImage(matchText),
//               imageWidth: textScaleFactor * 1.4,
//               imageHeight: textScaleFactor * 1.4,
//             );
//           } else {
//             inlineSpan = TextSpan(
//               text: matchText,
//               style: mapping.style ?? matchTextStyle ?? textStyle,
//               recognizer: mapping.onTap == null
//                   ? null
//                   : (TapGestureRecognizer()
//                     ..onTap = () => mapping.onTap!(
//                         _getUrl(matchText, mapping.type), mapping.type)),
//             );
//           }
//         } else {
//           inlineSpan = TextSpan(text: matchText, style: textStyle);
//         }
//         children.add(inlineSpan);
//         return '';
//       },
//       onNonMatch: (text) {
//         children.add(TextSpan(text: text, style: textStyle));
//         return '';
//       },
//     );
//   }
//
//   _getUrl(String text, PatternType type) {
//     switch (type) {
//       case PatternType.url:
//         return text.substring(0, 4) == 'http' ? text : 'http://$text';
//       case PatternType.email:
//         return text.substring(0, 7) == 'mailto:' ? text : 'mailto:$text';
//       case PatternType.tel:
//       case PatternType.mobile:
//         return text.substring(0, 4) == 'tel:' ? text : 'tel:$text';
//       default:
//         return text;
//     }
//   }
//
//   static String stripHtmlIfNeeded(String text) {
//     return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
//   }
// }
//
//
//
