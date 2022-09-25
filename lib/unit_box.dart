part of 'unit_test.dart';

/// Used to store data that stays persistent over several [UnitStep]s inside a [UnitScenario].
class UnitBox {
  late final Map<Object, Object?> _mapBox = {};

  /// Reads a value from the box based on [key].
  T read<T extends Object?>(Object key) {
    final value = _mapBox[key] as T;
    debugPrintSynchronously(
        '${UnitLog.tag} 📦 Reading \'$key\' value: $value as ${value.runtimeType} from box!');
    return value;
  }

  /// Writes a value to the box based on [key] and [value]
  void write(Object key, Object? value) {
    debugPrintSynchronously(
        '${UnitLog.tag} 📦 Writing \'$key\' value: $value as ${value.runtimeType} to box!');
    _mapBox[key] = value;
  }

  /// Clears all values of the [_mapBox].
  void _clear() => _mapBox.clear();
}
