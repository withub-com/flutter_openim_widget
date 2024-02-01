import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/src/chat/custom_ext.dart';
import 'package:flutter_openim_widget/src/chat/str_ext.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChatTimelineView extends StatelessWidget {
  const ChatTimelineView({
    Key? key,
    required this.timeStr,
    this.margin,
  }) : super(key: key);
  final String timeStr;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: timeStr.toText..style = TextStyle(
        color: Color(0xFF8E9AB0),
        fontSize: 12.sp,
      ),
    );
  }
}
