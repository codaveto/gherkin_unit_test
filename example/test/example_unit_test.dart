import 'package:example/gherkin_unit_test_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import 'features/model_counter/scenarios/decrement_model_counter_scenario.dart';
import 'features/model_counter/scenarios/decrement_value_notifier_counter_scenario.dart';
import 'features/model_counter/scenarios/increment_model_counter_scenario.dart';
import 'features/model_counter/scenarios/increment_value_notifier_counter_scenario.dart';
import 'features/model_counter/scenarios/reset_model_counter_scenario.dart';
import 'features/model_counter/scenarios/reset_value_notifier_counter_scenario.dart';

void main() {
  UnitTest(
    description: 'A unit test to unit test the unit test example project',
    features: [
      UnitFeature(
        description: 'Model counter',
        scenarios: [
          IncrementModelCounterScenario(),
          DecrementModelCounterScenario(),
          ResetModelCounterScenario(),
          IncrementValueNotifierCounterScenario(),
          DecrementValueNotifierCounterScenario(),
          ResetValueNotifierCounterScenario(),
        ],
      ),
    ],
  ).test();
}
