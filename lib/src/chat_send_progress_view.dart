import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_openim_widget/flutter_openim_widget.dart';

class ChatSendProgressView extends StatefulWidget {
  /// this.show = message.status == MessageStatus.sending;
  const ChatSendProgressView({
    Key? key,
    required this.width,
    required this.height,
    required this.msgId,
    this.stream,
    this.initProgress = 100,
  }) : super(key: key);

  final double width;
  final double height;
  final int initProgress;
  final String msgId;
  final Stream<MsgStreamEv<int>>? stream;

  @override
  State createState() => _ChatSendProgressViewState();
}

class _ChatSendProgressViewState extends State<ChatSendProgressView> {
  int _progress = 0;
  StreamSubscription? _progressSubs;

  @override
  void initState() {
    _progress = widget.initProgress;
    _progressSubs = widget.stream?.listen((event) {
      if (!mounted) return;
      if (widget.msgId == event.msgId) {
        setState(() {
          _progress = event.value;
        });
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _progressSubs?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: _progress != 100,
      child: Container(
        height: widget.height,
        width: widget.width,
        color: Colors.black.withOpacity(0.5),
        alignment: Alignment.center,
        child: Text(
          '$_progress%',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
