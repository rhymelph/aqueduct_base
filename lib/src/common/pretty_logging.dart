import 'package:logging/logging.dart';
import 'package:io/ansi.dart';

class Log {
  static void d(String tag, String message) {
    prettyLog(LogRecord(
      Level.INFO,
      message,
      tag,
    ));
  }

  static void s(String tag, String message) {
    prettyLog(LogRecord(
      Level.SEVERE,
      message,
      tag,
    ));
  }

  static void w(String tag, String message) {
    prettyLog(LogRecord(
      Level.SEVERE,
      message,
      tag,
    ));
  }

  static void e(String tag, String message,
      [Object error, StackTrace stackTrace]) {
    prettyLog(LogRecord(
      Level.SHOUT,
      message,
      tag,
      error,
      stackTrace,
    ));
  }
}

/// 给日志添加点颜色
void prettyLog(LogRecord record) {
  final code = chooseLogColor(record.level);

  if (record.error == null) {
    print(code.wrap(record.toString()));
  }

  if (record.error != null) {
    final err = record.error;
    print(code.wrap('${record.toString()}\n'));
    print(code.wrap(err.toString()));

    if (record.stackTrace != null) {
      print(code.wrap(record.stackTrace.toString()));
    }
  }
}

/// Chooses a color based on the logger [level].
AnsiCode chooseLogColor(Level level) {
  if (level == Level.SHOUT)
    return backgroundRed;
  else if (level == Level.SEVERE)
    return red;
  else if (level == Level.WARNING)
    return yellow;
  else if (level == Level.INFO)
    return cyan;
  else if (level == Level.CONFIG ||
      level == Level.FINE ||
      level == Level.FINER ||
      level == Level.FINEST) return lightGray;
  return resetAll;
}
