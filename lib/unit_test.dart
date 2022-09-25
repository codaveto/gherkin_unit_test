import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import '../../test_group_function.dart';
import 'unit_log.dart';

part 'unit_example.dart';
part 'unit_feature.dart';
part 'unit_scenario.dart';
part 'unit_step.dart';
part 'unit_box.dart';

/// Used to hold and test a list of [UnitFeature].
class UnitTest {
  UnitTest({
    required String description,
    required List<UnitFeature> features,
    TestGroupFunction? setUpEach,
    TestGroupFunction? tearDownEach,
    TestGroupFunction? setUpOnce,
    TestGroupFunction? tearDownOnce,
  })  : _description = description,
        _features = features,
        _setUpEach = setUpEach,
        _tearDownEach = tearDownEach,
        _setUpOnce = setUpOnce,
        _tearDownOnce = tearDownOnce;

  /// High-level description of the [UnitTest] and related [UnitFeature]s.
  final String _description;

  /// List of all testable features in your app.
  final List<UnitFeature> _features;

  /// Code that will run at the START of each [UnitScenario] under this [UnitTest]
  /// or at the START of EACH [UnitScenario._examples] under this [UnitTest].
  final TestGroupFunction? _setUpEach;

  /// Code that will run ONCE at the END of this [UnitScenario] under this [UnitTest]
  /// or ONCE at the END of EACH [UnitScenario._examples] under this [UnitTest].
  final TestGroupFunction? _tearDownEach;

  /// Code that will be run ONCE at the START of this [UnitTest].
  final TestGroupFunction? _setUpOnce;

  /// Code that will be run ONCE at the END of this [UnitTest].
  final TestGroupFunction? _tearDownOnce;

  /// Runs all [UnitTest._features] test methods.
  void test() {
    flutter_test.group(
      _description,
      () {
        _setUpAndTeardown();
        for (int nrFeature = 0; nrFeature < _features.length; nrFeature++) {
          _features[nrFeature].test(
            testDescription: _description,
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
