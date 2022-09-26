import 'package:flutter/foundation.dart';

class UnitLog {
  const UnitLog();

  static const String tag = '[UNIT-TEST]';

  void info(String message) => debugPrintSynchronously('$tag 🗣 $message');
  void value(Object? value, String message) =>
      debugPrintSynchronously('$tag 💾 $message: $value');
  void warning([String message = 'Warning!']) =>
      debugPrintSynchronously('$tag ⚠️ $message');
  void error([String message = 'Error!']) =>
      debugPrintSynchronously('$tag ⛔️ $message');
  void success([String message = 'Success!']) =>
      debugPrintSynchronously('$tag ✅️ $message');
}
