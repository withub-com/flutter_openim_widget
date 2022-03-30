## flutter_openim_widget

#### The public ui library is used with the openim demo, and you can directly use it for secondary development.

[![pub package](https://img.shields.io/pub/v/flutter_openim_widget.svg)](https://pub.flutter-io.cn/packages/flutter_openim_widget)
[![GitHub license](https://img.shields.io/github/license/hrxiang/flutter_openim_widget)](https://github.com/hrxiang/flutter_openim_widget/blob/master/LICENSE)

```
import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';
import 'package:get/get.dart';
import 'package:openim_enterprise_chat/src/res/strings.dart';
import 'package:openim_enterprise_chat/src/res/styles.dart';
import 'package:openim_enterprise_chat/src/widgets/chat_listview.dart';
import 'package:openim_enterprise_chat/src/widgets/titlebar.dart';

import 'chat_logic.dart';

class ChatPage extends StatelessWidget {
  final logic = Get.find<ChatLogic>();

  Widget _itemView(index) => ChatItemView(
        key: logic.itemKey(index),
        index: index,
        message: logic.indexOfMessage(index),
        timeStr: logic.getShowTime(index),
        isSingleChat: logic.isSingleChat,
        clickSubject: logic.clickSubject,
        msgSendStatusSubject: logic.msgSendStatusSubject,
        msgSendProgressSubject: logic.msgSendProgressSubject,
        multiSelMode: logic.multiSelMode.value,
        multiList: logic.multiSelList.value,
        allAtMap: logic.atUserNameMappingMap,
        delaySendingStatus: true,
        onMultiSelChanged: (checked) {
          logic.multiSelMsg(index, checked);
        },
        onTapCopyMenu: () {
          logic.copy(index);
        },
        onTapDelMenu: () {
          logic.deleteMsg(index);
        },
        onTapForwardMenu: () {
          logic.forward(index);
        },
        onTapReplyMenu: () {
          logic.setQuoteMsg(index);
        },
        onTapRevokeMenu: () {
          logic.revokeMsg(index);
        },
        onTapMultiMenu: () {
          logic.openMultiSelMode(index);
        },
        visibilityChange: (context, index, message, visible) {
          print('visible:$index $visible');
          logic.markC2CMessageAsRead(index, message, visible);
        },
        onLongPressLeftAvatar: () {
          logic.onLongPressLeftAvatar(index);
        },
        onLongPressRightAvatar: () {},
        onTapLeftAvatar: () {
          logic.onTapLeftAvatar(index);
        },
        onTapRightAvatar: () {},
        onClickAtText: (uid) {
          logic.clickAtText(uid);
        },
        onTapQuoteMsg: () {
          logic.onTapQuoteMsg(index);
        },
        patterns: <MatchPattern>[
          MatchPattern(
            type: PatternType.AT,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.EMAIL,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.URL,
            style: PageStyle.ts_1B72EC_14sp_underline,
            onTap: logic.clickLinkText,
          ),
          MatchPattern(
            type: PatternType.PHONE,
            style: PageStyle.ts_1B72EC_14sp,
            onTap: logic.clickLinkText,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return logic.exit();
      },
      child: ChatVoiceRecordLayout(
        locale: Get.locale,
        builder: (bar) => Obx(() => Scaffold(
              backgroundColor: PageStyle.c_FFFFFF,
              appBar: EnterpriseTitleBar.chatTitle(
                title: logic.name.value,
                subTitle: logic.getSubTile(),
                onClickCallBtn: () => logic.call(),
                onClickMoreBtn: () => logic.chatSetup(),
                leftButton: logic.multiSelMode.value ? StrRes.cancel : null,
                onClose: () => logic.exit(),
                showOnlineStatus: logic.showOnlineStatus(),
                online: logic.onlineStatus.value,
              ),
              body: SafeArea(
                child: Column(
                  children: [
                    Expanded(
                      child: ChatListView(
                        listViewKey: ObjectKey(logic.listViewKey.value),
                        onTouch: () => logic.closeToolbox(),
                        itemCount: logic.messageList.length,
                        controller: logic.autoCtrl,
                        onLoad: () => logic.getHistoryMsgList(),
                        itemBuilder: (_, index) => Obx(() => _itemView(index)),
                      ),
                    ),
                    ChatInputBoxView(
                      controller: logic.inputCtrl,
                      allAtMap: logic.atUserNameMappingMap,
                      toolbox: ChatToolsView(
                        onTapAlbum: () => logic.onTapAlbum(),
                        onTapCamera: () => logic.onTapCamera(),
                        onTapCarte: () => logic.onTapCarte(),
                        onTapFile: () => logic.onTapFile(),
                        onTapLocation: () => logic.onTapLocation(),
                        onTapVideoCall: () => logic.call(),
                        onStopVoiceInput: () => logic.onStopVoiceInput(),
                        onStartVoiceInput: () => logic.onStartVoiceInput(),
                      ),
                      multiOpToolbox: ChatMultiSelToolbox(
                        onDelete: () => logic.mergeDelete(),
                        onMergeForward: () => logic.mergeForward(),
                      ),
                      emojiView: ChatEmojiView(
                        onAddEmoji: logic.onAddEmoji,
                        onDeleteEmoji: logic.onDeleteEmoji,
                      ),
                      onSubmitted: (v) => logic.sendTextMsg(),
                      forceCloseToolboxSub: logic.forceCloseToolbox,
                      voiceRecordBar: bar,
                      quoteContent: logic.quoteContent.value,
                      onClearQuote: () => logic.setQuoteMsg(-1),
                      multiMode: logic.multiSelMode.value,
                      focusNode: logic.focusNode,
                    ),
                  ],
                ),
              ),
            )),
        onCompleted: (sec, path) {
          logic.sendVoice(duration: sec, path: path);
        },
      ),
    );
  }
}


```
