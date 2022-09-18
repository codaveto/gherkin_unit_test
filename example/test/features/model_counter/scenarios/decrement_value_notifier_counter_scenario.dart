import 'dart:math';

import 'package:example/gherkin_unit_test_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../gherkin_unit_test_view_model_mock.dart';

class DecrementValueNotifierCounterScenario
    extends UnitScenario<GherkinUnitTestViewModel> {
  static const _originalCounterValue = 3;
  DecrementValueNotifierCounterScenario()
      : super(
          description: 'Decrement the ValueNotifier',
          systemUnderTest: () => GherkinUnitTestViewModelMock(),
          examples: [
            const UnitExample(values: [1]),
            const UnitExample(values: [5]),
            const UnitExample(values: [10]),
          ],
          steps: [
            Given(
              'The counter is at $_originalCounterValue',
              (systemUnderTest, log, [example, result]) {
                systemUnderTest.reset();
                for (int increment = 0;
                    increment < _originalCounterValue;
                    increment++) {
                  systemUnderTest.incrementValueNotifierCounter();
                }
                expect(systemUnderTest.valueListenableCounter.value,
                    _originalCounterValue);
              },
            ),
            When(
              'I decrement the counter',
              (systemUnderTest, log, [example, result]) {
                final int nrOfDecrements = example.firstValue();
                log.value(nrOfDecrements, 'Number of decrements');
                for (int decrement = 0;
                    decrement < nrOfDecrements;
                    decrement++) {
                  systemUnderTest.decrementValueNotifierCounter();
                }
                return nrOfDecrements;
              },
            ),
            Then(
              'We expect the ValueNotifier to have a '
              'decremented value of ($_originalCounterValue minus decrements) '
              'and (at least 0)',
              (systemUnderTest, log, [example, nrOfDecrements]) {
                expect(
                  systemUnderTest.valueListenableCounter.value,
                  max(_originalCounterValue - (nrOfDecrements as int), 0),
                );
                log.success();
              },
            ),
          ],
        );
}
