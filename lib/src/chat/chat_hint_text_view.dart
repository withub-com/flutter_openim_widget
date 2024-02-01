import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_widget/src/chat/custom_ext.dart';
import 'package:flutter_openim_widget/src/chat/str_ext.dart';
import 'package:flutter_openim_widget/src/chat/styles.dart';
import 'package:sprintf/sprintf.dart';

import '../util/IMUtils.dart';

class ChatHintTextView extends StatelessWidget {
  const ChatHintTextView({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    final elem = message.notificationElem!;
    final map = json.decode(elem.detail!);
    switch (message.contentType) {
      case MessageType.groupCreatedNotification:
        {
          final ntf = GroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf('%s创建了群聊', ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupInfoSetNotification:
        {
          final ntf = GroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf('%s 修改了群资料', ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.memberQuitNotification:
        {
          final ntf = QuitGroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.quitUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf('%s 退出了群聊', ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.memberInvitedNotification:
        {
          final aMap = <String, String>{};
          final bMap = <String, String>{};
          final ntf = InvitedJoinGroupNotification.fromJson(map);

          aMap[ntf.opUser!.userID!] = IMUtils.getGroupMemberShowName(ntf.opUser!);

          for (var user in ntf.invitedUserList!) {
            bMap[user.userID!] = IMUtils.getGroupMemberShowName(user);
          }

          final a = ntf.opUser!.userID!;
          final b = bMap.keys.join('、');
          String pattern = '(${[a, ...bMap.keys].join('|')})';

          final text = sprintf('%s 邀请 %s 加入群聊', [a, b]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp(pattern),
            onMatch: (match) {
              final text = match[0]!;
              final value = aMap[text] ?? bMap[text] ?? '';
              children.add(TextSpan(text: value, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.memberKickedNotification:
        {
          final aMap = <String, String>{};
          final bMap = <String, String>{};
          final ntf = KickedGroupMemeberNotification.fromJson(map);

          aMap[ntf.opUser!.userID!] = IMUtils.getGroupMemberShowName(ntf.opUser!);

          for (var user in ntf.kickedUserList!) {
            bMap[user.userID!] = IMUtils.getGroupMemberShowName(user);
          }

          final a = ntf.opUser!.userID!;
          final b = bMap.keys.join('、');
          String pattern = '(${[a, ...bMap.keys].join('|')})';

          final text = sprintf('%s 被 %s 移出群聊', [b, a]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp(pattern),
            onMatch: (match) {
              final text = match[0]!;
              final value = aMap[text] ?? bMap[text] ?? '';
              children.add(TextSpan(text: value, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.memberEnterNotification:
        {
          final ntf = EnterGroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.entrantUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf('%s 加入群聊', ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.dismissGroupNotification:
        {
          final ntf = GroupNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf('%s 解散了群聊', ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupOwnerTransferredNotification:
        {
          final ntf = GroupRightsTransferNoticication.fromJson(map);
          final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          final b = IMUtils.getGroupMemberShowName(ntf.newGroupOwner!);
          final text = sprintf('%s 将群管理权限转让给了 %s', [a, b]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              children.add(TextSpan(text: text, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMemberMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          final b = IMUtils.getGroupMemberShowName(ntf.mutedUser!);
          final c = IMUtils.mutedTime(ntf.mutedSeconds!);
          final text = sprintf('%s 被 %s 禁言%s', [b, a, c]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              children.add(TextSpan(text: text, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMemberCancelMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);
          final a = IMUtils.getGroupMemberShowName(ntf.opUser!);
          final b = IMUtils.getGroupMemberShowName(ntf.mutedUser!);
          final text = sprintf('%s 被 %s 取消了禁言', [b, a]);
          final List<InlineSpan> children = <InlineSpan>[];
          text.splitMapJoin(
            RegExp('($a|$b)'),
            onMatch: (match) {
              final text = match[0]!;
              children.add(TextSpan(text: text, style: Styles.ts_0089FF_12sp));
              return '';
            },
            onNonMatch: (text) {
              children.add(TextSpan(text: text, style: Styles.ts_8E9AB0_12sp));
              return '';
            },
          );

          return RichText(
            text: TextSpan(children: children),
            textAlign: TextAlign.center,
          );
        }
      case MessageType.groupMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf('%s 开起了群禁言', ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.groupCancelMutedNotification:
        {
          final ntf = MuteMemberNotification.fromJson(map);

          return RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              text: IMUtils.getGroupMemberShowName(ntf.opUser!),
              style: Styles.ts_0089FF_12sp,
              children: [
                TextSpan(
                  text: sprintf('%s 关闭了群禁言', ['']),
                  style: Styles.ts_8E9AB0_12sp,
                ),
              ],
            ),
          );
        }
      case MessageType.friendApplicationApprovedNotification:
        {
          return ('你们已成为好友，可以开始聊天了').toText..style = Styles.ts_8E9AB0_12sp;
        }
      case MessageType.burnAfterReadingNotification:
        {
          final ntf = BurnAfterReadingNotification.fromJson(map);

          return (ntf.isPrivate == true ? '已开启阅后即焚' : '已关闭阅后即焚').toText..style = Styles.ts_8E9AB0_12sp;
        }
      case MessageType.groupMemberInfoChangedNotification:
        final ntf = GroupMemberInfoChangedNotification.fromJson(map);

        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: IMUtils.getGroupMemberShowName(ntf.opUser!),
            style: Styles.ts_0089FF_12sp,
            children: [
              TextSpan(
                text: sprintf('%s 编辑了自己的群成员资料', ['']),
                style: Styles.ts_8E9AB0_12sp,
              ),
            ],
          ),
        );
      case MessageType.groupInfoSetAnnouncementNotification:
        final ntf = GroupNotification.fromJson(map);
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: IMUtils.getGroupMemberShowName(ntf.opUser!),
            style: Styles.ts_0089FF_12sp,
            children: [
              TextSpan(
                text: sprintf('%s 修改了群公告', ['']),
                style: Styles.ts_8E9AB0_12sp,
              ),
            ],
          ),
        );
        break;
      case MessageType.groupInfoSetNameNotification:
        final ntf = GroupNotification.fromJson(map);
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: IMUtils.getGroupMemberShowName(ntf.opUser!),
            style: Styles.ts_0089FF_12sp,
            children: [
              TextSpan(
                text: sprintf('%s 修改了群名称', ['']),
                style: Styles.ts_8E9AB0_12sp,
              ),
            ],
          ),
        );
    }
    return const SizedBox();
  }
}
