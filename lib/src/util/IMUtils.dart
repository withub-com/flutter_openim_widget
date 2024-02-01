
import 'dart:convert';

import 'package:common_utils/common_utils.dart';
import 'package:sprintf/sprintf.dart';

import '../../flutter_openim_widget.dart';
import '../message_manager.dart';
import 'logger.dart';

class IntervalDo {
  DateTime? last;

  void run({required Function() fuc, int milliseconds = 0}) {
    DateTime now = DateTime.now();
    if (null == last || now.difference(last ?? now).inMilliseconds > milliseconds) {
      last = now;
      fuc();
    }
  }
}

class IMUtils {
  static bool isUrlValid(String? url) {
    if (null == url || url.isEmpty) {
      return false;
    }
    return url.startsWith("http://") || url.startsWith("https://");
  }

  static Map<String, String> getAtMapping(
      Message message,
      Map<String, String> newMapping,
      ) {
    final mapping = <String, String>{};
    try {
      if (message.contentType == MessageType.atText) {
        var list = message.atTextElem!.atUsersInfo;
        list?.forEach((e) {
          final userID = e.atUserID!;
          final groupNickname = newMapping[userID] ?? e.groupNickname ?? e.atUserID!;
          mapping[userID] = getAtNickname(userID, groupNickname);
        });
      }
    } catch (_) {}
    return mapping;
  }

  static String getAtNickname(String atUserID, String atNickname) {
    return atUserID == 'atAllTag' ? '所有人' : atNickname;
  }

  static bool isNotNullEmptyStr(String? str) => null != str && "" != str.trim();

  static String getGroupMemberShowName(GroupMembersInfo membersInfo) {
    return membersInfo.userID == OpenIM.iMManager.userID ? '你' : membersInfo.nickname!;
  }

  static String getChatTimeline(int ms, [String formatToday = 'HH:mm']) {
    final locTimeMs = DateTime.now().millisecondsSinceEpoch;
    final isZH = true;

    if (DateUtil.isToday(ms, locMs: locTimeMs)) {
      return formatDateMs(ms, format: formatToday);
    }

    if (DateUtil.isYesterdayByMs(ms, locTimeMs)) {
      return '${isZH ? '昨天' : 'Yesterday'} ${formatDateMs(ms, format: 'HH:mm')}';
    }

    if (DateUtil.isWeek(ms, locMs: locTimeMs)) {
      return '${DateUtil.getWeekdayByMs(ms, languageCode: 'zn')} ${formatDateMs(ms, format: 'HH:mm')}';
    }


    if (DateUtil.yearIsEqualByMs(ms, locTimeMs)) {
      return formatDateMs(ms, format: isZH ? 'MM月dd HH:mm' : 'MM/dd HH:mm');
    }

    return formatDateMs(ms, format: isZH ? 'yyyy年MM月dd' : 'yyyy/MM/dd');
  }

  static dynamic parseCustomMessage(Message message) {
    try {
      switch (message.contentType) {
        case MessageType.custom:
          {
            var data = message.customElem!.data;
            var map = json.decode(data!);
            var customType = map['customType'];
            switch (customType) {
              case CustomMessageType.call:
                {
                  final duration = map['data']['duration'];
                  final state = map['data']['state'];
                  final type = map['data']['type'];
                  String? content;
                  switch (state) {
                    case 'beHangup':
                    case 'hangup':
                      content = sprintf('通话时长 %s', [seconds2HMS(duration)]);
                      break;
                    case 'cancel':
                      content = '已取消';
                      break;
                    case 'beCanceled':
                      content = '对方已取消';
                      break;
                    case 'reject':
                      content = '已拒绝';
                      break;
                    case 'beRejected':
                      content = '对方已拒绝';
                      break;
                    case 'timeout':
                      content = '超时无响应';
                      break;
                    default:
                      break;
                  }
                  if (content != null) {
                    return {
                      'viewType': CustomMessageType.call,
                      'type': type,
                      'content': content,
                    };
                  }
                }
                break;
              case CustomMessageType.emoji:
                map['data']['viewType'] = CustomMessageType.emoji;
                return map['data'];
              case CustomMessageType.tag:
                map['data']['viewType'] = CustomMessageType.tag;
                return map['data'];
              case CustomMessageType.meeting:
                map['data']['viewType'] = CustomMessageType.meeting;
                return map['data'];
              case CustomMessageType.deletedByFriend:
              case CustomMessageType.blockedByFriend:
              case CustomMessageType.removedFromGroup:
              case CustomMessageType.groupDisbanded:
                return {'viewType': customType};
            }
          }
      }
    } catch (e, s) {
      Logger.print('Exception details:\n $e');
      Logger.print('Stack trace:\n $s');
    }
    return null;
  }

  static String formatDateMs(int ms, {bool isUtc = false, String? format}) {
    return DateUtil.formatDateMs(ms, format: format, isUtc: isUtc);
  }

  static String _combTime(int value, String unit) => value > 0 ? '$value$unit' : '';

  static String mutedTime(int mss) {
    int days = mss ~/ (60 * 60 * 24);
    int hours = (mss % (60 * 60 * 24)) ~/ (60 * 60);
    int minutes = (mss % (60 * 60)) ~/ 60;
    int seconds = mss % 60;
    return "${_combTime(days, '天')}${_combTime(hours, '小时')}${_combTime(minutes, '分钟')}${_combTime(seconds, '秒')}";
  }

  static String seconds2HMS(int seconds) {
    int h = 0;
    int m = 0;
    int s = 0;
    int temp = seconds % 3600;
    if (seconds > 3600) {
      h = seconds ~/ 3600;
      if (temp != 0) {
        if (temp > 60) {
          m = temp ~/ 60;
          if (temp % 60 != 0) {
            s = temp % 60;
          }
        } else {
          s = temp;
        }
      }
    } else {
      m = seconds ~/ 60;
      if (seconds % 60 != 0) {
        s = seconds % 60;
      }
    }
    if (h == 0) {
      return '${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}';
    }
    return "${h < 10 ? '0$h' : h}:${m < 10 ? '0$m' : m}:${s < 10 ? '0$s' : s}";
  }
}
