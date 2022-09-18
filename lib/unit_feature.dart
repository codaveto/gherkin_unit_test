part of 'unit_test.dart';

/// Used to specify and test a list of [UnitScenario].
class UnitFeature {
  const UnitFeature({
    required String description,
    required List<UnitScenario> scenarios,
    TestGroupFunction? setUpEach,
    TestGroupFunction? tearDownEach,
    TestGroupFunction? setUpOnce,
    TestGroupFunction? tearDownOnce,
  })  : _description = description,
        _scenarios = scenarios,
        _setUpEach = setUpEach,
        _tearDownEach = tearDownEach,
        _setUpOnce = setUpOnce,
        _tearDownOnce = tearDownOnce;

  /// High-level description of the [UnitFeature] and related [UnitScenario]s.
  final String _description;

  /// List that specifies all [UnitScenario]s for a given [UnitFeature].
  final List<UnitScenario> _scenarios;

  /// Code that will run at the START of each [UnitScenario] under this [UnitFeature]
  /// or at the START of EACH [UnitScenario._examples] under this [UnitFeature].
  final TestGroupFunction? _setUpEach;

  /// Code that will run ONCE at the END of this [UnitScenario] under this [UnitFeature]
  /// or ONCE at the END of EACH [UnitScenario._examples] under this [UnitFeature].
  final TestGroupFunction? _tearDownEach;

  /// Code that will be run ONCE at the START of this [UnitFeature].
  final TestGroupFunction? _setUpOnce;

  /// Code that will be run ONCE at the END of this [UnitFeature].
  final TestGroupFunction? _tearDownOnce;

  /// Runs this [UnitFeature]'s [UnitScenario.test] methods.
  void test({
    String? testDescription,
    required int nrFeature,
  }) {
    flutter_test.group(
      _description,
      () {
        _setUpAndTeardown();
        for (int nrScenario = 0; nrScenario < _scenarios.length; nrScenario++) {
          _scenarios[nrScenario].test(
            featureDescription: _description,
            testDescription: testDescription,
            nrScenario: nrScenario,
            nrFeature: nrFeature,
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
