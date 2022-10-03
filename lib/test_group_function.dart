import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

/// Used as a signature for test methods [setUp], [setUpAll], [tearDown] and [tearDownAll].
///
/// In this version of this signature the [systemUnderTest] is allowed to be null.
typedef TestGroupFunctionNullable<SUT> = FutureOr Function(
  UnitMocks mocks,
  SUT? systemUnderTest,
);

/// Used as a signature for test methods [setUp], [setUpAll], [tearDown] and [tearDownAll].
///
/// In this version of this signature the [systemUnderTest] is NOT allowed to be null.
typedef TestGroupFunction<SUT> = FutureOr Function(
  UnitMocks mocks,
  SUT systemUnderTest,
);
