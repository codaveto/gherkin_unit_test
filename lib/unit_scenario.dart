part of 'unit_test.dart';

/// Used to hold and test a list of [UnitStep].
class UnitScenario<SUT> {
  UnitScenario({
    required String description,
    required FutureOr<SUT> Function() systemUnderTest,
    required List<UnitStep<SUT, UnitExample>> steps,
    List<UnitExample> examples = const [],
    TestGroupFunction? setUpEach,
    TestGroupFunction? tearDownEach,
    TestGroupFunction? setUpOnce,
    TestGroupFunction? tearDownOnce,
  })  : _description = description,
        _systemUnderTestCallback = systemUnderTest,
        _steps = steps,
        _examples = examples,
        _setUpEach = setUpEach,
        _tearDownEach = tearDownEach,
        _setUpOnce = setUpOnce,
        _tearDownOnce = tearDownOnce;

  /// Used to facilitate extra logging capabilities inside [UnitStep].
  final UnitLog _log = UnitLog();

  /// High-level description of the [UnitScenario].
  final String _description;

  /// The callback to retrieve the system/unit that you are testing.
  final FutureOr<SUT> Function() _systemUnderTestCallback;

  /// The system/unit that you are testing.
  SUT? _systemUnderTest;

  /// List that specifies all [UnitScenario]s for a given [UnitFeature].
  ///
  /// For more information about how to write a [UnitStep] see the [IncrementCounterScenario]
  /// example or check out the [UnitStep] documentation.
  final List<UnitStep<SUT, UnitExample>> _steps;

  /// List of scenario outline examples of type [Example] that extend [UnitExample].
  final List<UnitExample> _examples;

  /// Code that will run at the START of this [UnitScenario]
  /// or at the START of EACH [UnitScenario._examples].
  final TestGroupFunction? _setUpEach;

  /// Code that will run ONCE at the END of this [UnitScenario]
  /// or ONCE at the END of EACH [UnitScenario._examples].
  final TestGroupFunction? _tearDownEach;

  /// Code that will run at the START of this [UnitScenario]
  /// regardless of how many [UnitScenario._examples] you have specified.
  final TestGroupFunction? _setUpOnce;

  /// Code that will run ONCE at the END of this [UnitScenario]
  /// regardless of how many [UnitScenario._examples] you have specified.
  final TestGroupFunction? _tearDownOnce;

  /// Runs all tests defined in this [UnitScenario]s [_steps].
  ///
  /// All tests run at least once (or more depending on the amount of examples) and inside their
  /// own [testWidgets] method. Override this method and call your [_steps] test() methods in a
  /// different manner if this unwanted behaviour.
  void test({
    IntegrationTestWidgetsFlutterBinding? binding,
    String? testDescription,
    String? featureDescription,
    required int nrScenario,
    required int nrFeature,
  }) {
    flutter_test.group(
      _description,
      () {
        _setUpAndTeardown();
        for (int index = 0; index < math.max(1, _examples.length); index++) {
          flutter_test.test(
            _examples.isNotEmpty
                ? 'Example ${index + 1}: ${_examples[index]}'
                : _description,
            () async {
              debugPrintSynchronously('---');
              try {
                _systemUnderTest = await _systemUnderTestCallback();
                if (testDescription != null) {
                  debugPrintSynchronously(
                      '${UnitLog.tag} 📝 Test: $testDescription');
                }
                if (featureDescription != null) {
                  debugPrintSynchronously(
                      '${UnitLog.tag} 🦾 Feature ${nrFeature + 1}: $featureDescription');
                }
                debugPrintSynchronously(
                    '${UnitLog.tag} 🎩 Scenario ${nrScenario + 1}: $_description');
                if (_examples.isNotEmpty) {
                  final example = _examples[index];
                  debugPrintSynchronously(
                      '${UnitLog.tag} 🏷 Example ${index + 1}: $example');
                }
                debugPrintSynchronously('${UnitLog.tag} 🎬 --- Test started!');
                Object? result;
                for (final step in _steps) {
                  if (_examples.isNotEmpty) {
                    result = await step.test(
                      systemUnderTest: _systemUnderTest!,
                      log: _log,
                      example: index != (_examples.length - 1)
                          ? _examples[index]
                          : _examples[index].copyWith(isLastExample: true),
                      result: result,
                    );
                    if (result != null) {
                      debugPrintSynchronously(
                          '${UnitLog.tag} 📜 Passing result to next step: $result');
                    }
                  } else {
                    result = await step.test(
                      log: _log,
                      systemUnderTest: _systemUnderTest!,
                      result: result,
                    );
                    if (result != null) {
                      debugPrintSynchronously(
                          '${UnitLog.tag} 📜 Passing result to next step: $result');
                    }
                  }
                }
              } catch (error) {
                debugPrintSynchronously('${UnitLog.tag} ❌ Test failed!\n---');
                rethrow;
              }
            },
          );
        }
      },
    );
  }

  /// Runs any provided [_setUpEach], [_setUpOnce], [_tearDownEach] and [_tearDownOnce] methods.
  void _setUpAndTeardown() {
    if (_setUpOnce != null) flutter_test.setUpAll(_setUpOnce!);
    if (_tearDownOnce != null) flutter_test.tearDownAll(_tearDownOnce!);
    if (_setUpEach != null) flutter_test.setUp(_setUpEach!);
    if (_tearDownEach != null) flutter_test.tearDown(_tearDownEach!);
  }
}
