part of 'unit_test.dart';

/// Used to hold and test a list of [UnitStep].
class UnitScenario<SUT, Example extends UnitExample?> {
  UnitScenario({
    required String description,
    required List<UnitStep<SUT, Example>> steps,
    SUT Function(UnitMocks mocks)? systemUnderTest,
    void Function(UnitMocks mocks)? setUpMocks,
    List<Example> examples = const [],
    TestGroupFunction<SUT>? setUpEach,
    TestGroupFunction<SUT>? tearDownEach,
    TestGroupFunction<SUT>? setUpOnce,
    TestGroupFunction<SUT>? tearDownOnce,
  })  : _description = description,
        _setUpMocks = setUpMocks,
        _systemUnderTestCallback = systemUnderTest,
        _steps = steps,
        _examples = examples,
        _setUpEach = setUpEach,
        _tearDownEach = tearDownEach,
        _setUpOnce = setUpOnce,
        _tearDownOnce = tearDownOnce;

  /// Used to facilitate extra logging capabilities inside [UnitStep].
  final UnitLog _log = const UnitLog();

  /// High-level description of the [UnitScenario].
  final String _description;

  /// Callback to set up mocks before any other logic is run.
  final void Function(UnitMocks mocks)? _setUpMocks;

  /// The callback to retrieve the system/unit that you are testing.
  final SUT Function(UnitMocks mocks)? _systemUnderTestCallback;

  /// List that specifies all [UnitScenario]s for a given [UnitFeature].
  ///
  /// For more information about how to write a [UnitStep] see the [IncrementCounterScenario]
  /// example or check out the [UnitStep] documentation.
  final List<UnitStep<SUT, Example>> _steps;

  /// List of scenario outline examples of type [Example] that extend [UnitExample].
  final List<Example> _examples;

  /// Code that will run at the START of this [UnitScenario]
  /// or at the START of EACH [UnitScenario._examples].
  final TestGroupFunction<SUT>? _setUpEach;

  /// Code that will run ONCE at the END of this [UnitScenario]
  /// or ONCE at the END of EACH [UnitScenario._examples].
  final TestGroupFunction<SUT>? _tearDownEach;

  /// Code that will run at the START of this [UnitScenario]
  /// regardless of how many [UnitScenario._examples] you have specified.
  final TestGroupFunction<SUT>? _setUpOnce;

  /// Code that will run ONCE at the END of this [UnitScenario]
  /// regardless of how many [UnitScenario._examples] you have specified.
  final TestGroupFunction<SUT>? _tearDownOnce;

  /// Runs all tests defined in this [UnitScenario]s [_steps].
  ///
  /// All tests run at least once (or more depending on the amount of examples) and inside their
  /// own [testWidgets] method. Override this method and call your [_steps] test() methods in a
  /// different manner if this unwanted behaviour.
  void test({
    String? testDescription,
    String? featureDescription,
    int? nrScenario,
    int? nrFeature,
    UnitMocks? mocks,
    SUT? systemUnderTest,
  }) {
    assert((_systemUnderTestCallback != null) || (systemUnderTest != null),
        'You must specify a systemUnderTest in a UnitScenario or higher up the tree.');
    flutter_test.group(
      _description,
      () {
        final _mocks = mocks ?? UnitMocks();
        _setUpMocks?.call(_mocks);
        final SUT _systemUnderTest =
            _systemUnderTestCallback?.call(_mocks) ?? systemUnderTest!;
        _setUpAndTeardown(mocks: _mocks, systemUnderTest: _systemUnderTest);
        for (int index = 0; index < math.max(1, _examples.length); index++) {
          flutter_test.test(
            _examples.isNotEmpty
                ? 'Example ${index + 1}: ${_examples[index]}'
                : _description,
            () async {
              debugPrintSynchronously('---');
              try {
                if (testDescription != null) {
                  debugPrintSynchronously(
                      '${UnitLog.tag} 📝 Test: $testDescription');
                }
                if (featureDescription != null) {
                  debugPrintSynchronously(
                      '${UnitLog.tag} 🦾 Feature${nrFeature != null ? ' ${nrFeature + 1}' : ''}: $featureDescription');
                }
                debugPrintSynchronously(
                    '${UnitLog.tag} 🎩 Scenario${nrScenario != null ? ' ${nrScenario + 1}' : ''}: $_description');
                if (_examples.isNotEmpty) {
                  final example = _examples[index];
                  debugPrintSynchronously(
                      '${UnitLog.tag} 🏷 Example ${index + 1}: $example');
                }
                debugPrintSynchronously('${UnitLog.tag} 🎬 --- Test started!');
                final box = UnitBox();
                for (final step in _steps) {
                  if (_examples.isNotEmpty) {
                    await step.test(
                      systemUnderTest: _systemUnderTest!,
                      log: _log,
                      example: _examples[index],
                      box: box,
                      mocks: _mocks,
                    );
                  } else {
                    await step.test(
                      log: _log,
                      systemUnderTest: _systemUnderTest!,
                      box: box,
                      mocks: _mocks,
                    );
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
  void _setUpAndTeardown({
    required UnitMocks mocks,
    required SUT systemUnderTest,
  }) {
    if (_setUpOnce != null) {
      flutter_test.setUpAll(() => _setUpOnce!(mocks, systemUnderTest));
    }
    if (_tearDownOnce != null) {
      flutter_test.tearDownAll(() => _tearDownOnce!(mocks, systemUnderTest));
    }
    if (_setUpEach != null) {
      flutter_test.setUp(() => _setUpEach!(mocks, systemUnderTest));
    }
    if (_tearDownEach != null) {
      flutter_test.tearDown(() => _tearDownEach!(mocks, systemUnderTest));
    }
  }
}
