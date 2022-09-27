part of 'unit_test.dart';

/// Used to specify and test a list of [UnitScenario].
class UnitFeature<SUT> {
  const UnitFeature({
    required String description,
    required List<UnitScenario<SUT, UnitExample>> scenarios,
    SUT Function(UnitMocks mocks)? systemUnderTest,
    TestGroupFunction<SUT>? setUpEach,
    TestGroupFunction<SUT>? tearDownEach,
    TestGroupFunction<SUT>? setUpOnce,
    TestGroupFunction<SUT>? tearDownOnce,
  })  : _description = description,
        _systemUnderTestCallback = systemUnderTest,
        _scenarios = scenarios,
        _setUpEach = setUpEach,
        _tearDownEach = tearDownEach,
        _setUpOnce = setUpOnce,
        _tearDownOnce = tearDownOnce;

  /// High-level description of the [UnitFeature] and related [UnitScenario]s.
  final String _description;

  /// The callback to retrieve the system/unit that you are testing.
  final SUT Function(UnitMocks mocks)? _systemUnderTestCallback;

  /// List that specifies all [UnitScenario]s for a given [UnitFeature].
  final List<UnitScenario<SUT, UnitExample>> _scenarios;

  /// Code that will run at the START of each [UnitScenario] under this [UnitFeature]
  /// or at the START of EACH [UnitScenario._examples] under this [UnitFeature].
  final TestGroupFunction<SUT>? _setUpEach;

  /// Code that will run ONCE at the END of this [UnitScenario] under this [UnitFeature]
  /// or ONCE at the END of EACH [UnitScenario._examples] under this [UnitFeature].
  final TestGroupFunction<SUT>? _tearDownEach;

  /// Code that will be run ONCE at the START of this [UnitFeature].
  final TestGroupFunction<SUT>? _setUpOnce;

  /// Code that will be run ONCE at the END of this [UnitFeature].
  final TestGroupFunction<SUT>? _tearDownOnce;

  /// Runs this [UnitFeature]'s [UnitScenario.test] methods.
  void test({
    String? testDescription,
    int? nrFeature,
    UnitMocks? mocks,
    SUT? systemUnderTest,
  }) {
    flutter_test.group(
      _description,
      () {
        final _mocks = mocks ?? UnitMocks();
        final _systemUnderTest = _systemUnderTestCallback?.call(_mocks);
        _setUpAndTeardown(mocks: _mocks, systemUnderTest: _systemUnderTest);
        for (int nrScenario = 0; nrScenario < _scenarios.length; nrScenario++) {
          _scenarios[nrScenario].test(
            featureDescription: _description,
            testDescription: testDescription,
            nrScenario: nrScenario,
            nrFeature: nrFeature,
            mocks: _mocks,
            systemUnderTest: _systemUnderTest ?? systemUnderTest,
          );
        }
      },
    );
  }

  /// Runs any provided [_setUpEach], [_setUpOnce], [_tearDownEach] and [_tearDownOnce] methods.
  void _setUpAndTeardown({
    required UnitMocks mocks,
    SUT? systemUnderTest,
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
