import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:flutter_test/flutter_test.dart';

import '../../test_group_function.dart';
import 'unit_log.dart';

part 'unit_example.dart';
part 'unit_feature.dart';
part 'unit_scenario.dart';
part 'unit_step.dart';
part 'unit_box.dart';
part 'unit_mocks.dart';

/// Used to hold and test a list of [UnitFeature].
class UnitTest<SUT> {
  UnitTest({
    required String description,
    required List<UnitFeature> features,
    void Function(UnitMocks mocks)? setUpMocks,
    SUT Function(UnitMocks mocks)? systemUnderTest,
    TestGroupFunctionNullable<SUT>? setUpEach,
    TestGroupFunctionNullable<SUT>? tearDownEach,
    TestGroupFunctionNullable<SUT>? setUpOnce,
    TestGroupFunctionNullable<SUT>? tearDownOnce,
  })  : _description = description,
        _setUpMocks = setUpMocks,
        _systemUnderTestCallback = systemUnderTest,
        _features = features,
        _setUpEach = setUpEach,
        _tearDownEach = tearDownEach,
        _setUpOnce = setUpOnce,
        _tearDownOnce = tearDownOnce;

  /// High-level description of the [UnitTest] and related [UnitFeature]s.
  final String _description;

  /// Callback to set up mocks before any other logic is run.
  final void Function(UnitMocks mocks)? _setUpMocks;

  /// The callback to retrieve the system/unit that you are testing.
  final SUT Function(UnitMocks mocks)? _systemUnderTestCallback;

  /// List of all testable features in your app.
  final List<UnitFeature> _features;

  /// Code that will run at the START of each [UnitScenario] under this [UnitTest]
  /// or at the START of EACH [UnitScenario._examples] under this [UnitTest].
  final TestGroupFunctionNullable<SUT>? _setUpEach;

  /// Code that will run ONCE at the END of this [UnitScenario] under this [UnitTest]
  /// or ONCE at the END of EACH [UnitScenario._examples] under this [UnitTest].
  final TestGroupFunctionNullable<SUT>? _tearDownEach;

  /// Code that will be run ONCE at the START of this [UnitTest].
  final TestGroupFunctionNullable<SUT>? _setUpOnce;

  /// Code that will be run ONCE at the END of this [UnitTest].
  final TestGroupFunctionNullable<SUT>? _tearDownOnce;

  /// Runs all [UnitTest._features] test methods.
  void test() {
    flutter_test.group(
      _description,
      () {
        final mocks = UnitMocks();
        _setUpMocks?.call(mocks);
        final systemUnderTest = _systemUnderTestCallback?.call(mocks);
        _setUpAndTeardown(mocks: mocks, systemUnderTest: systemUnderTest);
        for (int nrFeature = 0; nrFeature < _features.length; nrFeature++) {
          _features[nrFeature].test(
            testDescription: _description,
            nrFeature: nrFeature,
            mocks: mocks,
            systemUnderTest: systemUnderTest,
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
