import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/src/chat/custom_ext.dart';
import 'package:flutter_openim_widget/src/chat/str_ext.dart';
import 'package:sprintf/sprintf.dart';

import '../flutter_openim_widget.dart';
import 'chat/styles.dart';

class ChatFriendRelationshipAbnormalHintView extends StatelessWidget {
  const ChatFriendRelationshipAbnormalHintView({
    Key? key,
    this.blockedByFriend = false,
    this.deletedByFriend = false,
    required this.name,
    this.onTap,
  }) : super(key: key);
  final bool blockedByFriend;
  final bool deletedByFriend;
  final String name;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    if (blockedByFriend) {
      return '消息已发出，但被对方拒收了'.toText..style = Styles.ts_8E9AB0_12sp;
    } else if (deletedByFriend) {
      return Container(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: RichText(
          text: TextSpan(
            text: sprintf('%s开启了好友验证，你还不是他的好友 ', [name]),
            style: Styles.ts_8E9AB0_12sp,
            children: [
              TextSpan(
                text: '验证添加',
                style: Styles.ts_0089FF_12sp,
                recognizer: TapGestureRecognizer()..onTap = onTap,
              ),
            ],
          ),
        ),
      );
    }
    return Container();
  }
}
