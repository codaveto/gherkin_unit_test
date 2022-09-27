import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

/// Used as a signature for test methods [setUp], [setUpAll], [tearDown] and [tearDownAll].
typedef TestGroupFunction<SUT> = FutureOr Function(
  UnitMocks mocks,
  SUT? systemUnderTest,
);
