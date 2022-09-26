import 'dart:math';

import 'package:example/gherkin_unit_test_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gherkin_unit_test/unit_test.dart';

import '../gherkin_unit_test_view_model_mock.dart';

class DecrementModelCounterScenario
    extends UnitScenario<GherkinUnitTestViewModel, UnitExample> {
  static const _originalCounterValue = 3;

  DecrementModelCounterScenario()
      : super(
          description: 'Decrement the modelCounter',
          systemUnderTest: (_) => GherkinUnitTestViewModelMock(),
          examples: [
            const UnitExample(values: [1]),
            const UnitExample(values: [5]),
            const UnitExample(values: [10]),
          ],
          steps: [
            Given(
              'The counter is at $_originalCounterValue',
              (systemUnderTest, log, box, mocks, [example]) {
                systemUnderTest.reset();
                for (int increment = 0;
                    increment < _originalCounterValue;
                    increment++) {
                  systemUnderTest.incrementModelCounter();
                }
                expect(systemUnderTest.modelCounter, _originalCounterValue);
              },
            ),
            When(
              'I decrement the counter',
              (systemUnderTest, log, box, mocks, [example]) {
                final int nrOfDecrements = example.firstValue();
                log.value(nrOfDecrements, 'Number of decrements');
                for (int decrement = 0;
                    decrement < nrOfDecrements;
                    decrement++) {
                  systemUnderTest.decrementModelCounter();
                }
                box.write('nrOfDecrements', nrOfDecrements);
              },
            ),
            Then(
              'We expect the modelCounter to have a '
              'decremented value of ($_originalCounterValue minus decrements) '
              'and (at least 0)',
              (systemUnderTest, log, box, mocks, [example]) {
                final int nrOfDecrements = box.read('nrOfDecrements');
                expect(
                  systemUnderTest.modelCounter,
                  max(_originalCounterValue - nrOfDecrements, 0),
                );
                log.success();
              },
            ),
          ],
        );
}
