import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

typedef RecordFc = Function(int sec, String path);

class VoiceRecord {
  static const _dir = "voice";
  static const _ext = ".m4a";
  late String _path;
  int _startTimestamp = 0;
  late int _tag;
  final RecordFc onFinished;
  final RecordFc onInterrupt;
  final int maxRecordSec;
  final _audioRecorder = Record();
  Timer? _timer;

  VoiceRecord({
    required this.maxRecordSec,
    required this.onInterrupt,
    required this.onFinished,
  }) : _tag = _now();

  start() async {
    if (await _audioRecorder.hasPermission()) {
      var path = (await getApplicationDocumentsDirectory()).path;
      _path = '$path/$_dir/$_tag$_ext';
      File file = File(_path);
      if (!(await file.exists())) {
        await file.create(recursive: true);
      }
      await _audioRecorder.start(path: _path);
      _startTimestamp = _now();
      _timer?.cancel();
      _timer = null;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
        // _long = (_now() - _long) ~/ 1000;
        if (((_now() - _startTimestamp) ~/ 1000) >= maxRecordSec) {
          await stop(isInterrupt: true);
          onInterrupt(maxRecordSec, _path);
        }
      });
    }
  }

  stop({bool isInterrupt = false}) async {
    _timer?.cancel();
    _timer = null;
    if (await _audioRecorder.isRecording()) {
      await _audioRecorder.stop();
      if (isInterrupt) return;
      onFinished((_now() - _startTimestamp) ~/ 1000, _path);
    }
  }

  static int _now() => DateTime.now().millisecondsSinceEpoch;
}
